import logging
import random
import os
from helpers import TopologyHelper
from models import Devices, OpticalLink, Endpoint
import matplotlib.pyplot as plt
import networkx as nx
import matplotlib
matplotlib.use('Agg')

from functools import lru_cache

@lru_cache(maxsize=None)
def build_graph(directed=False):
    from models import db
    from sqlalchemy.orm import aliased
    import logging

    # Create graph based on flag
    if directed:
        G = nx.MultiDiGraph()
    else:
        G = nx.MultiGraph()

    # Fetch all devices (nodes)
    devices = Devices.query.with_entities(Devices.name, Devices.type).all()
    for name, dev_type in devices:
        G.add_node(name, type=dev_type)

    SrcDevice = aliased(Devices)
    DstDevice = aliased(Devices)
    SrcEndpoint = aliased(Endpoint)
    DstEndpoint = aliased(Endpoint)

    links = db.session.query(
        OpticalLink.id,
        OpticalLink.name,
        SrcDevice.name.label('src_device_name'),
        DstDevice.name.label('dst_device_name'),
        SrcEndpoint.name.label('src_endpoint_name'),
        DstEndpoint.name.label('dst_endpoint_name')
    ).join(SrcDevice, OpticalLink.src_device_id == SrcDevice.id) \
     .join(DstDevice, OpticalLink.dst_device_id == DstDevice.id) \
     .join(SrcEndpoint, OpticalLink.src_endpoint_id == SrcEndpoint.id) \
     .join(DstEndpoint, OpticalLink.dst_endpoint_id == DstEndpoint.id).all()

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


def generate_topology_graph():
    # Build Directed Graph once for both Layout (Linearity) and Drawing
    # Layout needs directed=True for in_degree (Left->Right flow)
    # Drawing works fine with directed=True because we group edges manually
    G = build_graph(directed=True)

    # Visualization
    plt.figure(figsize=(15, 8))

    # --- Layout Calculation using G (Directed) ---
    layers = {}
    # Find sources (in-degree 0) in the DIRECTED graph
    sources = [n for n, d in G.in_degree() if d == 0]
    if not sources:
        sources = [n for n in G.nodes() if 'TP' in n]  # Fallback

    # Longest path layering using DIRECTED graph
    for node in G.nodes():
        max_dist = 0
        for source in sources:
            try:
                if nx.has_path(G, source, node):
                    dist = nx.shortest_path_length(G, source, node)
                    if dist > max_dist:
                        max_dist = dist
            except:
                pass
        layers[node] = max_dist

    # Group nodes by layer
    nodes_by_layer = {}
    for node, layer in layers.items():
        if layer not in nodes_by_layer:
            nodes_by_layer[layer] = []
        nodes_by_layer[layer].append(node)

    # Assign positions
    pos = {}
    for layer, nodes in nodes_by_layer.items():
        nodes.sort()
        y_step = 1.0 / (len(nodes) + 1)
        for i, node in enumerate(nodes):
            x = layer * 2.0
            y = 1.0 - (i + 1) * y_step
            pos[node] = (x, y)

    if not pos:
        pos = nx.shell_layout(G)

    # --- Drawing using G (Undirected) ---

    # Draw Nodes
    node_colors = []
    for node in G.nodes(data=True):
        if node[1].get('type') == 'ROADM':
            node_colors.append('#ff7f0e')
        else:
            node_colors.append('#1f77b4')

    nx.draw_networkx_nodes(G, pos, node_size=2000, node_color='lightblue')
    nx.draw_networkx_labels(G, pos, font_size=10, font_weight='bold')

    # Draw Edges
    # Group edges by pair to calculate count
    edge_groups = {}
    for u, v, k, d in G.edges(keys=True, data=True):
        pair = tuple(sorted((u, v)))
        if pair not in edge_groups:
            edge_groups[pair] = []
        edge_groups[pair].append((u, v, k, d))

    # Draw single edge per pair
    for idx, (pair, edges) in enumerate(edge_groups.items()):
        u, v = pair
        count = len(edges)

        # Draw one thick red line
        nx.draw_networkx_edges(
            G, pos,
            edgelist=[(u, v)],
            edge_color='red',
            width=2,
            arrows=False
        )

        # Add label with count
        # Calculate midpoint for label
        x1, y1 = pos[u]
        x2, y2 = pos[v]
        x_mid = (x1 + x2) / 2
        y_mid = (y1 + y2) / 2

        plt.text(
            x_mid, y_mid,
            f"p_links: {count}",
            fontsize=8,
            color='red',
            fontweight='bold',
            bbox=dict(facecolor='white', edgecolor='none', alpha=0.7)
        )

    plt.title("Network Topology")
    plt.axis('off')

    static_dir = os.path.join(os.path.dirname(__file__), 'static')
    if not os.path.exists(static_dir):
        os.makedirs(static_dir)

    output_path = os.path.join(static_dir, 'topology.png')
    plt.savefig(output_path, bbox_inches='tight')
    plt.close()

    return "topology.png"


