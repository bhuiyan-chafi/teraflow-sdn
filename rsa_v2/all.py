# Generating the Poisson Arrival

import heapq
import random
import networkx as nx
from helpers import TopologyHelper


def run_simulation():
    for erlang in sorted(list(ERLANGS), reverse=True):
        arrival_rate = erlang / HOLDING_TIME
        event_queue = []
        first_arrival_delay = random.expovariate(arrival_rate)
        heapq.heappush(event_queue, Event(first_arrival_delay, "ARRIVAL"))
        # Main Discrete Event Loop - runs until stopping condition met
        while True:
            if not event_queue:
                break
            current_event = heapq.heappop(event_queue)
            virtual_time = current_event.v_time
            if current_event.event_type == "ARRIVAL":
                next_arrival_time = virtual_time + \
                    random.expovariate(arrival_rate)
                heapq.heappush(event_queue, Event(
                    next_arrival_time, "ARRIVAL"))

                # Build random payload
                src, dst = random.sample(NODES, 2)
                bitrate = random.choices(
                    BIT_RATES, weights=BIT_RATE_PROBS, k=1)[0]

                payload = {
                    "src_device": src,
                    "dst_device": dst,
                    "bitrate": bitrate,
                    "path_strategy": PATH_STRATEGY,
                    "spectrum_strategy": SPECTRUM_STRATEGY,
                    "path_type": PATH_TYPE,
                    "parallelpath_strategy": PARALLELPATH_STRATEGY
                }
                resp = session.post(
                    API_URL, json=payload, timeout=30).json()
                status = resp.get('status')
                if status == 'success':
                    active_connections += 1
                    lp_id = resp.get('lightpath_id')
                    heapq.heappush(event_queue, Event(
                        teardown_time, "TEARDOWN", {"id": lp_id}))


# The path finding function
def find_paths(src_dev, dst_dev, bitrate=None, strategy='first-fit', path_type='both', parallelpath_strategy='none'):
    EXTRA_HOPS_ALLOWED = 1
    G = build_graph()
    # Drop the parallel edges to reduce computational time
    G_simple = nx.Graph(G)
    dijkstra_node_paths = []
    dijkstra_node_paths = list(nx.all_shortest_paths(
        G_simple, source=src_dev, target=dst_dev))
    if strategy == 'last-fit':
        chosen_node_path = dijkstra_node_paths[-1]
    elif strategy == 'random':
        chosen_node_path = random.choice(dijkstra_node_paths)
    elif strategy == 'highest-slot':
        chosen_node_path = TopologyHelper.highest_slot_path(
            dijkstra_node_paths, G)
    else:
        chosen_node_path = dijkstra_node_paths[0]

    # Choose parallel path
    if parallelpath_strategy != 'none':
        parallel_paths = TopologyHelper.expand_path(
            chosen_node_path, G)
        if parallel_paths:
            if parallelpath_strategy == 'last-fit':
                dijkstra_collection = [parallel_paths[-1]]
            elif parallelpath_strategy == 'random':
                dijkstra_collection = [
                    random.choice(parallel_paths)]
            elif parallelpath_strategy == 'highest-slot':
                dijkstra_collection = [
                    TopologyHelper.highest_slot_edge_path(parallel_paths)]
            else:
                dijkstra_collection = [parallel_paths[0]]


# perform spectrum assignment
def perform_rsa(path_obj, bitrate, strategy='first-fit'):
    result = TopologyHelper.rsa_bitmap_pre_compute(path_obj)
    result = TopologyHelper.commit_slots(rsa_res.get('endpoints', []), mask)
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

# Build the Graph


@lru_cache(maxsize=None)
def build_graph(directed=False):
    devices = Devices.query.with_entities(Devices.name, Devices.type).all()
    for name, dev_type in devices:
        G = nx.MultiGraph()
        G.add_node(name, type=dev_type)
    links = db.session.query()

    for link in links:
        src_device = link.src_device_name
        dst_device = link.dst_device_name

        # Add edge with all attributes
        G.add_edge(
            src_device,
            dst_device,
            key=link.id,
            name=link.name,
            original_src=src_device,
            original_dst=dst_device,
            src_port=link.src_endpoint_name,
            dst_port=link.dst_endpoint_name,
            capacity=100
        )
    return G


# Find the highest slot path
def highest_slot_path(node_paths, G):
    for ep in endpoints:
        bitmap_str = TopologyHelper.int_to_bitmap(
            ep.bitmap_value, ep.flex_slots if ep.flex_slots else 35)
        total_slots += bitmap_str.count('1')

    hops = len(edge_path['links'])
    if hops > 0:
        avg_slots = total_slots / (hops*2)
        if avg_slots > max_value:
            max_value = avg_slots
            best_path = path


# Expand the parallel paths
def expand_path(node_path, graph_to_use):
    valid_edge_paths = []

    def backtrack_v2(index, current_edge_path):
        if index == len(node_path) - 1:
            path_info = {
                'links': list(current_edge_path),
                'is_valid': True
            }
            valid_edge_paths.append(path_info)
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


# Bitmap pre-computation
def rsa_bitmap_pre_compute(path_obj):
    # Step 1: Collect all unique endpoints and links
    link_ids = [l['id'] for l in path_obj['links']]
    # Map by ID for quick lookup preserving path order
    link_map = {str(link.id): link for link in links_db}
    valid_endpoints = [
        ep for ep in endpoints if ep.min_frequency and ep.max_frequency]
    _reference_min_freq = min([ep.min_frequency for ep in valid_endpoints])
    _reference_max_freq = max([ep.max_frequency for ep in valid_endpoints])
    # Use STANDARD band range as reference
    _selected_min_freq, _selected_max_freq = band_info['frequency_range_hz']
    SLOT_GRANULARITY_HZ = ITUStandards.SLOT_GRANULARITY.value
    reference_slots = int(
        (_selected_max_freq - _selected_min_freq) / SLOT_GRANULARITY_HZ)
    # Step 4: Initialize reference bitmap (all available)
    reference_bitmap = (1 << reference_slots) - 1
    # Step 5: Iterate through hops with direct endpoint intersection (No parallel blocking)
    for i, link_info in enumerate(path_obj['links']):
        src_bitmap = TopologyHelper.align_endpoint_to_reference(
            link.src_endpoint,
            _selected_min_freq,
            _selected_max_freq,
            SLOT_GRANULARITY_HZ
        )


# Align bitmap to reference
def align_endpoint_to_reference(endpoint, _selected_min_freq, _selected_max_freq, SLOT_GRANULARITY_HZ):
    # Calculate reference width
    reference_slots = int(
        (_selected_max_freq - _selected_min_freq) / SLOT_GRANULARITY_HZ)
    # Use endpoint's flex_slots from database (authoritative value)
    endpoint_slots = endpoint.flex_slots if endpoint.flex_slots else 0
    # Calculate low-end offset: how many slots before endpoint's min_frequency
    low_offset_hz = endpoint.min_frequency - _selected_min_freq
    low_offset_slots = int(low_offset_hz / SLOT_GRANULARITY_HZ)
    endpoint_width_mask = (1 << endpoint_slots) - 1
    endpoint_bitmap &= endpoint_width_mask
    # Step 2: Shift left by low-end offset to position correctly in reference
    aligned_bitmap = endpoint_bitmap << low_offset_slots
    # Step 3: Mask to reference width to ensure high-end zeros
    reference_mask = (1 << reference_slots) - 1
    aligned_bitmap &= reference_mask
