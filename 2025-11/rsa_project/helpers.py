import logging
import math
import networkx as nx
from enums.OpticalBands import FreqeuncyRanges, Bands, Lambdas, FrequencyMeasurementUnit
from enums.ITUStandards import ITUStandards
from enums.Device import Constants

# Configure logging
logger = logging.getLogger(__name__)

# OTN Types
OTN_TYPE_OCH = "OCH"
OTN_TYPE_OMS = "OMS"
OTN_TYPE_MISMATCH = "OTN_TYPE_MISMATCH"


class OpticalBandHelper:
    @staticmethod
    def detect_band(min_frequency_hz, max_frequency_hz):
        """
        Detects the optical band based on min and max frequencies.
        Supports both single-band (O, E, S, C, L) and multi-band (CL, SCL, WHOLE_BAND) scenarios.

        The algorithm finds the SMALLEST (narrowest) band that contains the endpoint's 
        frequency range. This ensures we don't unnecessarily expand to wider bands.

        Args:
            min_frequency_hz: Minimum frequency in Hz (as stored in database)
            max_frequency_hz: Maximum frequency in Hz (as stored in database)

        Returns:
            dict: Contains band_name, band_enum, wavelength_range, and frequency_range_hz
        """
        if not min_frequency_hz or not max_frequency_hz:
            return None

        # Database stores frequencies in Hz, FrequencyRanges enum also uses Hz
        # No conversion needed

        # Check which band the frequency range falls into
        # Note: FrequencyRanges stores (min, max) tuples in Hz
        # Find the SMALLEST band that contains the endpoint's frequency range
        band_matches = []

        for band_enum in FreqeuncyRanges:
            band_min_hz, band_max_hz = band_enum.value

            # Check if the endpoint's frequency range falls within this band
            # Allow some tolerance for edge cases (1% tolerance)
            if (min_frequency_hz >= band_min_hz * 0.99 and max_frequency_hz <= band_max_hz * 1.01):
                # Get the band name (e.g., "C_BAND" -> "C", "CL_BAND" -> "C, L")
                band_name = Bands[band_enum.name].value

                # Get wavelength range for this band
                wavelength_range = Lambdas[band_enum.name].value

                # Get the frequency range from the enum (in Hz)
                frequency_range_hz = band_enum.value

                # Calculate band width (for sorting - we want SMALLEST band)
                band_width_hz = band_max_hz - band_min_hz

                band_matches.append({
                    'band_name': band_name,
                    'band_enum_name': band_enum.name,
                    'wavelength_range': wavelength_range,
                    'frequency_range_hz': frequency_range_hz,
                    'band_width_hz': band_width_hz  # Used for sorting
                })

        # If we have matches, return the SMALLEST/NARROWEST band that fits
        if band_matches:
            # Sort by band width (ascending) - prefer narrowest band
            band_matches.sort(key=lambda x: x['band_width_hz'])
            best_match = band_matches[0]
            # Remove band_width_hz key before returning (internal use only)
            del best_match['band_width_hz']
            return best_match

        # If no exact match, return None
        return None


