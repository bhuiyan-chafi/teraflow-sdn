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
            # logger.warning(
            #     f"[RSA Align] Endpoint {endpoint.name} starts before reference range")
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
            # logger.warning(f"[RSA Shrink] Invalid endpoint data for shrinking")
            return 0

        # Calculate offset from reference start to endpoint start
        offset_hz = endpoint.min_frequency - _selected_min_freq
        offset_slots = int(offset_hz / SLOT_GRANULARITY_HZ)

        if offset_slots < 0:
            # Endpoint starts before reference (shouldn't happen with proper band detection)
            # logger.warning(
            #     f"[RSA Shrink] Endpoint {endpoint.name} has negative offset: {offset_slots}")
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
            # logger.warning(
            #     f"[RSA Mask Convert] Endpoint {endpoint.name} starts before reference")
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
    def log_path_links(path_collection, phase_name, path_type):
        if not path_collection:
            return
        for p in path_collection:
            if isinstance(p, dict) and 'links' in p and p['links']:
                node_seq = ' -> '.join([p['links'][0]['src']] +
                                       [l['dst'] for l in p['links']])
                link_names = ', '.join([l['name'] for l in p['links']])
                logger.info(
                    f"[{phase_name}] chosen {path_type} path: {node_seq} via links [{link_names}]")
            elif isinstance(p, list) and all(isinstance(node, str) for node in p):
                logger.info(
                    f"[{phase_name}] chosen {path_type} path: {' -> '.join(p)}")

    @staticmethod
    def expand_path(node_path, graph_to_use):
        valid_edge_paths = []

        def backtrack_v2(index, current_edge_path):
            if index == len(node_path) - 1:
                path_info = {
                    'links': list(current_edge_path),
                    'is_valid': True
                }
                valid_edge_paths.append(path_info)

                # Log all paths found (all are valid)
                node_names = [node_path[0]] + [link['dst']
                                               for link in current_edge_path]
                link_names = [link['name'] for link in current_edge_path]
                # logger.info(f"[Path Discovery] Valid path found: {' -> '.join(node_names)} "
                #             f"via links [{', '.join(link_names)}]")
                return

            u = node_path[index]
            v = node_path[index+1]
            if not graph_to_use.has_edge(u, v):
                return
            edges = graph_to_use[u][v]

            for key, attr in edges.items():
                # Traverse direction check
                if attr['original_src'] == u and attr['original_dst'] == v:
                    out_port, in_port = attr['src_port'], attr['dst_port']
                elif attr['original_src'] == v and attr['original_dst'] == u:
                    out_port, in_port = attr['dst_port'], attr['src_port']
                else:
                    continue

                current_edge_path.append({
                    'id': str(key),
                    'src': u,
                    'dst': v,
                    'src_port': out_port,
                    'dst_port': in_port,
                    'name': attr['name']
                })
                backtrack_v2(index + 1, current_edge_path)
                current_edge_path.pop()

        backtrack_v2(0, [])
        return valid_edge_paths

    @staticmethod
    def expand_path_first_valid(node_path, graph_to_use):
        """
        Variant of expand_path that returns only the FIRST valid path found
        for a given node sequence.

        Used for all_paths exploration where parallel links exist.  Returning
        all combinatorial permutations (expand_path) causes exponential
        blow-up (3 parallel links × 5 hops = 3^5 = 243 paths per route),
        which crashes the process with OOM when dozens of routes exist.

        Since RSA (perform_rsa) already checks ALL endpoints on every device,
        the specific parallel link chosen at each intermediate hop does NOT
        change the RSA result — only the *node sequence* (route) matters for
        spectrum diversity.  One representative path per route is sufficient.

        Port constraints are intentionally omitted (no src_port/dst_port
        filtering) so every parallel link at every hop is eligible.

        Returns:
            A single path dict { 'links': [...], 'is_valid': True, 'hops': N }
            or None if no valid path exists on the given node sequence.
        """
        result = [None]  # mutable container so the closure can write to it

        def backtrack(index, current_edge_path):
            if result[0] is not None:
                return  # already found a valid path — prune the rest

            if index == len(node_path) - 1:
                # Graph is pre-filtered (FULL OCH excluded at DB level).
                # Every assembled path is valid by construction.
                path_info = {
                    'links':    list(current_edge_path),
                    'is_valid': True,
                    'hops':     len(current_edge_path),
                }
                result[0] = path_info
                return

            u = node_path[index]
            v = node_path[index + 1]

            if not graph_to_use.has_edge(u, v):
                return

            edges = graph_to_use[u][v]
            for key, attr in edges.items():
                if result[0] is not None:
                    return  # early exit from the loop once found

                # Determine traversal direction
                if attr['original_src'] == u and attr['original_dst'] == v:
                    out_port, in_port = attr['src_port'], attr['dst_port']
                elif attr['original_src'] == v and attr['original_dst'] == u:
                    out_port, in_port = attr['dst_port'], attr['src_port']
                else:
                    continue

                current_edge_path.append({
                    'id':       str(key),
                    'src':      u,
                    'dst':      v,
                    'src_port': out_port,
                    'dst_port': in_port,
                    'name':     attr['name']
                })
                backtrack(index + 1, current_edge_path)
                current_edge_path.pop()

        backtrack(0, [])
        return result[0]

    @staticmethod
    def _evaluate_edge_path_score(path_index, edge_path, app):
        """
        Evaluates a single edge path and returns (path_index, avg_slots).
        Designed to run inside a ThreadPoolExecutor worker.
        Pushes its own Flask app context for DB access.

        Unlike _evaluate_path_score(), this takes an already-expanded edge path
        (with 'links' key), so no expand_path step is needed.

        Returns:
            tuple (path_index, avg_slots) or None if the path is invalid.
        """
        import threading
        t = threading.current_thread()
        link_seq = [l['name'] for l in edge_path['links']]
        # logger.info(
        #   f"[Highest Slot Edge Worker] Thread {t.name} (id={t.ident}) "
        #  f"starting edge path {path_index}: [{', '.join(link_seq)}]")

        with app.app_context():
            try:
                from models import OpticalLink, Endpoint
                link_ids = [link['id'] for link in edge_path['links']]
                links_db = OpticalLink.query.filter(
                    OpticalLink.id.in_(link_ids)).all()

                endpoint_ids = []
                for l in links_db:
                    if l.src_endpoint_id:
                        endpoint_ids.append(l.src_endpoint_id)
                    if l.dst_endpoint_id:
                        endpoint_ids.append(l.dst_endpoint_id)

                endpoints = Endpoint.query.filter(
                    Endpoint.id.in_(endpoint_ids)).all()

                total_slots = 0
                for ep in endpoints:
                    bitmap_str = TopologyHelper.int_to_bitmap(
                        ep.bitmap_value, ep.flex_slots if ep.flex_slots else 35)
                    total_slots += bitmap_str.count('1')

                hops = len(edge_path['links'])
                if hops > 0:
                    avg_slots = total_slots / (hops * 2)
                    # logger.info(
                    #     f"[Highest Slot Edge Worker] Thread {t.name} done edge path {path_index}: "
                    #     f"[{', '.join(link_seq)}] | avg_slots={avg_slots:.2f}")
                    return (path_index, avg_slots)
            except Exception as e:
                logger.error(
                    f"[Highest Slot Edge Worker] Error evaluating edge path {path_index}: {e}")
        return None

    @staticmethod
    def _highest_slot_edge_path_parallel(edge_paths):
        """
        Parallel version of highest_slot_edge_path.
        Evaluates all edge paths concurrently using ThreadPoolExecutor
        and picks the one with highest avg free slots.
        First path (lowest index) wins on tie.
        """
        import threading
        from concurrent.futures import ThreadPoolExecutor, as_completed
        # pyrefly: ignore [missing-import]
        from flask import current_app

        app = current_app._get_current_object()
        n_paths = len(edge_paths)
        num_workers = TopologyHelper._decide_workers(n_paths)

        results = []        # list of (index, avg_slots)
        results_lock = threading.Lock()

        def worker(index, edge_path):
            score_tuple = TopologyHelper._evaluate_edge_path_score(
                index, edge_path, app)
            if score_tuple is not None:
                with results_lock:
                    results.append(score_tuple)

        # logger.info(
        #    f"[Highest Slot Edge Parallel] Starting parallel evaluation: "
        #    f"{n_paths} edge paths, {num_workers} workers")

        with ThreadPoolExecutor(max_workers=num_workers) as executor:
            futures = {
                executor.submit(worker, i, edge_path): i
                for i, edge_path in enumerate(edge_paths)
            }
            for future in as_completed(futures):
                future.result()   # propagate exceptions if any

        if not results:
            # logger.info(
            #    f"[Highest Slot Edge Parallel] No valid edge paths scored, falling back to first")
            return edge_paths[0]

        # Select edge path with highest average free slots (first path wins on tie)
        best_index, best_score = max(results, key=lambda x: x[1])
        link_seq = [l['name'] for l in edge_paths[best_index]['links']]
        # logger.info(
        #    f"[Highest Slot Edge Parallel] Selected edge path index {best_index} "
        #    f"({' -> '.join(link_seq)}) with avg_slots={best_score:.2f}")
        return edge_paths[best_index]

    @staticmethod
    def _highest_slot_edge_path_sequential(edge_paths):
        """
        Original sequential version of highest_slot_edge_path.
        Preserved for easy rollback — change the dispatcher to call this instead.
        """
        from models import Endpoint, OpticalLink
        best_edge_path = None
        max_value = -1

        for edge_path in edge_paths:
            try:
                link_ids = [link['id'] for link in edge_path['links']]
                links_db = OpticalLink.query.filter(
                    OpticalLink.id.in_(link_ids)).all()

                endpoint_ids = []
                for l in links_db:
                    if l.src_endpoint_id:
                        endpoint_ids.append(l.src_endpoint_id)
                    if l.dst_endpoint_id:
                        endpoint_ids.append(l.dst_endpoint_id)

                endpoints = Endpoint.query.filter(
                    Endpoint.id.in_(endpoint_ids)).all()

                total_slots = 0
                for ep in endpoints:
                    bitmap_str = TopologyHelper.int_to_bitmap(
                        ep.bitmap_value, ep.flex_slots if ep.flex_slots else 35)
                    total_slots += bitmap_str.count('1')

                hops = len(edge_path['links'])
                if hops > 0:
                    avg_slots = total_slots / (hops*2)
                    if avg_slots > max_value:
                        max_value = avg_slots
                        best_edge_path = edge_path
            except Exception as e:
                logger.error(
                    f"[Highest Slot Edge] Error evaluating edge path: {e}")
                continue

        return best_edge_path if best_edge_path else edge_paths[0]

    @staticmethod
    def highest_slot_edge_path(edge_paths):
        """
        Entry point for highest-slot edge path selection.
        Dispatches to parallel or sequential based on edge path count.
        To rollback to sequential-only, change the condition to always use sequential.
        """
        n_paths = len(edge_paths)
        # To run always sequential, change the condition to always use sequential.
        if False:
            # if n_paths >= 2:
            # logger.info(
            #    f"[Highest Slot Edge] Dispatching to PARALLEL evaluation ({n_paths} edge paths)")
            return TopologyHelper._highest_slot_edge_path_parallel(edge_paths)
        else:
            # logger.info(
            #    f"[Highest Slot Edge] Dispatching to SEQUENTIAL evaluation ({n_paths} edge paths)")
            return TopologyHelper._highest_slot_edge_path_sequential(edge_paths)

    @staticmethod
    def _decide_workers(n_paths):
        """
        Decides optimal worker count based on path count and available cores.

        D = floor(log2(N))   — binary degree of the path count
        P = physical cores
        workers = D if D < P else P // 2
        Always >= 1.
        """
        import os
        P = os.cpu_count() or 4
        if n_paths <= 1:
            # logger.info(
            #    f"[Highest Slot Workers] P={P}, N={n_paths}, D=0 → workers=1 (trivial)")
            return 1
        D = int(math.log2(n_paths))
        D = max(D, 1)
        workers = D if D < P else P // 2
        workers = max(workers, 1)
        # logger.info(
        #    f"[Highest Slot Workers] P={P}, N={n_paths}, D={D} → workers={workers}")
        return workers

    @staticmethod
    def _evaluate_path_score(path_index, path, G, app):
        """
        Evaluates a single node path and returns (path_index, avg_slots).
        Designed to run inside a ThreadPoolExecutor worker.
        Pushes its own Flask app context for DB access.

        Returns:
            tuple (path_index, avg_slots) or None if the path is invalid.
        """
        import threading
        t = threading.current_thread()
        # logger.info(
        #    f"[Highest Slot Worker] Thread {t.name} (id={t.ident}) "
        #    f"starting path {path_index}: {' -> '.join(path)}")

        with app.app_context():
            try:
                edge_path = TopologyHelper.expand_path_first_valid(path, G)
                if not edge_path:
                    return None

                from models import OpticalLink, Endpoint
                link_ids = [link['id'] for link in edge_path['links']]
                links_db = OpticalLink.query.filter(
                    OpticalLink.id.in_(link_ids)).all()

                endpoint_ids = []
                for l in links_db:
                    if l.src_endpoint_id:
                        endpoint_ids.append(l.src_endpoint_id)
                    if l.dst_endpoint_id:
                        endpoint_ids.append(l.dst_endpoint_id)

                endpoints = Endpoint.query.filter(
                    Endpoint.id.in_(endpoint_ids)).all()

                total_slots = 0
                for ep in endpoints:
                    bitmap_str = TopologyHelper.int_to_bitmap(
                        ep.bitmap_value, ep.flex_slots if ep.flex_slots else 35)
                    total_slots += bitmap_str.count('1')

                hops = len(edge_path['links'])
                if hops > 0:
                    avg_slots = total_slots / (hops * 2)
                    # logger.info(
                    #    f"[Highest Slot Worker] Thread {t.name} (id={t.ident}) "
                    #    f"done path {path_index}: {' -> '.join(path)} | avg_slots={avg_slots:.2f}")
                    return (path_index, avg_slots)
            except Exception as e:
                logger.error(
                    f"[Highest Slot Worker] Error evaluating path {path_index}: {e}")
        return None

    @staticmethod
    def _highest_slot_path_parallel(node_paths, G):
        """
        Parallel version of highest_slot_path.
        Evaluates all node paths concurrently using ThreadPoolExecutor
        and picks the one with highest avg free slots.
        First path (lowest index) wins on tie.
        """
        import threading
        from concurrent.futures import ThreadPoolExecutor, as_completed
        # pyrefly: ignore [missing-import]
        from flask import current_app

        app = current_app._get_current_object()
        n_paths = len(node_paths)
        num_workers = TopologyHelper._decide_workers(n_paths)

        results = []        # list of (index, avg_slots)
        results_lock = threading.Lock()

        def worker(index, path):
            score_tuple = TopologyHelper._evaluate_path_score(
                index, path, G, app)
            if score_tuple is not None:
                with results_lock:
                    results.append(score_tuple)

        # logger.info(
        #    f"[Highest Slot Parallel] Starting parallel evaluation: "
        #    f"{n_paths} paths, {num_workers} workers")

        with ThreadPoolExecutor(max_workers=num_workers) as executor:
            futures = {
                executor.submit(worker, i, path): i
                for i, path in enumerate(node_paths)
            }
            for future in as_completed(futures):
                future.result()   # propagate exceptions if any

        if not results:
            # logger.info(
            #    f"[Highest Slot Parallel] No valid paths scored, falling back to first path")
            return node_paths[0]

        # Select path with highest average free slots (first path wins on tie)
        best_index, best_score = max(results, key=lambda x: x[1])
        # logger.info(
        #    f"[Highest Slot Parallel] Selected path index {best_index} "
        #    f"({' -> '.join(node_paths[best_index])}) with avg_slots={best_score:.2f}")
        return node_paths[best_index]

    @staticmethod
    def _highest_slot_path_sequential(node_paths, G):
        """
        Original sequential version of highest_slot_path.
        Preserved for easy rollback — change the dispatcher to call this instead.
        """
        from models import Endpoint
        best_path = None
        max_value = -1

        for path in node_paths:
            try:
                edge_path = TopologyHelper.expand_path_first_valid(path, G)
                if not edge_path:
                    continue

                from models import OpticalLink
                link_ids = [link['id'] for link in edge_path['links']]
                links_db = OpticalLink.query.filter(
                    OpticalLink.id.in_(link_ids)).all()

                endpoint_ids = []
                for l in links_db:
                    if l.src_endpoint_id:
                        endpoint_ids.append(l.src_endpoint_id)
                    if l.dst_endpoint_id:
                        endpoint_ids.append(l.dst_endpoint_id)

                endpoints = Endpoint.query.filter(
                    Endpoint.id.in_(endpoint_ids)).all()

                total_slots = 0
                for ep in endpoints:
                    bitmap_str = TopologyHelper.int_to_bitmap(
                        ep.bitmap_value, ep.flex_slots if ep.flex_slots else 35)
                    total_slots += bitmap_str.count('1')

                hops = len(edge_path['links'])
                if hops > 0:
                    # because two endpoints represent one link
                    avg_slots = total_slots / (hops*2)
                    if avg_slots > max_value:
                        max_value = avg_slots
                        best_path = path
            except Exception as e:
                logger.error(f"[Highest Slot] Error evaluating path: {e}")
                continue

        return best_path if best_path else node_paths[0]

    @staticmethod
    def highest_slot_path(node_paths, G):
        """
        Entry point for highest-slot path selection.
        Dispatches to parallel or sequential based on path count.
        To rollback to sequential-only, change the condition to always use sequential.
        """
        n_paths = len(node_paths)
        # To run always sequential, change the condition to always use sequential.
        if False:
            # if n_paths >= 2:
            # logger.info(
            #    f"[Highest Slot] Dispatching to PARALLEL evaluation ({n_paths} paths)")
            return TopologyHelper._highest_slot_path_parallel(node_paths, G)
        else:
            # logger.info(
            #    f"[Highest Slot] Dispatching to SEQUENTIAL evaluation ({n_paths} paths)")
            return TopologyHelper._highest_slot_path_sequential(node_paths, G)

    @staticmethod
    def rsa_bitmap_pre_compute(path_obj):
        from models import OpticalLink, Endpoint
        from sqlalchemy.orm import joinedload

        if not path_obj['links']:
            logger.error("[RSA Pre-Compute] No links in path")
            return None, 0, [], None, []

        # Step 1: Collect all unique endpoints and links using joinedload
        link_ids = [l['id'] for l in path_obj['links']]
        links_db = OpticalLink.query.filter(OpticalLink.id.in_(link_ids)).options(
            joinedload(OpticalLink.src_endpoint),
            joinedload(OpticalLink.dst_endpoint)
        ).all()

        # Map by ID for quick lookup preserving path order
        link_map = {str(link.id): link for link in links_db}

        endpoints_dict = {}
        for link_id in link_ids:
            link = link_map.get(link_id)
            if link:
                if link.src_endpoint:
                    endpoints_dict[link.src_endpoint.id] = link.src_endpoint
                if link.dst_endpoint:
                    endpoints_dict[link.dst_endpoint.id] = link.dst_endpoint

        endpoints = list(endpoints_dict.values())

        if not endpoints:
            logger.error("[RSA Pre-Compute] No valid endpoints found in path")
            return None, 0, [], None, []

        # Step 2: Calculate reference frequency range (widest range)
        valid_endpoints = [
            ep for ep in endpoints if ep.min_frequency and ep.max_frequency]
        if not valid_endpoints:
            logger.error(
                "[RSA Pre-Compute] No endpoints with valid frequency data")
            return None, 0, [], None, []

        _reference_min_freq = min([ep.min_frequency for ep in valid_endpoints])
        _reference_max_freq = max([ep.max_frequency for ep in valid_endpoints])

        # Step 3: Detect operational band
        band_info = OpticalBandHelper.detect_band(
            _reference_min_freq, _reference_max_freq)
        if not band_info:
            logger.error("[RSA Pre-Compute] Could not detect operational band")
            return None, 0, [], None, []

        # Use STANDARD band range as reference
        _selected_min_freq, _selected_max_freq = band_info['frequency_range_hz']
        SLOT_GRANULARITY_HZ = ITUStandards.SLOT_GRANULARITY.value
        reference_slots = int(
            (_selected_max_freq - _selected_min_freq) / SLOT_GRANULARITY_HZ)

        # Step 4: Initialize reference bitmap (all available)
        reference_bitmap = (1 << reference_slots) - 1
        trace_steps = []
        # the 'reference_bitmap' is a long sequence of 1's which represents the capacity in bits. The 1 represents the bit as free.

        # Step 5: Iterate through hops with direct endpoint intersection (No parallel blocking)
        for i, link_info in enumerate(path_obj['links']):
            link_id = link_info['id']
            hop_label = f"{link_info['src']} -> {link_info['dst']}"

            link = link_map.get(link_id)
            if not link or not link.src_endpoint or not link.dst_endpoint:
                logger.error(
                    f"[RSA Pre-Compute] Link {link_id} or its endpoints not found")
                continue

            # Align source endpoint directly
            src_bitmap = TopologyHelper.align_endpoint_to_reference(
                link.src_endpoint,
                _selected_min_freq,
                _selected_max_freq,
                SLOT_GRANULARITY_HZ
            )

            # Align destination endpoint directly
            dst_bitmap = TopologyHelper.align_endpoint_to_reference(
                link.dst_endpoint,
                _selected_min_freq,
                _selected_max_freq,
                SLOT_GRANULARITY_HZ
            )

            # Hop bitmap = intersection of JUST the source and destination endpoints
            hop_bitmap = src_bitmap & dst_bitmap
            reference_bitmap &= hop_bitmap

            # Record trace
            src_traces = [{
                'endpoint_name': link.src_endpoint.name,
                'is_path_endpoint': True,
                'min_freq_thz': link.src_endpoint.min_frequency / 1e12 if link.src_endpoint.min_frequency else None,
                'max_freq_thz': link.src_endpoint.max_frequency / 1e12 if link.src_endpoint.max_frequency else None,
                'flex_slots': link.src_endpoint.flex_slots if link.src_endpoint.flex_slots else 0,
                'original_bitmap': TopologyHelper.int_to_bitmap(int(link.src_endpoint.bitmap_value) if link.src_endpoint.bitmap_value else 0, link.src_endpoint.flex_slots if link.src_endpoint.flex_slots else 0),
                'aligned_bitmap': TopologyHelper.int_to_bitmap(src_bitmap, reference_slots)
            }]

            dst_traces = [{
                'endpoint_name': link.dst_endpoint.name,
                'is_path_endpoint': True,
                'min_freq_thz': link.dst_endpoint.min_frequency / 1e12 if link.dst_endpoint.min_frequency else None,
                'max_freq_thz': link.dst_endpoint.max_frequency / 1e12 if link.dst_endpoint.max_frequency else None,
                'flex_slots': link.dst_endpoint.flex_slots if link.dst_endpoint.flex_slots else 0,
                'original_bitmap': TopologyHelper.int_to_bitmap(int(link.dst_endpoint.bitmap_value) if link.dst_endpoint.bitmap_value else 0, link.dst_endpoint.flex_slots if link.dst_endpoint.flex_slots else 0),
                'aligned_bitmap': TopologyHelper.int_to_bitmap(dst_bitmap, reference_slots)
            }]

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
                'src_device_bitmap': TopologyHelper.int_to_bitmap(src_bitmap, reference_slots),
                'dst_device_bitmap': TopologyHelper.int_to_bitmap(dst_bitmap, reference_slots),
                'hop_bitmap': TopologyHelper.int_to_bitmap(hop_bitmap, reference_slots),
                'cumulative_bitmap': TopologyHelper.int_to_bitmap(reference_bitmap, reference_slots)
            })

        return reference_bitmap, reference_slots, trace_steps, band_info, endpoints

    @staticmethod
    def get_bandwidth(bitrate):
        """
        Calculates required optical bandwidth (in GHz) from requested bitrate (in Gbps).
        """
        return (float(bitrate) / 4.0) * 1.2

    @staticmethod
    def perform_rsa(path_obj, bitrate, strategy='first-fit'):
        import time
        t_rsa_start = time.time()
        if not bitrate:
            return None
        bitrate_gbps = bitrate
        calculated_bandwidth_ghz = TopologyHelper.get_bandwidth(bitrate_gbps)

        SLOT_GRANULARITY_HZ = ITUStandards.SLOT_GRANULARITY.value
        SLOT_GRANULARITY_GHZ = SLOT_GRANULARITY_HZ / FrequencyMeasurementUnit.GHz.value
        num_slots = math.ceil(calculated_bandwidth_ghz / SLOT_GRANULARITY_GHZ)
        # Based on the last discussion slots as fixed 100gb-4, 200gb-5 & 400gb-6 slots of 12.5GHz width
        if bitrate_gbps == 100:
            num_slots = 8
        elif bitrate_gbps == 200:
            num_slots = 10
        else:
            num_slots = 12

        if not path_obj['links']:
            return None
        logger.info(
            f"[SLOT SELECTION: Bitrate:] {strategy} [6.25 SLOTS: ] {num_slots}")
        # Step 1: Pre-compute with reference bitmap
        result = TopologyHelper.rsa_bitmap_pre_compute(path_obj)

        if not result or result[0] is None:
            logger.error("[RSA] Pre-compute failed")
            return None

        reference_bitmap, reference_slots, trace_steps, band_info, endpoints = result

        # Step 2: Discover all valid contiguous slot blocks
        available_blocks = []
        current_run = 0

        for i in range(reference_slots):
            is_free = (reference_bitmap >> i) & 1

            if is_free:
                current_run += 1
                if current_run >= num_slots:
                    available_blocks.append(i - num_slots + 1)
            else:
                current_run = 0

        # Step 3: Selection Phase based on strategy
        start_bit = -1
        # logger.info(
        #     f"[Strategy: spectrum assignment] {strategy}")
        if available_blocks:
            if strategy == 'last-fit':
                start_bit = available_blocks[-1]
            elif strategy == 'random':
                import random
                start_bit = random.choice(available_blocks)
            else:  # default to first-fit
                start_bit = available_blocks[0]

        if start_bit != -1:
            mask = ((1 << num_slots) - 1) << start_bit
            final_bitmap_val = reference_bitmap & ~mask

            common_bitmap_str = f"{reference_bitmap:0{reference_slots}b}"
            required_slots_str = f"{mask:0{reference_slots}b}"
            final_bitmap_str = f"{final_bitmap_val:0{reference_slots}b}"
            rsa_ms = (time.time() - t_rsa_start) * 1000
            # logger.info(f"[Timing] RSA computation: {rsa_ms:.4f} ms")
            return {
                'success': True,
                'num_slots': num_slots,
                'start_slot': start_bit,
                'common_bitmap': common_bitmap_str,
                'required_slots': required_slots_str,
                'final_bitmap': final_bitmap_str,
                'final_bitmap_int': final_bitmap_val,
                'trace_steps': trace_steps,
                'band_info': band_info,
                'mask': mask,
                'endpoints': endpoints,
                'links': path_obj['links'],
                'rsa_ms': rsa_ms
            }
        else:
            rsa_ms = (time.time() - t_rsa_start) * 1000
            # logger.info(f"[Timing] RSA computation: {rsa_ms:.4f} ms")
            return {
                'success': False,
                'num_slots': num_slots,
                'common_bitmap': f"{reference_bitmap:0{reference_slots}b}",
                'error': f"No {num_slots} contiguous slots available",
                'trace_steps': trace_steps,
                'band_info': band_info,
                'mask': 0,
                'endpoints': [],
                'links': path_obj['links'],
                'rsa_ms': rsa_ms
            }

    @staticmethod
    def commit_slots(endpoints, allocated_mask):

        from models import db, OpticalLink, Endpoint
        if not endpoints or allocated_mask is None:
            return False

        try:
            valid_endpoints = [
                ep for ep in endpoints if ep.min_frequency and ep.max_frequency]

            if not valid_endpoints:
                return False

            # Step 2: Detect band (same logic as pre-compute for alignment)
            _reference_min_freq = min(
                [ep.min_frequency for ep in valid_endpoints])
            _reference_max_freq = max(
                [ep.max_frequency for ep in valid_endpoints])
            band_info = OpticalBandHelper.detect_band(
                _reference_min_freq, _reference_max_freq)
            if not band_info:
                return False

            _selected_min_freq, _selected_max_freq = band_info['frequency_range_hz']
            SLOT_GRANULARITY_HZ = ITUStandards.SLOT_GRANULARITY.value

            mask = int(allocated_mask)
            updated_count = 0

            # Step 3: Validation and Update
            for ep in valid_endpoints:
                if not ep.min_frequency or not ep.flex_slots:
                    continue

                # Shrink mask to endpoint width
                shrinked_mask = TopologyHelper.convert_mask_to_endpoint(
                    mask, _selected_min_freq, ep, SLOT_GRANULARITY_HZ
                )

                current_bitmap = int(ep.bitmap_value) if ep.bitmap_value else 0

                # Reserved slots: Set bits to 0
                new_bitmap = current_bitmap & ~shrinked_mask
                ep.bitmap_value = str(new_bitmap)

                # Update in_use and status
                all_available = (1 << ep.flex_slots) - 1
                ep.in_use = (new_bitmap != all_available)

                if ep.otn_type == OTN_TYPE_OMS:
                    if new_bitmap == 0:
                        ep.status = "FULL"
                    elif new_bitmap == all_available:
                        ep.status = "FREE"
                    else:
                        ep.status = "USED"

                updated_count += 1

            db.session.commit()
            return True

        except Exception as e:
            db.session.rollback()
            logger.error(f"[RSA Commit] Error: {e}", exc_info=True)
            return False

    @staticmethod
    def free_slots(link_ids, allocated_mask):
        """
        Reverses commit_slots by releasing the assigned spectrum back using Bitwise OR.
        Updates endpoint status according to the new fill level.
        """
        from models import db, OpticalLink, Endpoint

        if not link_ids or allocated_mask is None:
            return False

        try:
            from sqlalchemy.orm import joinedload
            links = OpticalLink.query.filter(OpticalLink.id.in_(link_ids)).options(
                joinedload(OpticalLink.src_endpoint),
                joinedload(OpticalLink.dst_endpoint)
            ).all()
            if not links:
                logger.error(f"[RSA Free] No links found for IDs: {link_ids}")
                return False

            path_endpoints = []
            for link in links:
                if link.src_endpoint and link.src_endpoint not in path_endpoints:
                    path_endpoints.append(link.src_endpoint)
                if link.dst_endpoint and link.dst_endpoint not in path_endpoints:
                    path_endpoints.append(link.dst_endpoint)

            valid_endpoints = [
                ep for ep in path_endpoints if ep.min_frequency and ep.max_frequency]

            if not valid_endpoints:
                logger.error("[RSA Free] No valid path endpoints found")
                return False

            _reference_min_freq = min(
                [ep.min_frequency for ep in valid_endpoints])
            _reference_max_freq = max(
                [ep.max_frequency for ep in valid_endpoints])

            band_info = OpticalBandHelper.detect_band(
                _reference_min_freq, _reference_max_freq)
            if not band_info:
                logger.error("[RSA Free] Could not detect band")
                return False

            _selected_min_freq, _selected_max_freq = band_info['frequency_range_hz']
            SLOT_GRANULARITY_HZ = ITUStandards.SLOT_GRANULARITY.value

            mask = int(allocated_mask)
            updated_count = 0

            for ep in valid_endpoints:
                shrinked_mask = TopologyHelper.convert_mask_to_endpoint(
                    mask, _selected_min_freq, ep, SLOT_GRANULARITY_HZ
                )
                current_bitmap = int(ep.bitmap_value) if ep.bitmap_value else 0

                # Bitwise OR to restore the allocated slots to 1 (Free)
                new_bitmap = current_bitmap | shrinked_mask
                ep.bitmap_value = str(new_bitmap)

                all_available = (1 << ep.flex_slots) - 1
                ep.in_use = (new_bitmap != all_available)

                # Update status following the same rules as commit_slots
                if ep.otn_type == OTN_TYPE_OMS:
                    if new_bitmap == 0:
                        ep.status = "FULL"
                    elif new_bitmap == all_available:
                        ep.status = "FREE"
                    else:
                        ep.status = "USED"

                updated_count += 1

            db.session.commit()
            return True

        except Exception as e:
            db.session.rollback()
            logger.error(f"[RSA Free] Error: {e}", exc_info=True)
            return False

    @staticmethod
    def process_optical_links(links):
        """
        Simplified processor that relies on Endpoint.status as the single source of truth.
        """
        processed_links = []
        for link in links:
            src_ep = link.src_endpoint
            dst_ep = link.dst_endpoint

            # Determine consolidated OTN Type (kept for UI safety)
            if src_ep.otn_type == dst_ep.otn_type:
                otn_type = src_ep.otn_type
            else:
                otn_type = OTN_TYPE_MISMATCH

            # Link status is simply displayed from endpoints
            # Both endpoints on a link are kept in sync during commit/free
            link_status = src_ep.status

            processed_links.append({
                'id': link.id,
                'name': link.name,
                'src_device': link.src_device,
                'src_endpoint': src_ep,
                'dst_device': link.dst_device,
                'dst_endpoint': dst_ep,
                'status': link_status,
                'otn_type': otn_type
            })
        return processed_links
