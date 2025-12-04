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
    
    # Helper to convert node path to detailed link path
    def expand_path(node_path, graph_to_use):
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
                
            edges = graph_to_use[u][v] # dict of key -> attributes
            
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
                    'src': u,
                    'dst': v,
                    'src_port': out_port,
                    'dst_port': in_port,
                    'name': attr['name'],
                    'status': attr['status'],
                    'c_slot': attr['c_slot'] # Include c_slot for RSA
                })
                
                backtrack(index + 1, current_edge_path)
                current_edge_path.pop()

        backtrack(0, [])
        return valid_edge_paths

    # --- RSA Computation Function ---
    import math
    
    def perform_rsa(path_obj, bandwidth):
        if not bandwidth:
            return None
            
        FLEX_GRID = 12.5
        num_slots = math.ceil(float(bandwidth) / FLEX_GRID)
        logger.info(f"[RSA] Starting RSA for bandwidth {bandwidth}Gbps. Required slots: {num_slots} (Bitmap: {'1' * int(num_slots)})")
        # Initialize bitmap with the first link's c_slot
        if not path_obj['links']:
            logger.warning("[RSA] Path has no links!")
            return None
            
        first_link = path_obj['links'][0]
        path_bitmap = int(first_link['c_slot'])
        
        # User requested to derive TOTAL_SLOTS from the bitmap length
        TOTAL_SLOTS = path_bitmap.bit_length()
        
        logger.info(f"[RSA] Initial Path Bitmap (from {first_link['name']}): {path_bitmap:b} (Length: {TOTAL_SLOTS})")
        
        # 1. Calculate Intersection (start from second link)
        for i, link in enumerate(path_obj['links'][1:], start=1):
            c_slot_val = int(link['c_slot'])
            path_bitmap &= c_slot_val
            logger.info(f"[RSA] Link {i+1} ({link['name']}) Bitmap: {c_slot_val:b} -> Intersection: {path_bitmap:b}")
            
        # 2. Find Contiguous Slots (First Fit from LSB)
        start_bit = -1
        current_run = 0
        
        # Iterate from bit 0 (LSB) to 34 (MSB)
        for i in range(TOTAL_SLOTS):
            # Check if bit i is set (1)
            is_free = (path_bitmap >> i) & 1
            
            if is_free:
                current_run += 1
                if current_run == num_slots:
                    # Found a run ending at i
                    # It started at i - num_slots + 1
                    start_bit = i - num_slots + 1
                    logger.info(f"[RSA] Found {num_slots} contiguous slots starting at bit {start_bit} (LSB)")
                    break
            else:
                current_run = 0
                
        if start_bit != -1:
            # Found slots!
            
            # Create "Required Slots" bitmap (N of 1s at the correct position)
            # Shift 1s to the start_bit position
            mask = ((1 << num_slots) - 1) << start_bit
            
            # Create Final Bitmap (Intersection with slots taken -> 0)
            final_bitmap_val = path_bitmap & ~mask
            
            # Format as strings (dynamic length)
            common_bitmap_str = f"{path_bitmap:0{TOTAL_SLOTS}b}"
            required_slots_str = f"{mask:0{TOTAL_SLOTS}b}"
            final_bitmap_str = f"{final_bitmap_val:0{TOTAL_SLOTS}b}"
            
            logger.info(f"[RSA] Success! Final Bitmap: {final_bitmap_str}")
            
            return {
                'success': True,
                'num_slots': num_slots,
                'common_bitmap': common_bitmap_str,
                'required_slots': required_slots_str,
                'final_bitmap': final_bitmap_str
            }
        else:
            logger.warning(f"[RSA] Failed. No contiguous slots found.")
            return {
                'success': False,
                'num_slots': num_slots,
                'common_bitmap': f"{path_bitmap:0{TOTAL_SLOTS}b}",
                'error': "No contiguous slots found"
            }

    # --- 1. Dijkstra Shortest Path (Strictly FREE) ---
    # Create G_free containing only FREE edges
    G_free = nx.MultiGraph()
    G_free.add_nodes_from(G.nodes(data=True))
    for u, v, k, d in G.edges(keys=True, data=True):
        if d.get('status') == 'FREE':
            G_free.add_edge(u, v, key=k, **d)
            
    G_simple_free = nx.Graph(G_free)
    logger.info(f"[DEBUG] Simple Graph (FREE only) created: {G_simple_free.number_of_nodes()} nodes, {G_simple_free.number_of_edges()} edges")

    try:
        logger.info(f"[DEBUG] Searching for shortest path (Dijkstra) on FREE graph...")
        dijkstra_node_path = nx.shortest_path(G_simple_free, source=src_dev, target=dst_dev)
        logger.info(f"[DEBUG] Dijkstra node path found: {dijkstra_node_path}")
        
        # Expand using G_free to ensure we only pick FREE links
        d_edge_paths = expand_path(dijkstra_node_path, G_free)
        logger.info(f"[DEBUG] Expanded Dijkstra path to {len(d_edge_paths)} valid physical paths.")
        
        # User requested ONLY ONE path for Dijkstra, even if parallel links exist
        selected_path = d_edge_paths[:1]
        
        # Perform RSA if bandwidth is provided
        if selected_path and bandwidth:
            rsa_res = perform_rsa(selected_path[0], bandwidth)
            if rsa_res:
                selected_path[0]['rsa_result'] = rsa_res
                
        paths_result['dijkstra'].extend(selected_path)
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
            edge_paths = expand_path(node_path, G)
            count = len(edge_paths)
            logger.info(f"[DEBUG] Route {i+1} expanded to {count} physical paths.")
            paths_result['all_paths'].extend(edge_paths)
            total_edge_paths += count
            
        logger.info(f"[DEBUG] Total physical paths found: {total_edge_paths}")
    except nx.NetworkXNoPath:
        logger.info(f"[DEBUG] No simple paths found.")
        pass
        
    return paths_result