def get_topology_data():
    """
    Returns topology data in a format suitable for Vis.js.
    Nodes and edges are styled for premium aesthetics.
    """
    G = build_graph()

    nodes = []
    edges = []

    # Process Nodes
    for node_name, data in G.nodes(data=True):
        node_type = data.get('type', 'unknown').upper()

        # Premium styling based on type
        if 'ROADM' in node_type:
            color = {'background': '#e67e22',
                     'border': '#d35400', 'highlight': '#f39c12'}
            shape = 'dot'
            size = 18  # Reduced from 25 to give more space
            font_color = '#2c3e50'
        else:
            color = {'background': '#2c3e50',
                     'border': '#34495e', 'highlight': '#7f8c8d'}
            shape = 'box'
            size = 20
            font_color = '#ffffff'

        nodes.append({
            'id': node_name,
            'label': node_name,
            'title': f"Type: {node_type}",
            'color': color,
            'shape': shape,
            'size': size,
            'font': {'color': font_color, 'size': 16, 'bold': True, 'face': 'Inter, Roboto, sans-serif'}
        })

    # Process Edges (Aggregate parallel links)
    edge_groups = {}
    for u, v, k, d in G.edges(keys=True, data=True):
        pair = tuple(sorted((u, v)))
        if pair not in edge_groups:
            edge_groups[pair] = {'count': 0, 'otn': d.get(
                'otn_type'), 'status': d.get('status')}
        edge_groups[pair]['count'] += 1

    for pair, data in edge_groups.items():
        u, v = pair
        count = data['count']

        # Edge styling
        color = '#bdc3c7'  # Default
        if data['otn'] == 'OCH':
            color = '#3498db'  # Blue for OCH
        elif data['otn'] == 'OMS':
            color = '#95a5a6'  # Grey for OMS

        edges.append({
            'from': u,
            'to': v,
            'label': f"{count} {'link' if count == 1 else 'links'}",
            'title': f"Parallel Links: {count}<br>Type: {data['otn']}",
            'color': color,
            'width': 2 + (count * 0.5),  # Scale width by link density
            'smooth': {'type': 'continuous'}
        })

    return {'nodes': nodes, 'edges': edges}


# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


