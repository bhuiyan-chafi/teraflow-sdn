import logging
import random
import os
from helpers import TopologyHelper
from models import Devices, OpticalLink, Endpoint
import matplotlib.pyplot as plt
import networkx as nx
import matplotlib
matplotlib.use('Agg')


def build_graph(directed=False):
    # Create graph based on flag
    if directed:
        G = nx.MultiDiGraph()
    else:
        G = nx.MultiGraph()

    # Fetch all devices (nodes)
    devices = Devices.query.all()
    for device in devices:
        G.add_node(device.name, type=device.type)

    from sqlalchemy.orm import joinedload

    # Fetch all optical links (edges) with joinedload to prevent N+1 queries
    links = OpticalLink.query.options(
        joinedload(OpticalLink.src_device),
        joinedload(OpticalLink.dst_device),
        joinedload(OpticalLink.src_endpoint),
        joinedload(OpticalLink.dst_endpoint)
    ).all()
    for link in links:
        src_device = link.src_device.name
        dst_device = link.dst_device.name
        # Determine OTN Type
        src_otn = link.src_endpoint.otn_type
        dst_otn = link.dst_endpoint.otn_type

        if src_otn == dst_otn:
            otn_type = src_otn
        else:
            otn_type = "ERROR"
            logger.error(
                f"[Graph Build] OTN TYPE MISMATCH on link {link.name}: {src_otn} vs {dst_otn}")

        # Derive status from endpoints
        derived_status = link.src_endpoint.status

        # Add edge with all attributes
        G.add_edge(
            src_device,
            dst_device,
            key=link.id,
            name=link.name,
            otn_type=otn_type,
            original_src=src_device,
            original_dst=dst_device,
            src_port=link.src_endpoint.name,
            dst_port=link.dst_endpoint.name,
            status=derived_status,
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
            size = 25
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


def find_paths(src_dev, dst_dev, bitrate=None, dijkstra_only=False):
    """
    Find paths between two devices.
    The function is port-free, allowing the RSA algorithm complete freedom.
    """
    EXTRA_HOPS_ALLOWED = 1
    G = build_graph()

    paths_result = {
        'dijkstra': [],
        'all_paths': []
    }

    # --- 1. Dijkstra Shortest Path (Strictly FREE) ---
    G_free = nx.MultiGraph()
    G_free.add_nodes_from(G.nodes(data=True))

    for u, v, k, d in G.edges(keys=True, data=True):
        otn = d.get('otn_type')
        status = d.get('status')

        if (otn == 'OCH' or otn == 'OMS') and status != 'FULL':
            G_free.add_edge(u, v, key=k, **d)
        elif otn == 'ERROR':
            pass

    G_simple_free = nx.Graph(G_free)

    # try:
    #     avg_hops = nx.average_shortest_path_length(G_simple_free)
    #     logger.info(
    #         f"[Topology] Average shortest path length (hops): {avg_hops:.2f}")
    # except Exception as e:
    #     logger.warning(f"[Topology] Could not calculate average hops: {e}")

    dijkstra_hops = None
    try:
        # == CHOICE STARTS ==
        # NOTE: Generate all shortest paths and make random pick
        # all_shortest_paths = list(nx.all_shortest_paths(
        #     G_simple_free, source=src_dev, target=dst_dev))
        # dijkstra_node_path = random.choice(all_shortest_paths)
        # or
        # NOTE: Generate the most shortest one path
        dijkstra_node_path = nx.shortest_path(
            G_simple_free, source=src_dev, target=dst_dev)
        # == CHOICE ENDS ==
        dijkstra_hops = len(dijkstra_node_path) - 1

        # Log the dijkstra node path
        # logger.info(f"[Dijkstra Path Discovery] Shortest path from {src_dev} to {dst_dev}: "
        #             f"{' -> '.join(dijkstra_node_path)} ({dijkstra_hops} hops)")

        # Expand using G_free, port-free
        d_edge_paths = TopologyHelper.expand_path(
            dijkstra_node_path, G_free)

        # == CHOICE STARTS ==
        # NOTE: Parallel paths from G_free are valid, take the first one
        selected_path = d_edge_paths[:1]

        # or

        # NOTE: Randomly select from valid path expansions
        # selected_path = [random.choice(d_edge_paths)] if d_edge_paths else []
        # == CHOICE ENDS ==

        # if selected_path:
        #     logger.info(f"[Dijkstra Path Discovery] Found {len(d_edge_paths)} valid path expansion(s) "
        #                 f"for dijkstra route {' -> '.join(dijkstra_node_path)}")

        if selected_path and bitrate:
            expanded_dijkstra = selected_path[0]
            dijkstra_rsa = TopologyHelper.perform_rsa(
                expanded_dijkstra, bitrate)
            if dijkstra_rsa:
                expanded_dijkstra['rsa_result'] = dijkstra_rsa

        if selected_path:
            paths_result['dijkstra'] = selected_path
    except nx.NetworkXNoPath:
        logger.info(
            f"[Dijkstra Path Discovery] No shortest path exists from {src_dev} to {dst_dev}")
        pass

    # Bypass alternative path generation if the endpoint only physically needs Dijkstra
    if dijkstra_only:
        return paths_result

    # --- 2. All Simple Paths (Include USED) ---
    G_simple = nx.Graph(G)

    # Determine dynamic cutoff based on Dijkstra shortest path
    if dijkstra_hops is not None:
        dynamic_cutoff = dijkstra_hops + EXTRA_HOPS_ALLOWED
    else:
        try:
            shortest_path_full = nx.shortest_path_length(
                G_simple, source=src_dev, target=dst_dev)
            dynamic_cutoff = shortest_path_full + EXTRA_HOPS_ALLOWED
        except nx.NetworkXNoPath:
            return paths_result

    try:
        simple_node_paths = list(nx.all_simple_paths(
            G_simple, source=src_dev, target=dst_dev, cutoff=dynamic_cutoff))

        logger.info(f"[All Paths Discovery] Found {len(simple_node_paths)} simple paths "
                    f"from {src_dev} to {dst_dev} with cutoff {dynamic_cutoff}")

        valid_all_paths_count = 0
        for i, node_path in enumerate(simple_node_paths):
            first_valid = TopologyHelper.expand_path_first_valid(node_path, G)
            if first_valid:
                paths_result['all_paths'].append(first_valid)
                valid_all_paths_count += 1
            else:
                pass

        logger.info(f"[All Paths Discovery] {valid_all_paths_count}/{len(simple_node_paths)} "
                    f"simple paths have valid link expansions")

    except nx.NetworkXNoPath:
        logger.info(
            f"[All Paths Discovery] No simple paths found from {src_dev} to {dst_dev}")
        pass

    return paths_result


def perform_rsa_for_path(link_ids, bitrate):
    """
    Reconstructs a path object from a list of link IDs and performs RSA.
    Optimized: Queries DB directly instead of building full network graph.
    """
    from models import OpticalLink
    from sqlalchemy.orm import joinedload
    from helpers import TopologyHelper

    if not link_ids:
        return None

    # 1. Fetch links directly from DB with joined endpoints and devices
    links_db = OpticalLink.query.filter(OpticalLink.id.in_(link_ids)).options(
        joinedload(OpticalLink.src_device),
        joinedload(OpticalLink.dst_device),
        joinedload(OpticalLink.src_endpoint),
        joinedload(OpticalLink.dst_endpoint)
    ).all()

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
                'src': link.src_device.name,
                'dst': link.dst_device.name,
                'src_port': link.src_endpoint.name,
                'dst_port': link.dst_endpoint.name,
                'name': link.name,
                'status': link.src_endpoint.status  # Correct source of truth
            })

    if not path_links:
        return None

    path_obj = {'links': path_links}

    # 2. Perform RSA (Port-free logic)
    res = TopologyHelper.perform_rsa(path_obj, bitrate)
    if res:
        res['links'] = path_links
    return res
