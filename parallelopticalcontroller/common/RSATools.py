# Copyright 2022-2025 ETSI SDG TeraFlowSDN (TFS) (https://tfs.etsi.org/)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""
RSA (Routing and Spectrum Assignment) Tools for TeraFlowSDN.

This module provides helper functions for RSA operations including:
- Band detection from frequency values
- Spectrum slot calculation
- Bitmap generation for slot availability

[CHAFI-THESIS-START]
"""

import logging
from common.ITUStandards import FreqeuncyRanges, Bands, Slots

LOGGER = logging.getLogger(__name__)


def detect_band(frequency_hz, min_frequency_hz=None, max_frequency_hz=None):
    """
    Detects the optical band based on frequency values.

    Algorithm: Finds the SMALLEST (narrowest) band that contains the frequency.
    This ensures we don't unnecessarily expand to wider bands.

    Priority order (smallest to largest):
    O, E, S, C, L -> CL -> SCL -> WHOLE_BAND

    Args:
        frequency_hz: Center frequency in Hz (from XML)
        min_frequency_hz: Optional minimum frequency in Hz (from XML, for future use)
        max_frequency_hz: Optional maximum frequency in Hz (from XML, for future use)

    Returns:
        dict: Contains band_name, band_enum_name, min_frequency, max_frequency, flex_slots, bitmap_value
              or None if no matching band found
    """
    # LOGGER.debug(
    #     f"[CHAFI-RSA] detect_band: frequency={frequency_hz}, min={min_frequency_hz}, max={max_frequency_hz}")

    if not frequency_hz:
        LOGGER.warning("[CHAFI-RSA] detect_band: No frequency provided")
        return None

    # If min/max are provided, use them to determine the band
    # Otherwise, use the center frequency to find which band it falls into
    if min_frequency_hz and max_frequency_hz:
        search_min = min_frequency_hz
        search_max = max_frequency_hz
        # LOGGER.debug(
        #     f"[CHAFI-RSA] Using provided min/max frequencies for band detection")
    else:
        # Use center frequency - find smallest band containing this frequency
        search_min = frequency_hz
        search_max = frequency_hz
        # LOGGER.debug(f"[CHAFI-RSA] Using center frequency for band detection")

    # Find the SMALLEST band that contains the frequency range
    band_matches = []

    for band_enum in FreqeuncyRanges:
        band_min_hz, band_max_hz = band_enum.value

        # Check if the frequency range falls within this band
        if (search_min >= band_min_hz and search_max <= band_max_hz):
            # Get the band name (e.g., "C_BAND" -> "C", "CL_BAND" -> "C, L")
            band_name = Bands[band_enum.name].value

            # Get the number of slots for this band
            band_slots = Slots[band_enum.name].value

            # Calculate band width (for sorting - we want SMALLEST band)
            band_width_hz = band_max_hz - band_min_hz

            band_matches.append({
                'band_name': band_name,
                'band_enum_name': band_enum.name,
                'min_frequency': band_min_hz,
                'max_frequency': band_max_hz,
                'flex_slots': band_slots,
                'band_width_hz': band_width_hz  # Used for sorting only
            })

            # LOGGER.debug(
            #     f"[CHAFI-RSA] Band match: {band_name} ({band_min_hz} - {band_max_hz} Hz, {band_slots} slots)")

    # If we have matches, return the SMALLEST/NARROWEST band that fits
    if band_matches:
        # Sort by band width (ascending) - prefer narrowest band
        band_matches.sort(key=lambda x: x['band_width_hz'])
        best_match = band_matches[0]

        # LOGGER.info(
        #     f"[CHAFI-RSA] Selected band: {best_match['band_name']} ({best_match['flex_slots']} slots)")

        # Remove internal sorting key before returning
        del best_match['band_width_hz']
        return best_match

    LOGGER.warning(
        f"[CHAFI-RSA] No matching band found for frequency {frequency_hz}")
    return None


def compute_rsa_params(frequency_hz, min_frequency_hz=None, max_frequency_hz=None):
    """
    Computes RSA parameters for a channel based on its frequency.

    This is the main helper function called from transponders.py.

    Args:
        frequency_hz: Center frequency in Hz (from XML)
        min_frequency_hz: Optional minimum frequency in Hz (from XML, for future use)
        max_frequency_hz: Optional maximum frequency in Hz (from XML, for future use)

    Returns:
        dict: Contains min_frequency, max_frequency, flex_slots, bitmap_value
              or None if computation fails
    """
    # LOGGER.debug(
    #     f"[CHAFI-RSA] compute_rsa_params: freq={frequency_hz}, min={min_frequency_hz}, max={max_frequency_hz}")

    if not frequency_hz:
        LOGGER.warning(
            "[CHAFI-RSA] compute_rsa_params: No frequency provided, skipping RSA computation")
        return None

    # Step 1: Detect the band
    band_info = detect_band(frequency_hz, min_frequency_hz, max_frequency_hz)

    if not band_info:
        LOGGER.warning(
            "[CHAFI-RSA] compute_rsa_params: Could not detect band, skipping RSA computation")
        return None

    # Step 2: Calculate bitmap value (all slots available initially)
    # bitmap_value = 2^flex_slots - 1 (all bits set to 1)
    flex_slots = band_info['flex_slots']
    bitmap_value = (1 << flex_slots) - 1

    # LOGGER.info(f"[CHAFI-RSA] compute_rsa_params: band={band_info['band_name']}, "
    #             f"min={band_info['min_frequency']}, max={band_info['max_frequency']}, "
    #             f"slots={flex_slots}, bitmap_bits={flex_slots}")

    # Step 3: Return RSA parameters
    result = {
        'min_frequency': band_info['min_frequency'],
        'max_frequency': band_info['max_frequency'],
        'flex_slots': flex_slots,
        # Store as string for large integer support
        'bitmap_value': str(bitmap_value)
    }

    # LOGGER.debug(f"[CHAFI-RSA] compute_rsa_params: result={result}")
    return result


def detect_band_for_display(min_frequency_hz, max_frequency_hz):
    """
    Detects the optical band and returns display-ready information including wavelength range.

    Used by WebUI to show band information with wavelength range.

    Args:
        min_frequency_hz: Minimum frequency in Hz
        max_frequency_hz: Maximum frequency in Hz

    Returns:
        dict: Contains band_name, band_enum_name, wavelength_range, frequency_range_hz
              or None if no matching band found
    """
    from common.ITUStandards import Lambdas

    # LOGGER.debug(
    #     f"[CHAFI-RSA] detect_band_for_display: min={min_frequency_hz}, max={max_frequency_hz}")

    if not min_frequency_hz or not max_frequency_hz:
        LOGGER.warning(
            "[CHAFI-RSA] detect_band_for_display: No frequency range provided")
        return None

    # Find the SMALLEST band that contains the frequency range
    band_matches = []

    for band_enum in FreqeuncyRanges:
        band_min_hz, band_max_hz = band_enum.value

        # Check if the frequency range falls within this band
        if (min_frequency_hz >= band_min_hz and max_frequency_hz <= band_max_hz):
            band_name = Bands[band_enum.name].value
            wavelength_range = Lambdas[band_enum.name].value
            frequency_range_hz = band_enum.value
            band_width_hz = band_max_hz - band_min_hz

            band_matches.append({
                'band_name': band_name,
                'band_enum_name': band_enum.name,
                'wavelength_range': wavelength_range,
                'frequency_range_hz': frequency_range_hz,
                'band_width_hz': band_width_hz
            })

    if band_matches:
        band_matches.sort(key=lambda x: x['band_width_hz'])
        best_match = band_matches[0]
        del best_match['band_width_hz']
        # LOGGER.info(
        #     f"[CHAFI-RSA] detect_band_for_display: Selected {best_match['band_name']}-Band")
        return best_match

    LOGGER.warning(
        f"[CHAFI-RSA] detect_band_for_display: No matching band found")
    return None


def build_spectrum_slot_table(channel_data, band_info):
    """
    Builds a spectrum slot table showing all standard band slots with availability status.

    Used by WebUI to display the spectrum allocation table.

    Args:
        channel_data: Dict with min_frequency, max_frequency, flex_slots, bitmap_value
        band_info: Band information dict from detect_band_for_display()

    Returns:
        list: List of dicts with keys: frequency (Hz), availability (str), is_anchor (bool)
    """
    from common.ITUStandards import ITUStandards, SlotStatus

    # LOGGER.debug(
    #     f"[CHAFI-RSA] build_spectrum_slot_table: channel_data={channel_data}")

    if not channel_data or not band_info:
        return []

    # Get ITU standards
    slot_granularity_hz = ITUStandards.SLOT_GRANULARITY.value
    anchor_frequency_hz = ITUStandards.ANCHOR_FREQUENCY.value

    # Get operational band range (standard min/max for the band)
    band_min_hz, band_max_hz = band_info['frequency_range_hz']

    # Calculate standard slots for the full band
    operational_bandwidth_hz = band_max_hz - band_min_hz
    standard_slots = int(operational_bandwidth_hz / slot_granularity_hz)

    # Get channel data
    channel_min_hz = channel_data.get('min_frequency')
    channel_max_hz = channel_data.get('max_frequency')
    channel_slots = channel_data.get('flex_slots', 0)
    bitmap_value_str = channel_data.get('bitmap_value', '0')
    bitmap_value = int(bitmap_value_str) if bitmap_value_str else 0

    # Build slot table
    slot_table = []

    for slot_index in range(standard_slots):
        # Calculate frequency for this slot
        frequency_hz = band_min_hz + (slot_index * slot_granularity_hz)

        # Check if this is the anchor frequency (193.1 THz)
        is_anchor = abs(
            frequency_hz - anchor_frequency_hz) < (slot_granularity_hz / 2)

        # Determine availability status
        availability = _determine_slot_availability(
            frequency_hz,
            channel_min_hz,
            channel_max_hz,
            slot_granularity_hz,
            bitmap_value,
            channel_slots
        )

        slot_table.append({
            'frequency': frequency_hz,
            'availability': availability,
            'is_anchor': is_anchor
        })

    # LOGGER.debug(
    #     f"[CHAFI-RSA] build_spectrum_slot_table: Generated {len(slot_table)} slots")
    return slot_table


def _determine_slot_availability(frequency_hz, channel_min_hz, channel_max_hz,
                                 slot_granularity_hz, bitmap_value, channel_flex_slots=None):
    """
    Determines the availability status of a specific frequency slot.

    Args:
        frequency_hz: Frequency of the slot being evaluated
        channel_min_hz: Minimum frequency supported by channel
        channel_max_hz: Maximum frequency supported by channel
        slot_granularity_hz: Slot granularity from ITU standards
        bitmap_value: Bitmap representing slot usage (LSB = channel_min)
        channel_flex_slots: Number of slots in channel's bitmap

    Returns:
        str: Status value (UNAVAILABLE, AVAILABLE, IN_USE)
    """
    from common.ITUStandards import SlotStatus

    if not channel_min_hz or not channel_max_hz:
        return SlotStatus.UNAVAILABLE.value

    # Case 1: Frequency outside channel capability range
    if frequency_hz < channel_min_hz or frequency_hz >= channel_max_hz:
        return SlotStatus.UNAVAILABLE.value

    # Case 2: Frequency within channel range - check bitmap
    bit_position = int((frequency_hz - channel_min_hz) / slot_granularity_hz)

    # Case 2a: Bit position exceeds channel's flex_slots (safety check)
    if channel_flex_slots is not None and bit_position >= channel_flex_slots:
        return SlotStatus.UNAVAILABLE.value

    # Extract bit value (LSB ordering)
    # Bit = 1 means AVAILABLE (free), Bit = 0 means IN_USE (allocated)
    bit_value = (bitmap_value >> bit_position) & 1

    if bit_value == 1:
        return SlotStatus.AVAILABLE.value
    else:
        return SlotStatus.IN_USE.value


def fetch_channel_data_for_endpoint(device_uuid, endpoint_identifier, device_type, context_client):
    """
    [CHAFI-THESIS] Universal function to fetch channel data for any endpoint (Transponder or ROADM).

    This is a shared function that can be used by any service (parallelopticalcontroller, webui, etc.)
    to fetch channel frequency information from OpticalConfig.

    Args:
        device_uuid: Device UUID string
        endpoint_identifier: endpoint.index (for transponder) or endpoint.name (for ROADM)
        device_type: Device type string (e.g., 'optical-transponder', 'optical-roadm')
        context_client: ContextClient instance (already connected)

    Returns:
        dict: {
            'channel_data': {min_frequency, max_frequency, flex_slots, bitmap_value, frequency},
            'band_name': str (e.g., 'S, C, L')
        } or None if channel data not found
    """
    import json
    from common.proto.context_pb2 import OpticalConfigId
    from common.tools.context_queries.OpticalConfig import opticalconfig_uuid_get_duuid
    from common.DeviceTypes import DeviceTypeEnum

    # LOGGER.debug(
    #     f"[CHAFI-RSATools.py] fetch_channel_data_for_endpoint: device={device_uuid}, endpoint={endpoint_identifier}, type={device_type}")

    try:
        # Step 1: Compute opticalconfig_uuid from device_uuid
        opticalconfig_uuid = opticalconfig_uuid_get_duuid(device_uuid)

        # Step 2: Fetch OpticalConfig using ContextClient
        opticalconfig_id = OpticalConfigId()
        opticalconfig_id.opticalconfig_uuid = opticalconfig_uuid

        opticalconfig = context_client.SelectOpticalConfig(opticalconfig_id)

        if not opticalconfig or not opticalconfig.opticalconfig_id.opticalconfig_uuid:
            LOGGER.warning(
                f"[CHAFI-RSA] No optical config found for device {device_uuid}")
            return None

        # Step 3: Parse config JSON
        config = json.loads(opticalconfig.config) if isinstance(
            opticalconfig.config, str) else opticalconfig.config

        # Step 4: Match channel based on device type
        target_channel = None

        if device_type in [DeviceTypeEnum.OPTICAL_TRANSPONDER.value, DeviceTypeEnum.EMULATED_OPTICAL_TRANSPONDER.value]:
            # Transponder: Match by endpoint.index
            # Build endpoint_map: endpoint_index -> channel_name
            endpoint_map = {}
            for ep in config.get('endpoints', []):
                if isinstance(ep, dict):
                    ep_uuid = ep.get('endpoint_uuid', {})
                    if isinstance(ep_uuid, dict):
                        ep_idx = ep_uuid.get('index')
                        ep_chn = ep_uuid.get('channel')
                        if ep_idx and ep_chn:
                            endpoint_map[ep_idx] = ep_chn

            # Build channel_map: channel_name -> channel_data
            channel_map = {}
            for ch in config.get('channels', []):
                ch_name_data = ch.get('name', {})
                if isinstance(ch_name_data, dict):
                    ch_name = ch_name_data.get('index')
                    if ch_name:
                        channel_map[ch_name] = ch

            # Lookup: endpoint_index -> channel_name -> channel_data
            target_channel_name = endpoint_map.get(endpoint_identifier)
            if target_channel_name:
                target_channel = channel_map.get(target_channel_name)

        elif device_type in [DeviceTypeEnum.OPTICAL_ROADM.value, DeviceTypeEnum.EMULATED_OPTICAL_ROADM.value,
                             DeviceTypeEnum.OPEN_ROADM.value, DeviceTypeEnum.EMULATED_OPEN_ROADM.value]:
            # ROADM: Match by endpoint.name (channel_index == endpoint_name)
            for channel in config.get('channels', []):
                ch_index = channel.get('channel_index')
                if not ch_index and isinstance(channel.get('name'), dict):
                    ch_index = channel['name'].get('index')

                if str(ch_index) == str(endpoint_identifier):
                    target_channel = channel
                    break

        # Step 5: Extract channel data
        if target_channel:
            # Get frequency data - field names differ by device type:
            # Transponder: min_frequency, max_frequency
            # ROADM: lower_frequency, upper_frequency
            if device_type in [DeviceTypeEnum.OPTICAL_TRANSPONDER.value, DeviceTypeEnum.EMULATED_OPTICAL_TRANSPONDER.value]:
                min_freq = target_channel.get('min_frequency')
                max_freq = target_channel.get('max_frequency')
            else:
                # ROADM types use lower/upper frequency
                min_freq = target_channel.get('lower_frequency')
                max_freq = target_channel.get('upper_frequency')

            flex_slots = target_channel.get('flex_slots')
            bitmap_value = target_channel.get('bitmap_value', '0')

            if min_freq and max_freq:
                channel_data = {
                    'frequency': int((int(min_freq) + int(max_freq)) / 2),
                    'min_frequency': int(min_freq),
                    'max_frequency': int(max_freq),
                    'flex_slots': flex_slots,
                    'bitmap_value': str(bitmap_value)
                }

                # Detect band
                band_info = detect_band_for_display(
                    int(min_freq), int(max_freq))
                band_name = band_info['band_name'] if band_info else None

                # LOGGER.info(
                #     f"[CHAFI-RSA] Channel data found: device={device_uuid}, endpoint={endpoint_identifier}, band={band_name}, slots={flex_slots}")

                return {
                    'channel_data': channel_data,
                    'band_name': band_name
                }
            else:
                LOGGER.warning(
                    f"[CHAFI-RSA] Channel found but missing frequency data: {device_uuid}:{endpoint_identifier}")
        else:
            LOGGER.warning(
                f"[CHAFI-RSA] No channel match for endpoint: {device_uuid}:{endpoint_identifier}")

        return None

    except Exception as e:
        LOGGER.error(f"[CHAFI-RSA] fetch_channel_data_for_endpoint error: {e}")
        import traceback
        LOGGER.error(traceback.format_exc())
        return None

# [CHAFI-THESIS-END]