def find_paths(src_dev, dst_dev, bitrate=None, strategy='first-fit', path_type='both', parallelpath_strategy='none'):
    EXTRA_HOPS_ALLOWED = 1
    G = build_graph()

    # Convert to simple graph for route-level path finding to avoid
    # NetworkX redundantly traversing parallel links and returning
    # duplicate node sequences.
    G_simple = nx.Graph(G)
    result = {
        'path': None,
        'total_candidates': 0,
        'valid_candidates': 0,
        'strategy': strategy,
        'blocked_reason': None
    }
    logger.info(
            f"[Strategy:] path selection {strategy}")
    logger.info(
            f"[Strategy:] path type {path_type}")
    logger.info(
            f"[Strategy:] parallel path type {parallelpath_strategy}")      
    # ================================================================
    # Phase 1: Dijkstra — pick ONE node path via strategy, expand to ONE path
    # ================================================================
    # nx.all_shortest_paths returns all routes with the minimum hop count.
    # The strategy selects one node-level route from that set, then
    # expand_path_first_valid picks the first valid parallel link combination
    # for that route. Result: exactly 1 path — no exponential blowup.
    # ================================================================
    dijkstra_collection = []
    dijkstra_hops = None
    dijkstra_node_paths = []

    try:
        dijkstra_node_paths = list(nx.all_shortest_paths(
            G_simple, source=src_dev, target=dst_dev))

        if dijkstra_node_paths:
            dijkstra_hops = len(dijkstra_node_paths[0]) - 1

            if path_type in ['dijkstra', 'both']:
                # Apply strategy to select ONE node path
                if strategy == 'last-fit':
                    chosen_node_path = dijkstra_node_paths[-1]
                elif strategy == 'random':
                    chosen_node_path = random.choice(dijkstra_node_paths)
                else:
                    # Default: first-fit
                    chosen_node_path = dijkstra_node_paths[0]
                logger.info(f"[Phase 1] chosen dijkstra shortest path: {' -> '.join(chosen_node_path)}")

                # Expand the chosen node path based on parallelpath_strategy
                if parallelpath_strategy != 'none':
                    parallel_paths = TopologyHelper.expand_path(chosen_node_path, G)

                    if parallel_paths:
                        # Apply strategy to pick ONE parallel combination
                        if parallelpath_strategy == 'last-fit':
                            dijkstra_collection = [parallel_paths[-1]]
                        elif parallelpath_strategy == 'random':
                            dijkstra_collection = [random.choice(parallel_paths)]
                        else:
                            # Default: first-fit
                            dijkstra_collection = [parallel_paths[0]]
                        # p = dijkstra_collection[0]; logger.info(f"[Phase 1] chosen parallel link path: {' -> '.join([p['links'][0]['src']] + [l['dst'] for l in p['links']])} via links [{', '.join([l['name'] for l in p['links']])}]")
                else:
                    single_path = TopologyHelper.expand_path_first_valid(chosen_node_path, G)
                    if single_path:
                        dijkstra_collection = [single_path]
                        # p = dijkstra_collection[0]; logger.info(f"[Phase 1] chosen single link path: {' -> '.join([p['links'][0]['src']] + [l['dst'] for l in p['links']])} via links [{', '.join([l['name'] for l in p['links']])}]")
    except nx.NetworkXNoPath:
        logger.info(
            f"[Phase 1] No dijkstra path from {src_dev} to {dst_dev}")


    # ================================================================
    all_paths_collection = []
    if path_type in ['additional', 'both']:
        # Phase 2: Collect ALL simple paths → expand to parallel
        # ================================================================
        all_paths_collection = []

        # Determine dynamic cutoff
        if dijkstra_hops is not None:
            dynamic_cutoff = dijkstra_hops + EXTRA_HOPS_ALLOWED
        else:
            try:
                shortest_hops = nx.shortest_path_length(
                    G_simple, source=src_dev, target=dst_dev)
                dynamic_cutoff = shortest_hops + EXTRA_HOPS_ALLOWED
            except nx.NetworkXNoPath:
                # No connectivity at all
                result['blocked_reason'] = 'no_path'
                return result
        try:
            simple_node_paths = list(nx.all_simple_paths(
                G_simple, source=src_dev, target=dst_dev, cutoff=dynamic_cutoff))

            # Remove node paths already covered by dijkstra Phase 1
            if path_type == 'both':
                # Deduplicate: track dijkstra node paths as tuples to skip them
                dijkstra_node_set = set(tuple(p) for p in dijkstra_node_paths)
                simple_node_paths = [
                    p for p in simple_node_paths
                    if tuple(p) not in dijkstra_node_set
                ]

            if simple_node_paths:
                # Apply strategy to pick ONE alternative node path
                if strategy == 'last-fit':
                    chosen_alt_path = simple_node_paths[-1]
                elif strategy == 'random':
                    chosen_alt_path = random.choice(simple_node_paths)
                elif strategy == 'highest-slot':
                    chosen_alt_path = TopologyHelper.highest_slot_path(simple_node_paths, G)
                else:
                    chosen_alt_path = simple_node_paths[0]
                logger.info(f"[Phase 2] chosen additional path: {' -> '.join(chosen_alt_path)}")
                # Expand the chosen node path based on parallelpath_strategy
                if parallelpath_strategy != 'none':
                    alt_parallel_paths = TopologyHelper.expand_path(chosen_alt_path, G)

                    if alt_parallel_paths:
                        # Apply strategy to pick ONE parallel combination
                        if parallelpath_strategy == 'last-fit':
                            all_paths_collection = [alt_parallel_paths[-1]]
                        elif parallelpath_strategy == 'random':
                            all_paths_collection = [random.choice(alt_parallel_paths)]
                        else:
                            all_paths_collection = [alt_parallel_paths[0]]
                        # p = all_paths_collection[0]; logger.info(f"[Phase 2] chosen parallel link path: {' -> '.join([p['links'][0]['src']] + [l['dst'] for l in p['links']])} via links [{', '.join([l['name'] for l in p['links']])}]")
                else:
                    single_path = TopologyHelper.expand_path_first_valid(chosen_alt_path, G)
                    if single_path:
                        all_paths_collection = [single_path]
                        # p = all_paths_collection[0]; logger.info(f"[Phase 2] chosen single link path: {' -> '.join([p['links'][0]['src']] + [l['dst'] for l in p['links']])} via links [{', '.join([l['name'] for l in p['links']])}]")
        except nx.NetworkXNoPath:
            logger.info(
                f"[Phase 2] No simple paths from {src_dev} to {dst_dev}")

        # ================================================================
    # Phase 3: Combine — dijkstra first, alternative second
    # The API will try RSA on each in order, stopping at first success.
    # ================================================================
    if path_type == 'dijkstra':
        paths = dijkstra_collection
    elif path_type == 'additional':
        paths = all_paths_collection
    else:
        paths = dijkstra_collection + all_paths_collection
    if not paths:
        result['blocked_reason'] = 'no_path'
        # logger.info(
        #     f"[Phase 3] No candidate paths at all for {src_dev} -> {dst_dev}")
        return result

    result['paths'] = paths
    # logger.info(f"[Phase 3] Returning {len(paths)} path(s) "
    #             f"(dijkstra={len(dijkstra_collection)}, "
    #             f"alt={len(all_paths_collection)}) "
    #             f"for {src_dev} -> {dst_dev}")

    return result