class SpectrumHelper:
    @staticmethod
    def build_spectrum_slot_table(endpoint, band_info):
        """
        Builds a spectrum slot table showing all standard band slots with availability status.

        Args:
            endpoint: Endpoint model instance with min_frequency, max_frequency, flex_slots, bitmap_value
            band_info: Band information dict from OpticalBandHelper.detect_band()

        Returns:
            list: List of dicts with keys: frequency (Hz), availability (str), is_anchor (bool)
        """
        if not endpoint or not band_info:
            return []

        # Get ITU standards
        slot_granularity_hz = ITUStandards.SLOT_GRANULARITY.value
        anchor_frequency_hz = ITUStandards.ANCHOR_FREQUENCY.value

        # Get operational band range (standard min/max for the band)
        band_min_hz, band_max_hz = band_info['frequency_range_hz']

        # Calculate standard slots for the full band
        operational_bandwidth_hz = band_max_hz - band_min_hz
        standard_slots = int(operational_bandwidth_hz / slot_granularity_hz)

        # Get endpoint data
        endpoint_min_hz = endpoint.min_frequency if endpoint.min_frequency else None
        endpoint_max_hz = endpoint.max_frequency if endpoint.max_frequency else None
        endpoint_slots = endpoint.flex_slots if endpoint.flex_slots else 0
        bitmap_value = int(
            endpoint.bitmap_value) if endpoint.bitmap_value else 0

        # Build slot table
        slot_table = []

        for slot_index in range(standard_slots):
            # Calculate frequency for this slot
            frequency_hz = band_min_hz + (slot_index * slot_granularity_hz)

            # Check if this is the anchor frequency
            is_anchor = abs(
                frequency_hz - anchor_frequency_hz) < (slot_granularity_hz / 2)

            # Determine availability status
            availability = SpectrumHelper._determine_slot_availability(
                frequency_hz,
                endpoint_min_hz,
                endpoint_max_hz,
                slot_granularity_hz,
                bitmap_value,
                endpoint_slots  # Pass flex_slots for bounds checking
            )

            slot_table.append({
                'frequency': frequency_hz,
                'availability': availability,
                'is_anchor': is_anchor
            })

        return slot_table

    @staticmethod
    def _determine_slot_availability(frequency_hz, endpoint_min_hz, endpoint_max_hz,
                                     slot_granularity_hz, bitmap_value, endpoint_flex_slots=None):
        """
        Determines the availability status of a specific frequency slot.

        Args:
            frequency_hz: Frequency of the slot being evaluated
            endpoint_min_hz: Minimum frequency supported by endpoint
            endpoint_max_hz: Maximum frequency supported by endpoint
            slot_granularity_hz: Slot granularity from ITU standards
            bitmap_value: Bitmap representing slot usage (LSB = endpoint_min)
            endpoint_flex_slots: Number of slots in endpoint's bitmap (optional but recommended)

        Returns:
            str: Status from Constants enum (UNAVAILABLE, AVAILABLE, IN_USE)
        """
        if not endpoint_min_hz or not endpoint_max_hz:
            return Constants.UNAVAILABLE.value

        # Case 1: Frequency outside endpoint capability range
        # Use >= for max because endpoint_max_hz is the upper bound, not an actual slot
        if frequency_hz < endpoint_min_hz or frequency_hz >= endpoint_max_hz:
            return Constants.UNAVAILABLE.value

        # Case 2: Frequency within endpoint range - check bitmap
        # Calculate bit position (LSB = endpoint_min)
        bit_position = int(
            (frequency_hz - endpoint_min_hz) / slot_granularity_hz)

        # Case 2a: Bit position exceeds endpoint's flex_slots (safety check)
        if endpoint_flex_slots is not None and bit_position >= endpoint_flex_slots:
            return Constants.UNAVAILABLE.value

        # Extract bit value (LSB ordering)
        # Bit = 1 means AVAILABLE (free)
        # Bit = 0 means IN_USE (allocated)
        bit_value = (bitmap_value >> bit_position) & 1

        if bit_value == 1:
            return Constants.AVAILABLE.value
        else:
            return Constants.IN_USE.value


