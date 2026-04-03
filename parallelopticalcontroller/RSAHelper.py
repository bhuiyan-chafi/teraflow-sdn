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
[CHAFI-THESIS-START]
RSA Helper Module for Parallel Optical Controller

This module provides RSA (Routing and Spectrum Assignment) computation functions
adapted from thesis/rsa_project/helpers.py for use with TeraFlowSDN.

Key adaptations:
- Uses in-memory cache instead of SQLAlchemy queries
- EndpointData adapter class to match rsa_project's Endpoint model interface
- OpticalLinksCache for efficient lookup by link_uuid and endpoint_uuid

Classes:
    - EndpointData: Adapter class wrapping endpoint dict as object
    - OpticalLinksCache: In-memory cache for optical links data
    - OpticalBandHelper: Band detection using ITUStandards
    - TopologyHelper: RSA computation functions
[CHAFI-THESIS-END]
"""

import logging
import math
from typing import Dict, List, Tuple, Optional, Any

# [CHAFI-THESIS] Import ITUStandards from common (TeraFlowSDN's version)
from common.ITUStandards import (
    ITUStandards, FreqeuncyRanges, Bands, Lambdas, FrequencyMeasurementUnit
)

# Configure logging
LOGGER = logging.getLogger(__name__)


# =============================================================================
# [CHAFI-THESIS] ENDPOINT DATA ADAPTER
# =============================================================================
# Adapts the dict structure from fetch_optical_links_for_rsa() to match
# rsa_project's Endpoint model interface (attributes like min_frequency, etc.)
# =============================================================================

class EndpointData:
    """
    [CHAFI-THESIS] Adapter class to match rsa_project's Endpoint model interface.

    Wraps the endpoint dict from fetch_optical_links_for_rsa() to provide
    attribute-style access like the SQLAlchemy Endpoint model.

    Attributes:
        name: Endpoint name (e.g., "port-11")
        endpoint_uuid: Endpoint UUID
        device_uuid: Device UUID
        device_name: Device name (e.g., "TP2")
        device_type: Device type (e.g., "optical-transponder")
        min_frequency: Minimum frequency in Hz
        max_frequency: Maximum frequency in Hz
        flex_slots: Number of slots in bitmap
        bitmap_value: Integer representing slot availability
    """

    def __init__(self, endpoint_dict: Dict):
        """
        Initialize EndpointData from endpoint dict.

        Args:
            endpoint_dict: Dict with endpoint info including channel_data
        """
        channel = endpoint_dict.get('channel_data') or {}

        self.name = endpoint_dict.get('endpoint_name')
        self.endpoint_uuid = endpoint_dict.get('endpoint_uuid')
        self.device_uuid = endpoint_dict.get('device_uuid')
        self.device_name = endpoint_dict.get('device_name')
        self.device_type = endpoint_dict.get('device_type')
        self.endpoint_index = endpoint_dict.get('endpoint_index')
        self.transport_type = endpoint_dict.get('transport_type')

        # [CHAFI-THESIS] RSA frequency fields from channel_data
        self.min_frequency = channel.get('min_frequency')
        self.max_frequency = channel.get('max_frequency')
        self.flex_slots = channel.get('flex_slots')

        # bitmap_value is stored as string in channel_data, convert to int
        bitmap_str = channel.get('bitmap_value')
        if bitmap_str:
            try:
                self.bitmap_value = int(bitmap_str)
            except (ValueError, TypeError):
                self.bitmap_value = 0
        else:
            self.bitmap_value = 0

    def __repr__(self):
        return f"EndpointData(name={self.name}, device={self.device_name}, flex_slots={self.flex_slots})"


# =============================================================================
# [CHAFI-THESIS] OPTICAL LINKS CACHE
# =============================================================================
# In-memory cache for optical links data, indexed by link_uuid and endpoint_uuid
# =============================================================================

class OpticalLinksCache:
    """
    [CHAFI-THESIS] In-memory cache for optical links data.

    Provides efficient lookup by link_uuid and endpoint_uuid, replacing
    SQLAlchemy queries used in rsa_project.
    """

    def __init__(self, optical_links: List[Dict]):
        """
        Initialize cache from list of optical link dicts.

        Args:
            optical_links: List from fetch_optical_links_for_rsa()
        """
        self._links = {}  # link_uuid -> link dict
        self._endpoints = {}  # endpoint_uuid -> EndpointData
        self._endpoints_by_device = {}  # device_uuid -> List[EndpointData]

        self._build_index(optical_links)

    def _build_index(self, optical_links: List[Dict]):
        """Build lookup indexes from optical links list."""
        for link in optical_links:
            link_uuid = link.get('link_uuid')
            if link_uuid:
                self._links[link_uuid] = link

            # Index endpoints
            for ep_dict in link.get('endpoints', []):
                ep_uuid = ep_dict.get('endpoint_uuid')
                device_uuid = ep_dict.get('device_uuid')

                if ep_uuid:
                    endpoint_data = EndpointData(ep_dict)
                    self._endpoints[ep_uuid] = endpoint_data

                    # Index by device
                    if device_uuid:
                        if device_uuid not in self._endpoints_by_device:
                            self._endpoints_by_device[device_uuid] = []
                        self._endpoints_by_device[device_uuid].append(
                            endpoint_data)

        # LOGGER.info(
        #     f"[CHAFI-RSA-CACHE] Built cache: {len(self._links)} links, "
        #     f"{len(self._endpoints)} endpoints, {len(self._endpoints_by_device)} devices")

    def get_link(self, link_uuid: str) -> Optional[Dict]:
        """Get link dict by UUID."""
        return self._links.get(link_uuid)

    def get_endpoint(self, endpoint_uuid: str) -> Optional[EndpointData]:
        """Get EndpointData by UUID."""
        return self._endpoints.get(endpoint_uuid)

    def get_endpoints_by_device(self, device_uuid: str) -> List[EndpointData]:
        """Get all EndpointData for a device (for parallel endpoint constraint)."""
        return self._endpoints_by_device.get(device_uuid, [])

    def get_links_between_devices(self, src_device_uuid: str, dst_device_uuid: str) -> List[Dict]:
        """
        Get all links between a specific device pair (for parallel link detection).

        Args:
            src_device_uuid: Source device UUID
            dst_device_uuid: Destination device UUID

        Returns:
            List of link dictionaries where src matches src_device_uuid AND dst matches dst_device_uuid
        """
        parallel_links = []
        for link in self._links.values():
            endpoints = link.get('endpoints', [])
            if len(endpoints) >= 2:
                link_src_uuid = endpoints[0].get('device_uuid')
                link_dst_uuid = endpoints[1].get('device_uuid')

                if link_src_uuid == src_device_uuid and link_dst_uuid == dst_device_uuid:
                    parallel_links.append(link)

        return parallel_links

    def get_all_endpoints(self) -> List[EndpointData]:
        """Get all endpoints in cache."""
        return list(self._endpoints.values())


# =============================================================================
# [CHAFI-THESIS] OPTICAL BAND HELPER
# =============================================================================
# Copied from rsa_project/helpers.py, uses TeraFlowSDN's ITUStandards
# =============================================================================

class OpticalBandHelper:
    """[CHAFI-THESIS] Helper for optical band detection using ITU standards."""

    @staticmethod
    def detect_band(min_frequency_hz: int, max_frequency_hz: int) -> Optional[Dict]:
        """
        Detects the optical band based on min and max frequencies.

        Finds the SMALLEST (narrowest) band that contains the frequency range.

        Args:
            min_frequency_hz: Minimum frequency in Hz
            max_frequency_hz: Maximum frequency in Hz

        Returns:
            dict: Contains band_name, band_enum_name, wavelength_range, frequency_range_hz
        """
        if not min_frequency_hz or not max_frequency_hz:
            return None

        band_matches = []

        for band_enum in FreqeuncyRanges:
            band_min_hz, band_max_hz = band_enum.value

            # Check if frequency range falls within this band (exact match, no tolerance)
            if (min_frequency_hz >= band_min_hz and
                    max_frequency_hz <= band_max_hz):

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

        # Return smallest band that fits
        if band_matches:
            band_matches.sort(key=lambda x: x['band_width_hz'])
            best_match = band_matches[0]
            del best_match['band_width_hz']
            return best_match

        return None


# =============================================================================
# [CHAFI-THESIS] TOPOLOGY HELPER - RSA COMPUTATION
# =============================================================================
# Adapted from rsa_project/helpers.py, uses OpticalLinksCache instead of DB queries
# =============================================================================

class TopologyHelper:
    """[CHAFI-THESIS] Helper class for RSA computation functions."""

    @staticmethod
    def int_to_bitmap(value: int, length: int = 20) -> str:
        """Converts an integer to a binary string bitmap."""
        if value is None:
            return "0" * length
        try:
            val_int = int(value)
            return format(val_int, f'0{length}b')
        except (ValueError, TypeError):
            return "0" * length

    @staticmethod
    def align_endpoint_to_reference(
        endpoint: EndpointData,
        selected_min_freq: int,
        selected_max_freq: int,
        slot_granularity_hz: int
    ) -> int:
        """
        Aligns an endpoint's bitmap to the reference frequency range.

        Pads the endpoint bitmap with zeros to match the reference range,
        enabling proper intersection across devices with different frequency capabilities.

        Args:
            endpoint: EndpointData instance
            selected_min_freq: Reference range minimum frequency (Hz)
            selected_max_freq: Reference range maximum frequency (Hz)
            slot_granularity_hz: ITU slot granularity (6.25 GHz in Hz)

        Returns:
            int: Aligned bitmap value with zero-padding at both ends
        """
        if not endpoint or not endpoint.min_frequency or not endpoint.max_frequency or not endpoint.bitmap_value:
            return 0

        # Calculate reference width
        reference_slots = int(
            (selected_max_freq - selected_min_freq) / slot_granularity_hz)

        # Use endpoint's flex_slots
        endpoint_slots = endpoint.flex_slots if endpoint.flex_slots else 0

        # Calculate low-end offset
        low_offset_hz = endpoint.min_frequency - selected_min_freq
        low_offset_slots = int(low_offset_hz / slot_granularity_hz)

        # Handle negative offset
        if low_offset_slots < 0:
            LOGGER.warning(
                f"[RSA Align] Endpoint {endpoint.name} starts before reference range")
            trim_slots = abs(low_offset_slots)
            endpoint_bitmap = endpoint.bitmap_value >> trim_slots
            low_offset_slots = 0
        else:
            endpoint_bitmap = endpoint.bitmap_value

        # Step 1: Mask to endpoint width
        endpoint_width_mask = (1 << endpoint_slots) - 1
        endpoint_bitmap &= endpoint_width_mask

        # Step 2: Shift left by offset
        aligned_bitmap = endpoint_bitmap << low_offset_slots

        # Step 3: Mask to reference width
        reference_mask = (1 << reference_slots) - 1
        aligned_bitmap &= reference_mask

        # LOGGER.debug(
        #     f"[RSA Align] {endpoint.name}: low_offset={low_offset_slots}, "
        #     f"endpoint_slots={endpoint_slots}, ref_slots={reference_slots}")

        return aligned_bitmap
    # [legacy function, not used anymore]

    @staticmethod
    def get_device_available_bitmap(
        device_uuid: str,
        reference_endpoint_uuid: str,
        selected_min_freq: int,
        selected_max_freq: int,
        slot_granularity_hz: int,
        cache: OpticalLinksCache
    ) -> Tuple[int, List[Dict]]:
        """
        Computes available spectrum for a device by intersecting ALL its endpoint bitmaps.

        Enforces parallel endpoint constraint: ROADM WSS cannot reuse frequencies
        across different output ports.

        Args:
            device_uuid: UUID of the device
            reference_endpoint_uuid: The specific endpoint in the path
            selected_min_freq: Reference range minimum frequency (Hz)
            selected_max_freq: Reference range maximum frequency (Hz)
            slot_granularity_hz: ITU slot granularity (6.25 GHz in Hz)
            cache: OpticalLinksCache instance

        Returns:
            tuple: (device_bitmap, endpoint_traces)
        """
        # Get all endpoints for this device from cache
        all_endpoints = cache.get_endpoints_by_device(device_uuid)

        # LOGGER.info(
        #     f"[RSA Device] Processing device {device_uuid}: Found {len(all_endpoints)} endpoints")

        # Initialize with all available
        reference_slots = int(
            (selected_max_freq - selected_min_freq) / slot_granularity_hz)
        device_bitmap = (1 << reference_slots) - 1

        endpoint_traces = []

        for endpoint in all_endpoints:
            # Align endpoint to reference range
            aligned_bitmap = TopologyHelper.align_endpoint_to_reference(
                endpoint, selected_min_freq, selected_max_freq, slot_granularity_hz
            )

            # Intersect with device bitmap
            device_bitmap &= aligned_bitmap

            # Track for trace visualization
            is_path_endpoint = (endpoint.endpoint_uuid ==
                                reference_endpoint_uuid)
            endpoint_traces.append({
                'endpoint_name': endpoint.name,
                'is_path_endpoint': is_path_endpoint,
                'min_freq_thz': endpoint.min_frequency / 1e12 if endpoint.min_frequency else None,
                'max_freq_thz': endpoint.max_frequency / 1e12 if endpoint.max_frequency else None,
                'flex_slots': endpoint.flex_slots if endpoint.flex_slots else 0,
                'original_bitmap': TopologyHelper.int_to_bitmap(
                    endpoint.bitmap_value, endpoint.flex_slots if endpoint.flex_slots else 0),
                'aligned_bitmap': TopologyHelper.int_to_bitmap(aligned_bitmap, reference_slots)
            })

            # LOGGER.debug(
            #     f"[RSA Device] Endpoint {endpoint.name} "
            #     f"({'PATH' if is_path_endpoint else 'OTHER'}): aligned and intersected")

        # LOGGER.info(
        #     f"[RSA Device] Device {device_uuid}: {len(endpoint_traces)} endpoints processed")

        return device_bitmap, endpoint_traces

    @staticmethod
    def rsa_bitmap_pre_compute(
        path_obj: Dict,
        cache: OpticalLinksCache
    ) -> Tuple[Optional[int], int, List[Dict], Optional[Dict]]:
        """
        Computes available spectrum using reference bitmap alignment.

        - Collects all unique endpoints in path
        - Calculates widest frequency range (reference range)
        - Detects operational band (C, CL, SCL, etc.)
        - Aligns all endpoint bitmaps to reference range
        - Enforces device-level parallel endpoint constraints
        - Intersects across all hops to find available spectrum

        Args:
            path_obj: Path object with 'links' list
            cache: OpticalLinksCache instance

        Returns:
            tuple: (reference_bitmap, reference_slots, trace_steps, band_info)
        """
        if not path_obj.get('links'):
            LOGGER.error("[RSA Pre-Compute] No links in path")
            return None, 0, [], None

        # LOGGER.info("[RSA Pre-Compute] Starting reference bitmap computation")

        # Step 1: Collect all unique endpoints in path
        endpoint_uuids = set()
        for link_info in path_obj['links']:
            link_uuid = link_info.get('id')
            link = cache.get_link(link_uuid)
            if link:
                for ep in link.get('endpoints', []):
                    ep_uuid = ep.get('endpoint_uuid')
                    if ep_uuid:
                        endpoint_uuids.add(ep_uuid)

        endpoints = [cache.get_endpoint(uuid) for uuid in endpoint_uuids]
        endpoints = [ep for ep in endpoints if ep]  # Filter None

        if not endpoints:
            LOGGER.error(
                "[RSAHelper:rsa_bitmap_pre_compute] No valid endpoints found in path")
            return None, 0, [], None

        # LOGGER.info(
        #     f"[RSAHelper:rsa_bitmap_pre_compute] Found {len(endpoints)} unique endpoints in path")

        # Step 2: Calculate reference frequency range (widest range)
        valid_endpoints = [
            ep for ep in endpoints if ep.min_frequency and ep.max_frequency]
        if not valid_endpoints:
            LOGGER.error(
                "[RSAHelper:rsa_bitmap_pre_compute] No endpoints with valid frequency data")
            return None, 0, [], None

        reference_min_freq = min([ep.min_frequency for ep in valid_endpoints])
        reference_max_freq = max([ep.max_frequency for ep in valid_endpoints])

        # Step 3: Detect operational band
        band_info = OpticalBandHelper.detect_band(
            reference_min_freq, reference_max_freq)
        if not band_info:
            LOGGER.error(
                "[RSAHelper:rsa_bitmap_pre_compute] Could not detect operational band")
            return None, 0, [], None

        # Use STANDARD band range as reference
        selected_min_freq, selected_max_freq = band_info['frequency_range_hz']
        slot_granularity_hz = ITUStandards.SLOT_GRANULARITY.value
        reference_slots = int(
            (selected_max_freq - selected_min_freq) / slot_granularity_hz)

        # LOGGER.info(
        #     f"[RSAHelper:rsa_bitmap_pre_compute] Band: {band_info['band_name']}, "
        #     f"Range: {reference_min_freq/1e12:.6f}-{reference_max_freq/1e12:.6f} THz, "
        #     f"Standard: {selected_min_freq/1e12:.6f}-{selected_max_freq/1e12:.6f} THz, "
        #     f"Slots: {reference_slots}")

        # Step 4: Initialize reference bitmap (all available)
        reference_bitmap = (1 << reference_slots) - 1

        trace_steps = []

        # Step 5: Iterate through hops with device-level parallel endpoint checking
        for i, link_info in enumerate(path_obj['links']):
            link_uuid = link_info.get('id')
            hop_label = f"{link_info.get('src')} -> {link_info.get('dst')}"

            # LOGGER.info(f"[RSAHelper:rsa_bitmap_pre_compute] Processing Hop {i+1}: {hop_label}")

            # Get link from cache
            link = cache.get_link(link_uuid)
            if not link or len(link.get('endpoints', [])) < 2:
                LOGGER.error(
                    f"[RSAHelper:rsa_bitmap_pre_compute] Link {link_uuid} or its endpoints not found")
                continue

            endpoints_list = link.get('endpoints', [])
            src_ep = endpoints_list[0]
            dst_ep = endpoints_list[1]

            src_device_uuid = src_ep.get('device_uuid')
            dst_device_uuid = dst_ep.get('device_uuid')
            src_endpoint_uuid = src_ep.get('endpoint_uuid')
            dst_endpoint_uuid = dst_ep.get('endpoint_uuid')

            # Query all links between this specific device pair (parallel link detection)
            parallel_links = cache.get_links_between_devices(
                src_device_uuid, dst_device_uuid)
            # LOGGER.info(
            #     f"[RSAHelper:perform_rsa] Found {len(parallel_links)} link(s) between devices")

            # Collect endpoints from parallel links only
            src_endpoints = []
            dst_endpoints = []
            for plink in parallel_links:
                plink_eps = plink.get('endpoints', [])
                if len(plink_eps) >= 2:
                    src_ep_uuid = plink_eps[0].get('endpoint_uuid')
                    dst_ep_uuid = plink_eps[1].get('endpoint_uuid')

                    src_ep_data = cache.get_endpoint(src_ep_uuid)
                    dst_ep_data = cache.get_endpoint(dst_ep_uuid)

                    if src_ep_data:
                        src_endpoints.append(src_ep_data)
                    if dst_ep_data:
                        dst_endpoints.append(dst_ep_data)

            # Initialize bitmaps with all available
            src_device_bitmap = (1 << reference_slots) - 1
            dst_device_bitmap = (1 << reference_slots) - 1
            src_traces = []
            dst_traces = []

            # [CHAFI-RSA-SLOT] List to store acquisition metadata for this path
            # We initialize it outside the loop but here we append hop-specific data
            if 'acquisition_in_path' not in locals():
                acquisition_in_path = []

            # Process source endpoints (intersect only parallel link endpoints)
            for endpoint in src_endpoints:
                aligned_bitmap = TopologyHelper.align_endpoint_to_reference(
                    endpoint, selected_min_freq, selected_max_freq, slot_granularity_hz
                )
                src_device_bitmap &= aligned_bitmap

                # Check if this endpoint is part of the selected path
                is_path_endpoint = (
                    endpoint.endpoint_uuid == src_endpoint_uuid)

                if is_path_endpoint:
                    # [CHAFI-RSA-SLOT] Store metadata for slot acquisition
                    # Calculate offset: (endpoint_min - reference_min) / granularity
                    ep_min_hz = endpoint.min_frequency if endpoint.min_frequency else selected_min_freq
                    offset_slots = int(
                        (ep_min_hz - selected_min_freq) / slot_granularity_hz)

                    acquisition_in_path.append({
                        'endpoint_uuid': endpoint.endpoint_uuid,
                        'device_uuid': endpoint.device_uuid,
                        'device_type': endpoint.device_type,
                        'endpoint_name': endpoint.name,
                        'endpoint_index': endpoint.endpoint_index,
                        'aligned_bitmap': TopologyHelper.int_to_bitmap(aligned_bitmap, reference_slots),
                        'offset_slots': offset_slots,
                        'native_flex_slots': endpoint.flex_slots if endpoint.flex_slots else 0,
                        'original_min_freq': ep_min_hz
                    })
                    # LOGGER.info(f"[CHAFI-RSA-SLOT] Captured src endpoint metadata: {endpoint.name} (offset={offset_slots})")

                src_traces.append({
                    'endpoint_name': endpoint.name,
                    'is_path_endpoint': is_path_endpoint,
                    'min_freq_thz': endpoint.min_frequency / 1e12 if endpoint.min_frequency else None,
                    'max_freq_thz': endpoint.max_frequency / 1e12 if endpoint.max_frequency else None,
                    'flex_slots': endpoint.flex_slots if endpoint.flex_slots else 0,
                    'original_bitmap': TopologyHelper.int_to_bitmap(
                        endpoint.bitmap_value, endpoint.flex_slots if endpoint.flex_slots else 0),
                    'aligned_bitmap': TopologyHelper.int_to_bitmap(aligned_bitmap, reference_slots)
                })
                # LOGGER.debug(
                #     f"[RSAHelper:perform_rsa] Src endpoint {endpoint.name} "
                #     f"({'PATH' if is_path_endpoint else 'PARALLEL'}): aligned and intersected")

            # Process destination endpoints (intersect only parallel link endpoints)
            for endpoint in dst_endpoints:
                aligned_bitmap = TopologyHelper.align_endpoint_to_reference(
                    endpoint, selected_min_freq, selected_max_freq, slot_granularity_hz
                )
                dst_device_bitmap &= aligned_bitmap

                # Check if this endpoint is part of the selected path
                is_path_endpoint = (
                    endpoint.endpoint_uuid == dst_endpoint_uuid)

                if is_path_endpoint:
                    # [CHAFI-RSA-SLOT] Store metadata for slot acquisition
                    ep_min_hz = endpoint.min_frequency if endpoint.min_frequency else selected_min_freq
                    offset_slots = int(
                        (ep_min_hz - selected_min_freq) / slot_granularity_hz)

                    acquisition_in_path.append({
                        'endpoint_uuid': endpoint.endpoint_uuid,
                        'device_uuid': endpoint.device_uuid,
                        'device_type': endpoint.device_type,
                        'endpoint_name': endpoint.name,
                        'endpoint_index': endpoint.endpoint_index,
                        'aligned_bitmap': TopologyHelper.int_to_bitmap(aligned_bitmap, reference_slots),
                        'offset_slots': offset_slots,
                        'native_flex_slots': endpoint.flex_slots if endpoint.flex_slots else 0,
                        'original_min_freq': ep_min_hz
                    })
                    # LOGGER.info(f"[CHAFI-RSA-SLOT] Captured dst endpoint metadata: {endpoint.name} (offset={offset_slots})")

                dst_traces.append({
                    'endpoint_name': endpoint.name,
                    'is_path_endpoint': is_path_endpoint,
                    'min_freq_thz': endpoint.min_frequency / 1e12 if endpoint.min_frequency else None,
                    'max_freq_thz': endpoint.max_frequency / 1e12 if endpoint.max_frequency else None,
                    'flex_slots': endpoint.flex_slots if endpoint.flex_slots else 0,
                    'original_bitmap': TopologyHelper.int_to_bitmap(
                        endpoint.bitmap_value, endpoint.flex_slots if endpoint.flex_slots else 0),
                    'aligned_bitmap': TopologyHelper.int_to_bitmap(aligned_bitmap, reference_slots)
                })
                # LOGGER.debug(
                #     f"[RSAHelper:perform_rsa] Dst endpoint {endpoint.name} "
                #     f"({'PATH' if is_path_endpoint else 'PARALLEL'}): aligned and intersected")

            # LOGGER.info(
            #     f"[RSAHelper:perform_rsa] Processed {len(src_endpoints)} src + {len(dst_endpoints)} dst endpoints")

            # Hop bitmap = intersection of source and destination device bitmaps
            hop_bitmap = src_device_bitmap & dst_device_bitmap

            # Update path-wide bitmap
            reference_bitmap &= hop_bitmap

            # Record trace
            trace_steps.append({
                'hop_index': i + 1,
                'hop_label': hop_label,
                'link_name': link_info.get('name', 'unknown'),
                'src_device': link_info.get('src'),
                'dst_device': link_info.get('dst'),
                'src_device_uuid': src_device_uuid,
                'dst_device_uuid': dst_device_uuid,
                'src_endpoint_traces': src_traces,
                'dst_endpoint_traces': dst_traces,
                'src_device_bitmap': TopologyHelper.int_to_bitmap(src_device_bitmap, reference_slots),
                'dst_device_bitmap': TopologyHelper.int_to_bitmap(dst_device_bitmap, reference_slots),
                'hop_bitmap': TopologyHelper.int_to_bitmap(hop_bitmap, reference_slots),
                'cumulative_bitmap': TopologyHelper.int_to_bitmap(reference_bitmap, reference_slots)
            })

            available_slots = bin(hop_bitmap).count('1')
            # LOGGER.info(
            #     f"[RSA Pre-Compute] Hop {i+1}: {available_slots}/{reference_slots} slots available")

        total_available = bin(reference_bitmap).count('1')
        # LOGGER.info(
        #     f"[RSA Pre-Compute] Path complete: {total_available}/{reference_slots} slots available")

        return reference_bitmap, reference_slots, trace_steps, band_info, acquisition_in_path if 'acquisition_in_path' in locals() else []

    @staticmethod
    def perform_rsa(
        path_obj: Dict,
        bandwidth: float,
        cache: OpticalLinksCache
    ) -> Optional[Dict]:
        """
        Performs Routing and Spectrum Assignment (RSA) using reference bitmap alignment.

        Args:
            path_obj: Path object with 'links' list
            bandwidth: Requested bandwidth in Gbps
            cache: OpticalLinksCache instance

        Returns:
            dict: RSA result with success status, bitmaps, trace, and mask
        """
        if not bandwidth:
            LOGGER.warning("[RSA] No bandwidth specified")
            return None

        # Calculate required slots using ITU-T standard (6.25 GHz granularity)
        slot_granularity_hz = ITUStandards.SLOT_GRANULARITY.value
        slot_granularity_ghz = slot_granularity_hz / FrequencyMeasurementUnit.GHz.value
        num_slots = math.ceil(float(bandwidth) / slot_granularity_ghz)

        # LOGGER.info(
        #     f"[RSA] Starting RSA for {bandwidth} Gbps. "
        #     f"Required slots: {num_slots} (@ {slot_granularity_ghz} GHz granularity)")

        if not path_obj.get('links'):
            LOGGER.warning("[RSA] Path has no links!")
            return None

        # Step 1: Pre-compute with reference bitmap
        result = TopologyHelper.rsa_bitmap_pre_compute(path_obj, cache)

        if not result or result[0] is None:
            LOGGER.error("[RSA] Pre-compute failed")
            return None

        reference_bitmap, reference_slots, trace_steps, band_info, acquisition_metadata = result

        # Step 2: Find Contiguous Slots (First Fit from LSB)
        start_bit = -1
        current_run = 0

        for i in range(reference_slots):
            is_free = (reference_bitmap >> i) & 1

            if is_free:
                current_run += 1
                if current_run == num_slots:
                    start_bit = i - num_slots + 1
                    break
            else:
                current_run = 0

        if start_bit != -1:
            # Success - Found slots!
            mask = ((1 << num_slots) - 1) << start_bit
            final_bitmap_val = reference_bitmap & ~mask

            # Format as strings
            common_bitmap_str = TopologyHelper.int_to_bitmap(
                reference_bitmap, reference_slots)
            required_slots_str = TopologyHelper.int_to_bitmap(
                mask, reference_slots)
            final_bitmap_str = TopologyHelper.int_to_bitmap(
                final_bitmap_val, reference_slots)

            # LOGGER.info(
            #     f"[RSAHelper:perform_rsa] Success! Allocated slots {start_bit}-{start_bit + num_slots - 1}")

            return {
                'success': True,
                'num_slots': num_slots,
                'start_slot': start_bit,
                'end_slot': start_bit + num_slots - 1,
                'common_bitmap': common_bitmap_str,
                'required_slots': required_slots_str,
                'final_bitmap': final_bitmap_str,
                'final_bitmap_int': final_bitmap_val,
                'trace_steps': trace_steps,
                'band_info': band_info,
                'mask': mask,
                'reference_slots': reference_slots,
                'links': path_obj['links'],
                'acquisition_metadata': acquisition_metadata
            }
        else:
            # Failure - No contiguous slots found
            LOGGER.warning(
                f"[RSAHelper:perform_rsa] Failed. No {num_slots} contiguous slots found")

            return {
                'success': False,
                'num_slots': num_slots,
                'common_bitmap': TopologyHelper.int_to_bitmap(reference_bitmap, reference_slots),
                'error': f"No {num_slots} contiguous slots available",
                'trace_steps': trace_steps,
                'band_info': band_info,
                'mask': 0,
                'reference_slots': reference_slots,
                'links': path_obj['links'],
                'acquisition_metadata': acquisition_in_path if 'acquisition_in_path' in locals() else []
            }