def perform_rsa_for_path(link_ids, bitrate):
    """
    Reconstructs a path object from a list of link IDs and performs RSA.
    Optimized: Queries DB directly using tuples instead of ORM objects.
    """
    from models import OpticalLink, Endpoint, Devices, db
    from sqlalchemy.orm import aliased
    from helpers import TopologyHelper

    if not link_ids:
        return None

    SrcDevice = aliased(Devices)
    DstDevice = aliased(Devices)
    SrcEndpoint = aliased(Endpoint)
    DstEndpoint = aliased(Endpoint)

    links_db = db.session.query(
        OpticalLink.id,
        OpticalLink.name,
        SrcDevice.name.label('src_device_name'),
        DstDevice.name.label('dst_device_name'),
        SrcEndpoint.name.label('src_endpoint_name'),
        DstEndpoint.name.label('dst_endpoint_name'),
        SrcEndpoint.status.label('src_status')
    ).join(SrcDevice, OpticalLink.src_device_id == SrcDevice.id) \
     .join(DstDevice, OpticalLink.dst_device_id == DstDevice.id) \
     .join(SrcEndpoint, OpticalLink.src_endpoint_id == SrcEndpoint.id) \
     .join(DstEndpoint, OpticalLink.dst_endpoint_id == DstEndpoint.id) \
     .filter(OpticalLink.id.in_(link_ids)).all()

    if not links_db:
        return None

    # Map by ID for ordering
    link_map = {str(link.id): link for link in links_db}

    path_links = []
    for link_id in link_ids:
        link = link_map.get(str(link_id))
        if link:
            path_links.append({
                'id': str(link.id),
                'src': link.src_device_name,
                'dst': link.dst_device_name,
                'src_port': link.src_endpoint_name,
                'dst_port': link.dst_endpoint_name,
                'name': link.name,
                'status': link.src_status  # Correct source of truth
            })

    if not path_links:
        return None

    path_obj = {'links': path_links}

    # 2. Perform RSA (Port-free logic)
    res = TopologyHelper.perform_rsa(path_obj, bitrate)
    if res:
        res['links'] = path_links
    return res