class TopologyHelper:
    @staticmethod
    def int_to_bitmap(value, length=35):
        """Converts an integer to a binary string bitmap."""
        # Handle cases where value might be None or not an int
        if value is None:
            return "0" * length
        try:
            val_int = int(value)
            return format(val_int, f'0{length}b')
        except (ValueError, TypeError):
            return "0" * length

    @staticmethod
    def align_endpoint_to_reference(endpoint, _selected_min_freq, _selected_max_freq, SLOT_GRANULARITY_HZ):
        """
        Aligns an endpoint's bitmap to the reference frequency range.

        This function pads the endpoint bitmap with zeros to match the reference range,
        enabling proper intersection across devices with different frequency capabilities.

        Alignment Process:
        1. Calculate low-end offset: how many slots before endpoint's min_frequency
        2. Calculate endpoint's actual slot width from its frequency range
        3. Mask endpoint bitmap to its actual width
        4. Shift left by low-end offset to position correctly
        5. Mask to reference width to ensure high-end zeros

        Frequency Alignment Example:
        Reference (C-band):   |==========================================| (191.556-195.937 THz, 701 slots)
        Endpoint:                   |=========================|           (191.581-195.912 THz, 693 slots)
        Aligned bitmap:       [0000][11111111111111111111][0000]          (4 low zeros, 693 endpoint bits, 4 high zeros)

        Args:
            endpoint: Endpoint model instance with min_frequency, max_frequency, bitmap_value
            _selected_min_freq: Reference range minimum frequency (Hz)
            _selected_max_freq: Reference range maximum frequency (Hz)
            SLOT_GRANULARITY_HZ: ITU slot granularity (6.25 GHz in Hz)

        Returns:
            int: Aligned bitmap value with zero-padding at both ends
        """
        if not endpoint or not endpoint.min_frequency or not endpoint.max_frequency or not endpoint.bitmap_value:
            # Return all zeros (unavailable) for endpoints outside reference or with no data
            return 0

        # Calculate reference width
        reference_slots = int(
            (_selected_max_freq - _selected_min_freq) / SLOT_GRANULARITY_HZ)

        # Use endpoint's flex_slots from database (authoritative value)
        endpoint_slots = endpoint.flex_slots if endpoint.flex_slots else 0

        # Calculate low-end offset: how many slots before endpoint's min_frequency
        low_offset_hz = endpoint.min_frequency - _selected_min_freq
        low_offset_slots = int(low_offset_hz / SLOT_GRANULARITY_HZ)

        # Handle negative offset (endpoint starts before reference - shouldn't happen but handle gracefully)
        if low_offset_slots < 0:
            logger.warning(
                f"[RSA Align] Endpoint {endpoint.name} starts before reference range")
            # Trim the endpoint bitmap from the left
            trim_slots = abs(low_offset_slots)
            endpoint_bitmap = int(endpoint.bitmap_value) >> trim_slots
            low_offset_slots = 0
        else:
            endpoint_bitmap = int(endpoint.bitmap_value)

        # Step 1: Mask endpoint bitmap to its flex_slots width
        # This ensures we only use the bits that represent the endpoint's actual capability
        endpoint_width_mask = (1 << endpoint_slots) - 1
        endpoint_bitmap &= endpoint_width_mask

        # Step 2: Shift left by low-end offset to position correctly in reference
        aligned_bitmap = endpoint_bitmap << low_offset_slots

        # Step 3: Mask to reference width to ensure high-end zeros
        reference_mask = (1 << reference_slots) - 1
        aligned_bitmap &= reference_mask

        logger.debug(
            f"[RSA Align] {endpoint.name}: low_offset={low_offset_slots}, endpoint_slots={endpoint_slots}, ref_slots={reference_slots}")

        return aligned_bitmap

    @staticmethod
    def shrink_to_endpoint(reference_bitmap, _selected_min_freq, endpoint, SLOT_GRANULARITY_HZ):
        """
        Shrinks a reference-width bitmap to endpoint's own width.

        Task 12: This is the INVERSE of align_endpoint_to_reference().
        - align_endpoint_to_reference: Endpoint → Reference (shift LEFT, pad zeros)
        - shrink_to_endpoint: Reference → Endpoint (shift RIGHT, trim to width)

        Used to convert final_bitmap from RSA (reference width) back to endpoint's
        actual width for database storage. Preserves frequency alignment.

        Shrink Process:
        1. Calculate low-end offset: (endpoint.min - reference.min) / SLOT_GRANULARITY
        2. Shift RIGHT by offset: removes low-frequency bits not in endpoint's range
        3. Mask to endpoint width: removes high-frequency bits not in endpoint's range

        Example:
        Reference (C-band 701 slots, 191.556-195.937 THz):
            [0000][111...000...111][0000]
             ^                      ^
             slots 0-3              slots 697-700
             (below endpoint)       (above endpoint)

        After shrink to endpoint (693 slots, 191.581-195.912 THz):
            [111...000...111]
            ^            ^
            slot 0       slot 692

        Args:
            reference_bitmap: int - Bitmap in reference range (e.g., 701 bits for C-Band)
            _selected_min_freq: Reference minimum frequency (Hz) from band_info
            endpoint: Endpoint model instance with min_frequency, flex_slots
            SLOT_GRANULARITY_HZ: ITU slot granularity (6.25 GHz in Hz)

        Returns:
            int: Bitmap shrunk to endpoint's width
        """
        if not endpoint or not endpoint.min_frequency or not endpoint.flex_slots:
            logger.warning(f"[RSA Shrink] Invalid endpoint data for shrinking")
            return 0

        # Calculate offset from reference start to endpoint start
        offset_hz = endpoint.min_frequency - _selected_min_freq
        offset_slots = int(offset_hz / SLOT_GRANULARITY_HZ)

        if offset_slots < 0:
            # Endpoint starts before reference (shouldn't happen with proper band detection)
            logger.warning(
                f"[RSA Shrink] Endpoint {endpoint.name} has negative offset: {offset_slots}")
            shrinked = reference_bitmap << abs(offset_slots)
        else:
            # Normal case: shift right to remove low-frequency bits
            shrinked = reference_bitmap >> offset_slots

        # Mask to endpoint's flex_slots width (remove high-frequency bits)
        endpoint_width_mask = (1 << endpoint.flex_slots) - 1
        shrinked &= endpoint_width_mask

        logger.debug(
            f"[RSA Shrink] {endpoint.name}: offset={offset_slots}, flex_slots={endpoint.flex_slots}")

        return shrinked

    @staticmethod
    def get_device_available_bitmap(device_id, reference_endpoint_id, _selected_min_freq, _selected_max_freq, SLOT_GRANULARITY_HZ):
        """
        Computes available spectrum for a device by intersecting ALL its endpoint bitmaps.

        This enforces the parallel endpoint constraint: ROADM WSS cannot reuse frequencies
        across different output ports due to optical interference. If port-11 uses slot 5,
        port-10 CANNOT use slot 5 on the same device.

        Args:
            device_id: UUID of the device
            reference_endpoint_id: The specific endpoint in the path (for trace marking)
            _selected_min_freq: Reference range minimum frequency (Hz)
            _selected_max_freq: Reference range maximum frequency (Hz)
            SLOT_GRANULARITY_HZ: ITU slot granularity (6.25 GHz in Hz)

        Returns:
            tuple: (device_bitmap, endpoint_traces)
                device_bitmap: int - Intersection of all device endpoints
                endpoint_traces: list of dict - Trace information for visualization
        """
        from models import Endpoint

        # Query all endpoints for this device
        all_endpoints = Endpoint.query.filter_by(device_id=device_id).all()

        logger.info(
            f"[RSA Device] Processing device {device_id}: Found {len(all_endpoints)} endpoints")

        # Initialize with all available
        reference_slots = int(
            (_selected_max_freq - _selected_min_freq) / SLOT_GRANULARITY_HZ)
        device_bitmap = (1 << reference_slots) - 1

        endpoint_traces = []

        for endpoint in all_endpoints:
            # Align endpoint to reference range
            aligned_bitmap = TopologyHelper.align_endpoint_to_reference(
                endpoint, _selected_min_freq, _selected_max_freq, SLOT_GRANULARITY_HZ
            )

            # Intersect with device bitmap
            device_bitmap &= aligned_bitmap

            # Track for trace visualization
            is_path_endpoint = (endpoint.id == reference_endpoint_id)
            endpoint_traces.append({
                'endpoint_name': endpoint.name,
                'is_path_endpoint': is_path_endpoint,
                'min_freq_thz': endpoint.min_frequency / 1e12 if endpoint.min_frequency else None,
                'max_freq_thz': endpoint.max_frequency / 1e12 if endpoint.max_frequency else None,
                'flex_slots': endpoint.flex_slots if endpoint.flex_slots else 0,
                'original_bitmap': TopologyHelper.int_to_bitmap(int(endpoint.bitmap_value) if endpoint.bitmap_value else 0, endpoint.flex_slots if endpoint.flex_slots else 0),
                'aligned_bitmap': TopologyHelper.int_to_bitmap(aligned_bitmap, reference_slots)
            })

            logger.debug(
                f"[RSA Device] Endpoint {endpoint.name} ({'PATH' if is_path_endpoint else 'OTHER'}): aligned and intersected")

        logger.info(
            f"[RSA Device] Device {device_id}: {len(endpoint_traces)} endpoints processed")

        return device_bitmap, endpoint_traces

    @staticmethod
    def convert_mask_to_endpoint(reference_mask, _selected_min_freq, endpoint, SLOT_GRANULARITY_HZ):
        """
        Converts a mask from reference range to endpoint's own frequency range.

        Example:
        Reference (CL, 1199 slots): Mask at slots 500-507
        Reference mask: [000...][11111111][000...]
                               ↑        ↑
                               500      507

        Endpoint (C, 701 slots, offset 498):
        Endpoint range: slots 498-1198 in reference = slots 0-700 in endpoint
        Mask 500-507 in reference = slots 2-9 in endpoint (500-498=2)
        Endpoint mask: [00][11111111][000...]

        Args:
            reference_mask: int - Mask in reference range
            _selected_min_freq: Reference minimum frequency (Hz)
            endpoint: Endpoint model instance
            SLOT_GRANULARITY_HZ: ITU slot granularity (6.25 GHz in Hz)

        Returns:
            int: Mask in endpoint's own frequency range
        """
        if not endpoint or not endpoint.min_frequency or not endpoint.max_frequency:
            return 0  # Endpoint outside reference

        # Calculate offset
        offset_hz = endpoint.min_frequency - _selected_min_freq
        offset_slots = int(offset_hz / SLOT_GRANULARITY_HZ)

        if offset_slots < 0:
            # Endpoint starts before reference (shouldn't happen)
            logger.warning(
                f"[RSA Mask Convert] Endpoint {endpoint.name} starts before reference")
            return reference_mask << abs(offset_slots)
        else:
            # Shift mask right to align with endpoint range
            endpoint_mask = reference_mask >> offset_slots

            # Trim to endpoint width
            if endpoint.flex_slots:
                max_mask = (1 << endpoint.flex_slots) - 1
                endpoint_mask &= max_mask

            return endpoint_mask

    @staticmethod
    def expand_path(node_path, graph_to_use, src_port, dst_port):
        """
        Converts a node path (list of device names) into a detailed link path.
        Handles parallel links and port constraints.
        """
        valid_edge_paths = []

        def backtrack(index, current_edge_path):
            if index == len(node_path) - 1:
                # Check validity of the full path
                is_valid = True
                for link in current_edge_path:
                    if link['status'] != 'FREE':
                        is_valid = False
                        break

                valid_edge_paths.append({
                    'links': list(current_edge_path),
                    'is_valid': is_valid
                })
                return

            u = node_path[index]
            v = node_path[index+1]

            # Find all edges between u and v in the specified graph
            if not graph_to_use.has_edge(u, v):
                return

            edges = graph_to_use[u][v]  # dict of key -> attributes

            for key, attr in edges.items():
                # Determine ports based on direction
                if attr['original_src'] == u and attr['original_dst'] == v:
                    out_port = attr['src_port']
                    in_port = attr['dst_port']
                elif attr['original_src'] == v and attr['original_dst'] == u:
                    out_port = attr['dst_port']
                    in_port = attr['src_port']
                else:
                    continue

                # Check constraints
                if index == 0 and src_port and out_port != src_port:
                    continue

                if index == len(node_path) - 2 and dst_port and in_port != dst_port:
                    continue

                # Add to path
                current_edge_path.append({
                    'id': str(key),  # Unique ID for the link (UUID as string)
                    'src': u,
                    'dst': v,
                    'src_port': out_port,
                    'dst_port': in_port,
                    'name': attr['name'],
                    'status': attr['status'],
                    'otn_type': attr.get('otn_type')  # Include OTN Type
                })

                backtrack(index + 1, current_edge_path)
                current_edge_path.pop()

        # In expand_path, we compute all combinations of physical links
        # We need to correctly calculate is_valid for each based on OTN-aware logic
        valid_edge_paths = []

        # Internal backtrack above populates this list, but we need to define it differently now
        # Actually, let's redefine the validity check INSIDE the backtrack loop

        def backtrack_v2(index, current_edge_path):
            if index == len(node_path) - 1:
                # NEW Path Validity Logic
                is_valid = True
                for link in current_edge_path:
                    otn = link['otn_type']
                    status = link['status']

                    if otn == 'OCH' and status != 'FREE':
                        is_valid = False
                        break
                    elif otn == 'OMS' and status == 'FULL':
                        is_valid = False
                        break

                valid_edge_paths.append({
                    'links': list(current_edge_path),
                    'is_valid': is_valid
                })
                return

            u = node_path[index]
            v = node_path[index+1]
            if not graph_to_use.has_edge(u, v):
                return
            edges = graph_to_use[u][v]

            for key, attr in edges.items():
                # Port matching logic...
                if attr['original_src'] == u and attr['original_dst'] == v:
                    out_port, in_port = attr['src_port'], attr['dst_port']
                elif attr['original_src'] == v and attr['original_dst'] == u:
                    out_port, in_port = attr['dst_port'], attr['src_port']
                else:
                    continue

                if index == 0 and src_port and out_port != src_port:
                    continue
                if index == len(node_path) - 2 and dst_port and in_port != dst_port:
                    continue

                current_edge_path.append({
                    'id': str(key),
                    'src': u,
                    'dst': v,
                    'src_port': out_port,
                    'dst_port': in_port,
                    'name': attr['name'],
                    'status': attr['status'],
                    'otn_type': attr.get('otn_type')
                })
                backtrack_v2(index + 1, current_edge_path)
                current_edge_path.pop()

        backtrack_v2(0, [])
        return valid_edge_paths

    @staticmethod
    def rsa_bitmap_pre_compute(path_obj, graph):
        """
        Computes available spectrum using reference bitmap alignment.

        Task 11: Reference Bitmap RSA Computation
        - Collects all unique endpoints in path
        - Calculates widest frequency range (reference range)
        - Detects operational band (C, CL, SCL, WHOLE_BAND, etc.)
        - Aligns all endpoint bitmaps to reference range
        - Enforces device-level parallel endpoint constraints
        - Intersects across all hops to find available spectrum

        Args:
            path_obj: Path object with 'links' list
            graph: NetworkX graph (not used in new implementation)

        Returns:
            tuple: (reference_bitmap, reference_slots, trace_steps, band_info)
        """
        from models import OpticalLink, Endpoint

        if not path_obj['links']:
            logger.error("[RSA Pre-Compute] No links in path")
            return None, 0, [], None

        logger.info(
            "[RSA Pre-Compute] Starting reference bitmap computation (Task 11)")

        # Step 1: Collect all unique endpoints in path
        endpoint_ids = set()
        for link_info in path_obj['links']:
            link = OpticalLink.query.get(link_info['id'])
            if link:
                if link.src_endpoint_id:
                    endpoint_ids.add(link.src_endpoint_id)
                if link.dst_endpoint_id:
                    endpoint_ids.add(link.dst_endpoint_id)

        endpoints = [Endpoint.query.get(eid) for eid in endpoint_ids if eid]
        endpoints = [ep for ep in endpoints if ep]  # Filter out None

        if not endpoints:
            logger.error("[RSA Pre-Compute] No valid endpoints found in path")
            return None, 0, [], None

        logger.info(
            f"[RSA Pre-Compute] Found {len(endpoints)} unique endpoints in path")

        # Step 2: Calculate reference frequency range (widest range)
        valid_endpoints = [
            ep for ep in endpoints if ep.min_frequency and ep.max_frequency]
        if not valid_endpoints:
            logger.error(
                "[RSA Pre-Compute] No endpoints with valid frequency data")
            return None, 0, [], None

        _reference_min_freq = min([ep.min_frequency for ep in valid_endpoints])
        _reference_max_freq = max([ep.max_frequency for ep in valid_endpoints])

        logger.info(
            f"[RSA Pre-Compute] Reference range: {_reference_min_freq / FrequencyMeasurementUnit.THz.value} - {_reference_max_freq / FrequencyMeasurementUnit.THz.value} THz")

        # Step 3: Detect operational band
        band_info = OpticalBandHelper.detect_band(
            _reference_min_freq, _reference_max_freq)
        if not band_info:
            logger.error("[RSA Pre-Compute] Could not detect operational band")
            return None, 0, [], None

        # Use STANDARD band range as reference (not actual endpoint range)
        # This ensures alignment to ITU standard grid
        _selected_min_freq, _selected_max_freq = band_info['frequency_range_hz']
        SLOT_GRANULARITY_HZ = ITUStandards.SLOT_GRANULARITY.value
        reference_slots = int(
            (_selected_max_freq - _selected_min_freq) / SLOT_GRANULARITY_HZ)

        logger.info(
            f"[RSA Pre-Compute] Detected band: {band_info['band_name']}-Band ({reference_slots} slots @ 6.25 GHz)")

        # Step 4: Initialize reference bitmap (all available)
        reference_bitmap = (1 << reference_slots) - 1

        trace_steps = []

        # Step 5: Iterate through hops with device-level parallel endpoint checking
        for i, link_info in enumerate(path_obj['links']):
            link_id = link_info['id']
            hop_label = f"{link_info['src']} -> {link_info['dst']}"

            logger.info(f"[RSA Pre-Compute] Processing Hop {i+1}: {hop_label}")

            # Fetch the link from database
            link = OpticalLink.query.get(link_id)
            if not link or not link.src_endpoint or not link.dst_endpoint:
                logger.error(
                    f"[RSA Pre-Compute] Link {link_id} or its endpoints not found")
                continue

            # Get device-level available bitmap (with parallel endpoint constraints)
            src_device_bitmap, src_traces = TopologyHelper.get_device_available_bitmap(
                link.src_endpoint.device_id,
                link.src_endpoint_id,
                _selected_min_freq,
                _selected_max_freq,
                SLOT_GRANULARITY_HZ
            )

            dst_device_bitmap, dst_traces = TopologyHelper.get_device_available_bitmap(
                link.dst_endpoint.device_id,
                link.dst_endpoint_id,
                _selected_min_freq,
                _selected_max_freq,
                SLOT_GRANULARITY_HZ
            )

            # Hop bitmap = intersection of source and destination device bitmaps
            hop_bitmap = src_device_bitmap & dst_device_bitmap

            # Update path-wide bitmap
            reference_bitmap &= hop_bitmap

            # Record trace
            trace_steps.append({
                'hop_index': i + 1,
                'hop_label': hop_label,
                'link_name': link_info.get('name', 'unknown'),
                'src_device': link_info['src'],
                'dst_device': link_info['dst'],
                'src_device_id': str(link.src_endpoint.device_id),
                'dst_device_id': str(link.dst_endpoint.device_id),
                'src_endpoint_traces': src_traces,
                'dst_endpoint_traces': dst_traces,
                'src_device_bitmap': TopologyHelper.int_to_bitmap(src_device_bitmap, reference_slots),
                'dst_device_bitmap': TopologyHelper.int_to_bitmap(dst_device_bitmap, reference_slots),
                'hop_bitmap': TopologyHelper.int_to_bitmap(hop_bitmap, reference_slots),
                'cumulative_bitmap': TopologyHelper.int_to_bitmap(reference_bitmap, reference_slots)
            })

            available_slots = bin(hop_bitmap).count('1')
            logger.info(
                f"[RSA Pre-Compute] Hop {i+1}: {available_slots}/{reference_slots} slots available")

        total_available = bin(reference_bitmap).count('1')
        logger.info(
            f"[RSA Pre-Compute] Path complete: {total_available}/{reference_slots} slots available")

        return reference_bitmap, reference_slots, trace_steps, band_info

    @staticmethod
    def perform_rsa(path_obj, bandwidth, graph):
        """
        Performs Routing and Spectrum Assignment (RSA) using reference bitmap alignment.

        Task 11: Uses correct ITU-T slot granularity (6.25 GHz, not 12.5 GHz).

        Args:
            path_obj: Path object with 'links' list
            bandwidth: Requested bandwidth in Gbps
            graph: NetworkX graph (not used in new implementation)

        Returns:
            dict: RSA result with success status, bitmaps, trace, and mask
        """
        if not bandwidth:
            logger.warning("[RSA] No bandwidth specified")
            return None

        # Calculate required slots using ITU-T standard (Task 11: Fix from 12.5 to 6.25 GHz)
        SLOT_GRANULARITY_HZ = ITUStandards.SLOT_GRANULARITY.value  # 6250000000 Hz
        SLOT_GRANULARITY_GHZ = SLOT_GRANULARITY_HZ / \
            FrequencyMeasurementUnit.GHz.value  # 6.25 GHz
        num_slots = math.ceil(float(bandwidth) / SLOT_GRANULARITY_GHZ)

        logger.info(
            f"[RSA] Starting RSA for {bandwidth} Gbps. Required slots: {num_slots} (@ {SLOT_GRANULARITY_GHZ} GHz granularity)")

        if not path_obj['links']:
            logger.warning("[RSA] Path has no links!")
            return None

        # Step 1: Pre-compute with reference bitmap (Task 11)
        result = TopologyHelper.rsa_bitmap_pre_compute(path_obj, graph)

        if not result or result[0] is None:
            logger.error("[RSA] Pre-compute failed")
            return None

        reference_bitmap, reference_slots, trace_steps, band_info = result

        # Step 2: Find Contiguous Slots (First Fit from LSB)
        start_bit = -1
        current_run = 0

        for i in range(reference_slots):
            is_free = (reference_bitmap >> i) & 1

            if is_free:
                current_run += 1
                if current_run == num_slots:
                    # Found contiguous slots
                    start_bit = i - num_slots + 1
                    break
            else:
                # Reset counter
                current_run = 0

        if start_bit != -1:
            # Success - Found slots!
            mask = ((1 << num_slots) - 1) << start_bit
            final_bitmap_val = reference_bitmap & ~mask

            # Format as strings
            common_bitmap_str = f"{reference_bitmap:0{reference_slots}b}"
            required_slots_str = f"{mask:0{reference_slots}b}"
            final_bitmap_str = f"{final_bitmap_val:0{reference_slots}b}"

            logger.info(
                f"[RSA] Success! Allocated slots {start_bit}-{start_bit + num_slots - 1}")

            return {
                'success': True,
                'num_slots': num_slots,
                'start_slot': start_bit,
                'common_bitmap': common_bitmap_str,
                'required_slots': required_slots_str,
                'final_bitmap': final_bitmap_str,
                'final_bitmap_int': final_bitmap_val,  # Task 12: Added for commit_slots
                'trace_steps': trace_steps,
                'band_info': band_info,
                'mask': mask,
                'links': path_obj['links']  # Include links for display
            }
        else:
            # Failure - No contiguous slots found
            logger.warning(
                f"[RSA] Failed. No {num_slots} contiguous slots found")

            return {
                'success': False,
                'num_slots': num_slots,
                'common_bitmap': f"{reference_bitmap:0{reference_slots}b}",
                'error': f"No {num_slots} contiguous slots available",
                'trace_steps': trace_steps,
                'band_info': band_info,
                'mask': 0,
                'links': path_obj['links']
            }

    @staticmethod
    def commit_slots(link_ids, final_bitmap):
        """
        Updates endpoint bitmaps by shrinking final_bitmap to each endpoint's width.

        Task 12: Reference Bitmap Shrinking
        - final_bitmap is in reference range (e.g., C-band 701 slots)
        - Each endpoint has its own range (may be narrower, e.g., 693 slots)
        - Shrink final_bitmap to each endpoint's width using shrink_to_endpoint()
        - Intersect with current bitmap to preserve existing allocations
        - Update database with new bitmap value

        Args:
            link_ids: List of link UUIDs in the path
            final_bitmap: int - Final bitmap after allocation (in reference range)

        Returns:
            bool: True if successful, False otherwise
        """
        from models import db, OpticalLink, Endpoint

        if not link_ids or final_bitmap is None:
            logger.warning("[RSA Commit] Missing link_ids or final_bitmap")
            return False

        try:
            logger.info(
                f"[RSA Commit] Starting slot reservation for {len(link_ids)} links")

            # Step 1: Get all links and collect endpoints
            links = OpticalLink.query.filter(
                OpticalLink.id.in_(link_ids)).all()
            if not links:
                logger.error(
                    f"[RSA Commit] No links found for IDs: {link_ids}")
                return False

            # Collect all path endpoints (unique)
            path_endpoints = []
            for link in links:
                if link.src_endpoint and link.src_endpoint not in path_endpoints:
                    path_endpoints.append(link.src_endpoint)
                if link.dst_endpoint and link.dst_endpoint not in path_endpoints:
                    path_endpoints.append(link.dst_endpoint)

            valid_endpoints = [ep for ep in path_endpoints
                               if ep.min_frequency and ep.max_frequency]

            if not valid_endpoints:
                logger.error("[RSA Commit] No valid path endpoints found")
                return False

            # Step 2: Detect band from path endpoints (same as pre-compute)
            _reference_min_freq = min(
                [ep.min_frequency for ep in valid_endpoints])
            _reference_max_freq = max(
                [ep.max_frequency for ep in valid_endpoints])

            band_info = OpticalBandHelper.detect_band(
                _reference_min_freq, _reference_max_freq)
            if not band_info:
                logger.error("[RSA Commit] Could not detect band")
                return False

            # Get standard band frequency range (same as used in pre-compute)
            _selected_min_freq, _selected_max_freq = band_info['frequency_range_hz']
            SLOT_GRANULARITY_HZ = ITUStandards.SLOT_GRANULARITY.value

            logger.info(
                f"[RSA Commit] Band: {band_info['band_name']}, "
                f"updating {len(valid_endpoints)} path endpoints")

            # Step 3: Update only the path endpoints (NOT all device endpoints)
            updated_count = 0

            for ep in valid_endpoints:
                if not ep.min_frequency or not ep.flex_slots:
                    continue

                # Shrink final_bitmap to endpoint width (Task 12)
                shrinked = TopologyHelper.shrink_to_endpoint(
                    final_bitmap,
                    _selected_min_freq,
                    ep,
                    SLOT_GRANULARITY_HZ
                )

                # Get current bitmap
                current_bitmap = int(
                    ep.bitmap_value) if ep.bitmap_value else 0

                # Intersect: preserves existing allocations AND applies new allocation
                # final_bitmap has 0s where allocation happened, so shrinked has 0s there
                # current_bitmap & shrinked = keeps current's 0s AND adds new 0s
                new_bitmap = current_bitmap & shrinked

                # Update database
                ep.bitmap_value = str(new_bitmap)

                # Update in_use flag
                all_available = (1 << ep.flex_slots) - 1
                ep.in_use = (new_bitmap != all_available)

                logger.info(
                    f"[RSA Commit] {ep.name}: min={ep.min_frequency/1e12:.3f} THz, "
                    f"slots={ep.flex_slots}, updated")
                updated_count += 1

            db.session.commit()
            logger.info(
                f"[RSA Commit] Success: Updated {updated_count} path endpoints")
            return True

        except Exception as e:
            db.session.rollback()
            logger.error(f"[RSA Commit] Error: {e}", exc_info=True)
            return False

    @staticmethod
    def process_optical_links(links):
        """
        Processes optical links to determine the OTN type by comparing source and destination endpoints.
        Returns a list of dictionaries with link data and consolidated otn_type.

        Note: c_slot and l_slot fields have been removed from OpticalLink model (Task 3).
        Spectrum allocation is now managed at the endpoint level via bitmap_value.
        """
        processed_links = []

        for link in links:
            src_ep = link.src_endpoint
            dst_ep = link.dst_endpoint
            src_otn = src_ep.otn_type
            dst_otn = dst_ep.otn_type

            # 1. Determine consolidated OTN Type
            if src_otn == dst_otn:
                consolidated_otn = src_otn
            else:
                consolidated_otn = OTN_TYPE_MISMATCH

            # 2. Advanced Status Logic
            final_status = "UNKNOWN"

            if consolidated_otn == OTN_TYPE_MISMATCH:
                final_status = OTN_TYPE_MISMATCH

            elif consolidated_otn == OTN_TYPE_OCH:
                # OCH: Binary Logic (FREE/USED)
                if not src_ep.in_use and not dst_ep.in_use:
                    final_status = "FREE"
                else:
                    final_status = "USED"

            elif consolidated_otn == OTN_TYPE_OMS:
                # OMS: Check endpoint usage
                # Since we no longer have link-level slots, status is based on endpoint usage
                any_in_use = src_ep.in_use or dst_ep.in_use

                if not any_in_use:
                    final_status = "FREE"
                else:
                    final_status = "USED"

            # 3. Build Processed Dictionary
            processed_links.append({
                'id': link.id,
                'name': link.name,
                'src_device': link.src_device,
                'src_endpoint': src_ep,
                'dst_device': link.dst_device,
                'dst_endpoint': dst_ep,
                'status': final_status,
                'otn_type': consolidated_otn
            })
        return processed_links
