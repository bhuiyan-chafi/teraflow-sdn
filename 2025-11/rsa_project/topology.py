import networkx as nx
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from models import Devices, OpticalLink, Endpoint
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
        
        # Add edge with all attributes
        G.add_edge(
            src_device, 
            dst_device, 
            key=link.id,
            name=link.name,
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
    # 1. Build Directed Graph for Layout (Linearity)
    # This ensures TP1 is treated as a source and TP3 as a destination
    G_layout = build_graph(directed=True)
    
    # 2. Build Undirected Graph for Drawing (Parallel Links)
    G = build_graph(directed=False)

    # Visualization
    plt.figure(figsize=(15, 8))
    
    # --- Layout Calculation using G_layout (Directed) ---
    layers = {}
    # Find sources (in-degree 0) in the DIRECTED graph
    sources = [n for n, d in G_layout.in_degree() if d == 0]
    if not sources:
        sources = [n for n in G_layout.nodes() if 'TP' in n] # Fallback
        
    # Longest path layering using DIRECTED graph
    for node in G_layout.nodes():
        max_dist = 0
        for source in sources:
            try:
                if nx.has_path(G_layout, source, node):
                    dist = nx.shortest_path_length(G_layout, source, node)
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
    logger.info(f"[DEBUG] find_paths called: {src_dev}:{src_port} -> {dst_dev}:{dst_port} (BW: {bandwidth})")
    G = build_graph()
    logger.info(f"[DEBUG] Graph built: {G.number_of_nodes()} nodes, {G.number_of_edges()} edges")
    
    paths_result = {
        'dijkstra': [],
        'all_paths': []
    }
    
    # Helper to convert node path to detailed link path
    def expand_path(node_path):
        valid_edge_paths = []
        
        def backtrack(index, current_edge_path):
            if index == len(node_path) - 1:
                valid_edge_paths.append(list(current_edge_path))
                return

            u = node_path[index]
            v = node_path[index+1]
            
            # Find all edges between u and v
            edges = G[u][v] # dict of key -> attributes
            
            for key, attr in edges.items():
                # Determine ports based on direction
                # If original link was u->v: out_port=src_port, in_port=dst_port
                # If original link was v->u: out_port=dst_port, in_port=src_port
                
                if attr['original_src'] == u and attr['original_dst'] == v:
                    out_port = attr['src_port']
                    in_port = attr['dst_port']
                elif attr['original_src'] == v and attr['original_dst'] == u:
                    out_port = attr['dst_port']
                    in_port = attr['src_port']
                else:
                    # Should not happen if logic is correct
                    continue

                # Check constraints
                # 1. First hop: u is source. out_port must match src_port
                if index == 0 and src_port and out_port != src_port:
                    continue
                
                # 2. Last hop: v is destination. in_port must match dst_port
                if index == len(node_path) - 2 and dst_port and in_port != dst_port:
                    continue
                    
                # Add to path
                current_edge_path.append({
                    'src': u,
                    'dst': v,
                    'src_port': out_port,
                    'dst_port': in_port,
                    'name': attr['name']
                })
                
                backtrack(index + 1, current_edge_path)
                current_edge_path.pop()

        backtrack(0, [])
        return valid_edge_paths

    # Create a simple Graph (Undirected) for finding unique node sequences
    G_simple = nx.Graph(G)
    logger.info(f"[DEBUG] Simple Graph created for routing: {G_simple.number_of_nodes()} nodes, {G_simple.number_of_edges()} edges")

    # 1. Dijkstra Shortest Path
    try:
        logger.info(f"[DEBUG] Searching for shortest path (Dijkstra) on simple graph...")
        dijkstra_node_path = nx.shortest_path(G_simple, source=src_dev, target=dst_dev)
        logger.info(f"[DEBUG] Dijkstra node path found: {dijkstra_node_path}")
        
        # Expand using the original MultiGraph G
        d_edge_paths = expand_path(dijkstra_node_path)
        logger.info(f"[DEBUG] Expanded Dijkstra path to {len(d_edge_paths)} valid physical paths.")
        paths_result['dijkstra'].extend(d_edge_paths)
    except nx.NetworkXNoPath:
        logger.info(f"[DEBUG] No Dijkstra path found.")
        pass

    # 2. All Simple Paths
    try:
        logger.info(f"[DEBUG] Searching for all simple paths (cutoff=10) on simple graph...")
        simple_node_paths = list(nx.all_simple_paths(G_simple, source=src_dev, target=dst_dev, cutoff=10))
        logger.info(f"[DEBUG] Found {len(simple_node_paths)} unique node sequences (routes).")
        
        total_edge_paths = 0
        for i, node_path in enumerate(simple_node_paths):
            logger.info(f"[DEBUG] Expanding Route {i+1}: {node_path}")
            edge_paths = expand_path(node_path)
            count = len(edge_paths)
            logger.info(f"[DEBUG] Route {i+1} expanded to {count} physical paths.")
            paths_result['all_paths'].extend(edge_paths)
            total_edge_paths += count
            
        logger.info(f"[DEBUG] Total physical paths found: {total_edge_paths}")
    except nx.NetworkXNoPath:
        logger.info(f"[DEBUG] No simple paths found.")
        pass
        
    return paths_result
