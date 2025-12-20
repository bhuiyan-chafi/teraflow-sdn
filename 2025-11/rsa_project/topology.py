import networkx as nx
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from models import Devices, OpticalLink, Endpoint
from helpers import TopologyHelper
import os

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

    # Fetch all optical links (edges)
    links = OpticalLink.query.all()
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
            logger.error(f"[Graph Build] OTN TYPE MISMATCH on link {link.name}: {src_otn} vs {dst_otn}")

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
            c_slot=link.c_slot,
            l_slot=link.l_slot,
            status=link.status,
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
        sources = [n for n in G.nodes() if 'TP' in n] # Fallback
        
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

    colors = ['r', 'g', 'b', 'c', 'm', 'y', 'orange', 'purple', 'brown']

    # Draw single edge per pair
    for idx, (pair, edges) in enumerate(edge_groups.items()):
        u, v = pair
        count = len(edges)
        
        # Pick a color based on index
        color = colors[idx % len(colors)]
        
        # Draw one thick line
        nx.draw_networkx_edges(
            G, pos, 
            edgelist=[(u, v)], 
            edge_color=color,
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

import logging

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def find_paths(src_dev, src_port, dst_dev, dst_port, bandwidth=None):
    HIGHEST_HOP = 10
    logger.info(f"[DEBUG] find_paths called: {src_dev}:{src_port} -> {dst_dev}:{dst_port} (BW: {bandwidth})")
    G = build_graph()
    logger.info(f"[DEBUG] Graph built: {G.number_of_nodes()} nodes, {G.number_of_edges()} edges")
    
    paths_result = {
        'dijkstra': [],
        'all_paths': []
    }
    
    # --- 1. Dijkstra Shortest Path (Strictly FREE) ---
    # Create G_free containing only FREE edges
    G_free = nx.MultiGraph()
    G_free.add_nodes_from(G.nodes(data=True))
    # Dijkstra logic: 
    # - OCH links MUST be FREE (as they cannot be shared)
    # - OMS links can be shared UNLESS they are FULL
    for u, v, k, d in G.edges(keys=True, data=True):
        otn = d.get('otn_type')
        status = d.get('status')
        
        if otn == 'OCH' and status == 'FREE':
            G_free.add_edge(u, v, key=k, **d)
        elif otn == 'OMS' and status != 'FULL':
            G_free.add_edge(u, v, key=k, **d)
        elif otn == 'ERROR':
            logger.warning(f"[Pathfinder] Skipping malformed link {d.get('name')} (ERROR type)")
            
    logger.info(f"[DEBUG] Filtered Graph (FREE links only): {G_free.number_of_nodes()} nodes, {G_free.number_of_edges()} edges")

    G_simple_free = nx.Graph(G_free)
    logger.info(f"[DEBUG] Simple Graph (UNIQUE connected pairs with FREE links): {G_simple_free.number_of_nodes()} nodes, {G_simple_free.number_of_edges()} edges")

    try:
        logger.info(f"[DEBUG] Searching for shortest path (Dijkstra) on FREE graph...")
        dijkstra_node_path = nx.shortest_path(G_simple_free, source=src_dev, target=dst_dev)
        logger.info(f"[DEBUG] Dijkstra node path found: {dijkstra_node_path}")
        
        # Expand using G_free to ensure we only pick FREE links
        d_edge_paths = TopologyHelper.expand_path(dijkstra_node_path, G_free, src_port, dst_port)
        logger.info(f"[DEBUG] Expanded Dijkstra path to {len(d_edge_paths)} valid physical paths.")
        
        # User requested ONLY ONE path for Dijkstra, even if parallel links exist
        selected_path = d_edge_paths[:1]
        
        if selected_path and bandwidth:
            expanded_dijkstra = selected_path[0]
            dijkstra_rsa = TopologyHelper.perform_rsa(expanded_dijkstra, bandwidth, G)
            if dijkstra_rsa:
                expanded_dijkstra['rsa_result'] = dijkstra_rsa
        
        if selected_path:
            paths_result['dijkstra'] = selected_path
    except nx.NetworkXNoPath:
        logger.info(f"[DEBUG] No Dijkstra path found on FREE graph.")
        pass

    # --- 2. All Simple Paths (Include USED) ---
    # Use original G and G_simple
    G_simple = nx.Graph(G)
    logger.info(f"[DEBUG] Simple Graph (All) created: {G_simple.number_of_nodes()} nodes, {G_simple.number_of_edges()} edges")
    
    try:
        logger.info(f"[DEBUG] Searching for all simple paths (HIGHEST_HOP={HIGHEST_HOP}) on full graph...")
        simple_node_paths = list(nx.all_simple_paths(G_simple, source=src_dev, target=dst_dev, cutoff=HIGHEST_HOP))
        logger.info(f"[DEBUG] Found {len(simple_node_paths)} unique node sequences (routes).")
        
        total_edge_paths = 0
        for i, node_path in enumerate(simple_node_paths):
            logger.info(f"[DEBUG] Expanding Route {i+1}: {node_path}")
            # Expand using full G to include USED links
            edge_paths = TopologyHelper.expand_path(node_path, G, src_port, dst_port)
            count = len(edge_paths)
            logger.info(f"[DEBUG] Route {i+1} expanded to {count} physical paths.")
            paths_result['all_paths'].extend(edge_paths)
            total_edge_paths += count
            
        logger.info(f"[DEBUG] Total physical paths found: {total_edge_paths}")
    except nx.NetworkXNoPath:
        logger.info(f"[DEBUG] No simple paths found.")
        pass
        
    return paths_result

def perform_rsa_for_path(link_ids, bandwidth):
    """
    Reconstructs a path object from a list of link IDs and performs RSA.
    """
    if not link_ids:
        return None
    
    G = build_graph()
    path_links = []
    
    # 1. Reconstruct path object using precise IDs
    for link_id in link_ids:
        found = False
        for u, v, k, d in G.edges(keys=True, data=True):
            if str(k) == str(link_id):
                path_links.append({
                    'id': str(k),
                    'src': u,
                    'dst': v,
                    'src_port': d.get('src_port'),
                    'dst_port': d.get('dst_port'),
                    'name': d.get('name'),
                    'status': d.get('status'),
                    'c_slot': d.get('c_slot')
                })
                found = True
                break
        if not found:
            logger.warning(f"[RSA Path] Link {link_id} not found in graph!")
            
    if not path_links:
        return None
        
    path_obj = {'links': path_links}
    
    # 2. Perform RSA
    from helpers import TopologyHelper
    res = TopologyHelper.perform_rsa(path_obj, bandwidth, G)
    if res:
        res['links'] = path_links
    return res
