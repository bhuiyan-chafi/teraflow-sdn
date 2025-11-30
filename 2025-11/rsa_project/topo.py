from networkx.classes.function import nodes
import networkx as nx
import matplotlib.pyplot as plt

nodes = ("TPA1", "TPA2", "RDM1", "RDM2","TPA3","TPA4")

def create_topo():
    topo_121 = nx.MultiDiGraph()
    topo_121.add_nodes_from(nodes)
    # TPA1 -> RDM1 -> RDM2 -> TPA3: Tx path
    topo_121.add_edge("TPA1", "RDM1",type="Tx", weight=1, edge_colors="red", tp_port="11001", rdm_port_in="1001")
    topo_121.add_edge("RDM1", "RDM2",type="Tx", weight=1, edge_colors="red", rdm_port_out="3001", rdm_port_in="1001")
    topo_121.add_edge("RDM2", "TPA3",type="Tx", weight=1, edge_colors="red", rdm_port_out="3001", tp_port="11001")
     # TPA3 -> RDM2 -> RDM1 -> TPA1: Rx path
    topo_121.add_edge("TPA3", "RDM2",type="Rx", weight=1, edge_colors="yellow", tp_port="11001", rdm_port_in="4001")
    topo_121.add_edge("RDM2", "RDM1",type="Rx", weight=1, edge_colors="yellow", rdm_port_out="2001", rdm_port_in="4001")
    topo_121.add_edge("RDM1", "TPA1",type="Rx", weight=1, edge_colors="yellow", rdm_port_out="2001", tp_port="11001")

    # TPA2 -> RDM1 -> RDM2 -> TPA4: Tx path
    topo_121.add_edge("TPA2", "RDM1",type="Tx", weight=1, edge_colors="violet", tp_port="2101", rdm_port_in="1002")
    topo_121.add_edge("RDM1", "RDM2",type="Tx", weight=1, edge_colors="violet", rdm_port_out="3002", rdm_port_in="1002")
    topo_121.add_edge("RDM2", "TPA4",type="Tx", weight=1, edge_colors="violet", rdm_port_out="3002", tp_port="2101")
    # TPA4 -> RDM2 -> RDM1 -> TPA2: Rx path
    topo_121.add_edge("TPA4", "RDM2",type="Rx", weight=1, edge_colors="orange", tp_port="2101", rdm_port_in="4002")
    topo_121.add_edge("RDM2", "RDM1",type="Rx", weight=1, edge_colors="orange", rdm_port_out="2002", rdm_port_in="4002")
    topo_121.add_edge("RDM1", "TPA2",type="Rx", weight=1, edge_colors="orange", rdm_port_out="2002", tp_port="2101")

    
        
    
    plt.figure(figsize=(16, 9))
    
    # Define fixed positions for a clean linear layout
    # TPA1 <-> RDM1 <-> RDM2 <-> TPA2
    pos = {
        "TPA1": (0, 0),
        "RDM1": (1, 0),
        "RDM2": (2, 0),
        "TPA3": (3, 0),
        "TPA2": (0, 1),
        "TPA4": (3, 1),
    }
    
    # Draw nodes and labels
    nx.draw_networkx_nodes(topo_121, pos, node_color='lightblue', node_size=500)
    nx.draw_networkx_labels(topo_121, pos, font_size=8, font_weight='bold')
    
    
    # Draw edges with curvature to show multiple links
    ax = plt.gca()
    for u, v, key, data in topo_121.edges(keys=True, data=True):
        # Curve the edge based on its key (index among parallel edges)
        rad = 0.1 + (key * 0.15) 
        # Get color from edge data, default to black if not found
        color = data.get('edge_colors', 'black')
        
        nx.draw_networkx_edges(topo_121, pos, edgelist=[(u, v)], 
                             connectionstyle=f'arc3, rad={rad}', 
                             edge_color=color, arrows=True, width=2)
                             
    plt.title("Topo: 2:1 and 1:1 in between")
    plt.axis('equal') # Hide axis
    plt.tight_layout() # Reduce whitespace

    
    # plt.show() cannot be used in a headless container
    output_path = 'static/topology2_1_and_1_1.png'
    plt.savefig(output_path, bbox_inches='tight') # Ensure nothing is cut off
    print(f"Topology graph saved to {output_path}")
    plt.close() # Close the figure to free memory
    
    return topo_121

if __name__ == "__main__":
    G = create_topo()
    
    # Calculate shortest path from TPA1 to TPA3
    source = "TPA1"
    target = "TPA3"
    try:
        path = nx.dijkstra_path(G, source=source, target=target)
        print(f"Shortest path from {source} to {target}: {path}")
        
        print("\nDetailed Path with Ports:")
        for i in range(len(path) - 1):
            u = path[i]
            v = path[i+1]
            # Get edge data between u and v
            # Since it's a MultiDiGraph, get_edge_data returns a dict of edges keyed by key
            # We assume the first edge (key=0) is the one we want for now, or we filter by type
            edge_data = G.get_edge_data(u, v)
            if edge_data:
                # Just take the first edge found
                data = edge_data[0] 
                
                # Construct a string showing ports
                # Different edges have different port attribute names
                ports_info = []
                if 'tp_port' in data: ports_info.append(f"TP Port: {data['tp_port']}")
                if 'rdm_port_out' in data: ports_info.append(f"RDM_Out: {data['rdm_port_out']}")
                if 'rdm_port_in' in data: ports_info.append(f"RDM_In: {data['rdm_port_in']}")
                
                print(f"{u} --[{', '.join(ports_info)}]--> {v}")
                
    except nx.NetworkXNoPath:
        print(f"No path found from {source} to {target}")
        path1_nodes = set()

    # Calculate shortest path from TPA2 to TPA4
    source2 = "TPA2"
    target2 = "TPA4"
    print(f"\n--- Calculating path from {source2} to {target2} ---")
    try:
        path2 = nx.dijkstra_path(G, source=source2, target=target2)
        print(f"Shortest path from {source2} to {target2}: {path2}")
        
        # Check for common nodes
        # We assume path1 exists from previous block
        if 'path' in locals():
            common_nodes = set(path).intersection(set(path2))
            for node in common_nodes:
                print(f"common node found: {node}")
        
        print("\nDetailed Path with Ports:")
        for i in range(len(path2) - 1):
            u = path2[i]
            v = path2[i+1]
            edge_data = G.get_edge_data(u, v)
            if edge_data:
                data = edge_data[0]
                ports_info = []
                if 'tp_port' in data: ports_info.append(f"TP Port: {data['tp_port']}")
                if 'rdm_port_out' in data: ports_info.append(f"RDM_Out: {data['rdm_port_out']}")
                if 'rdm_port_in' in data: ports_info.append(f"RDM_In: {data['rdm_port_in']}")
                print(f"{u} --[{', '.join(ports_info)}]--> {v}")

    except nx.NetworkXNoPath:
        print(f"No path found from {source2} to {target2}")
