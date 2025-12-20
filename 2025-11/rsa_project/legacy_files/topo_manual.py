from networkx.classes.function import nodes
import networkx as nx
import matplotlib.pyplot as plt

nodes = ("TPA1", "TPA2", "RDM1", "RDM2","TPA3","TPA4")
nodes_parallel = ("TPA1", "RDM1", "RDM2","TPA2")

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

def create_topo_parallel():
    # we can comment the rx paths because the same frequency will be used for both paths, but they will complicate the path computation
    topo_parallel = nx.MultiDiGraph()
    topo_parallel.add_nodes_from(nodes_parallel)
    # TPA1 -> RDM1 -> RDM2 -> TPA2: Tx path : 1101
    topo_parallel.add_edge("TPA1", "RDM1",type="Tx", weight=1, edge_colors="red", tp_port="11001", rdm_port_in="1001")
    topo_parallel.add_edge("RDM1", "RDM2",type="Tx", weight=1, edge_colors="red", rdm_port_out="3001", rdm_port_in="1001")
    topo_parallel.add_edge("RDM2", "TPA2",type="Tx", weight=1, edge_colors="red", rdm_port_out="3001", tp_port="11001")
    # TPA2 -> RDM2 -> RDM1 -> TPA1: Rx path : 1101
    # topo_parallel.add_edge("TPA2", "RDM2",type="Rx", weight=1, edge_colors="yellow", tp_port="11001", rdm_port_in="4001")
    # topo_parallel.add_edge("RDM2", "RDM1",type="Rx", weight=1, edge_colors="yellow", rdm_port_out="2001", rdm_port_in="4001")
    # topo_parallel.add_edge("RDM1", "TPA1",type="Rx", weight=1, edge_colors="yellow", rdm_port_out="2001", tp_port="11001")
    
    # parallel path 1
    # TPA1 -> RDM1 -> RDM2 -> TPA2: Tx path : 1102
    topo_parallel.add_edge("TPA1", "RDM1",type="Tx", weight=1, edge_colors="orange", tp_port="1102", rdm_port_in="1002")
    topo_parallel.add_edge("RDM1", "RDM2",type="Tx", weight=1, edge_colors="orange", rdm_port_out="3002", rdm_port_in="1002")
    topo_parallel.add_edge("RDM2", "TPA2",type="Tx", weight=1, edge_colors="orange", rdm_port_out="3003", tp_port="1103")
    # TPA2 -> RDM2 -> RDM1 -> TPA1: Rx path : 1102
    # topo_parallel.add_edge("TPA2", "RDM2",type="Rx", weight=1, edge_colors="green", tp_port="1103", rdm_port_in="4003")
    # topo_parallel.add_edge("RDM2", "RDM1",type="Rx", weight=1, edge_colors="green", rdm_port_out="2003", rdm_port_in="4003")
    # topo_parallel.add_edge("RDM1", "TPA1",type="Rx", weight=1, edge_colors="green", rdm_port_out="2003", tp_port="1103")

   # parallel path 2
    # TPA1 -> RDM1 -> RDM2 -> TPA2: Tx path : 1103
    topo_parallel.add_edge("TPA1", "RDM1",type="Tx", weight=1, edge_colors="blue", tp_port="1103", rdm_port_in="1003")
    topo_parallel.add_edge("RDM1", "RDM2",type="Tx", weight=1, edge_colors="blue", rdm_port_out="3003", rdm_port_in="1003")
    topo_parallel.add_edge("RDM2", "TPA2",type="Tx", weight=1, edge_colors="blue", rdm_port_out="3004", tp_port="1104")
    # TPA2 -> RDM2 -> RDM1 -> TPA1: Rx path : 1103
    # topo_parallel.add_edge("TPA2", "RDM2",type="Rx", weight=1, edge_colors="cyan", tp_port="1104", rdm_port_in="4004")
    # topo_parallel.add_edge("RDM2", "RDM1",type="Rx", weight=1, edge_colors="cyan", rdm_port_out="2004", rdm_port_in="4004")
    # topo_parallel.add_edge("RDM1", "TPA1",type="Rx", weight=1, edge_colors="cyan", rdm_port_out="2004", tp_port="1104")

    plt.figure(figsize=(16, 9))
    # Define fixed positions for a clean linear layout
    # TPA1 <-> RDM1 <-> RDM2 <-> TPA2
    pos = {
        "TPA1": (0, 0),
        "RDM1": (1, 0),
        "RDM2": (2, 0),
        "TPA2": (3, 0),
    }
    # draw nodes and labels
    nx.draw_networkx_nodes(topo_parallel, pos, node_color='lightblue', node_size=500)
    nx.draw_networkx_labels(topo_parallel, pos, font_size=8, font_weight='bold')
    
    # draw edges with curvature to show multiple links
    ax = plt.gca()
    for u, v, key, data in topo_parallel.edges(keys=True, data=True):
        # curve the edge based on its key (index among parallel edges)
        rad = 0.1 + (key * 0.15) 
        # get color from edge data, default to black if not found
        color = data.get('edge_colors', 'black')
        
        nx.draw_networkx_edges(topo_parallel, pos, edgelist=[(u, v)], 
                             connectionstyle=f'arc3, rad={rad}', 
                             edge_color=color, arrows=True, width=2)
    
    plt.title("Topo: Parallel")
    plt.axis('equal') # hide axis
    plt.tight_layout() # reduce whitespace
    
    # plt.show() cannot be used in a headless container
    output_path = 'static/topology_parallel.png'
    plt.savefig(output_path, bbox_inches='tight') # ensure nothing is cut off
    print(f"Topology graph saved to {output_path}")
    plt.close() # close the figure to free memory
    
    return topo_parallel

def create_topo_parallel_narrow():
    topo_parallel_narrow = nx.MultiDiGraph()
    topo_parallel_narrow.add_nodes_from(nodes_parallel)
    
    # TPA1 -> RDM1 (3 links)
    topo_parallel_narrow.add_edge("TPA1", "RDM1", type="Tx", weight=1, edge_colors="red", tp_port="11001", rdm_port_in="1001")
    topo_parallel_narrow.add_edge("TPA1", "RDM1", type="Tx", weight=1, edge_colors="orange", tp_port="1102", rdm_port_in="1002")
    topo_parallel_narrow.add_edge("TPA1", "RDM1", type="Tx", weight=1, edge_colors="blue", tp_port="1103", rdm_port_in="1003")

    # RDM1 -> RDM2 (1 link - Common Bottleneck)
    topo_parallel_narrow.add_edge("RDM1", "RDM2", type="Tx", weight=1, edge_colors="black", rdm_port_out="3001", rdm_port_in="1001")

    # RDM2 -> TPA2 (3 links)
    topo_parallel_narrow.add_edge("RDM2", "TPA2", type="Tx", weight=1, edge_colors="red", rdm_port_out="3001", tp_port="11001")
    topo_parallel_narrow.add_edge("RDM2", "TPA2", type="Tx", weight=1, edge_colors="orange", rdm_port_out="3003", tp_port="1103")
    topo_parallel_narrow.add_edge("RDM2", "TPA2", type="Tx", weight=1, edge_colors="blue", rdm_port_out="3004", tp_port="1104")

    plt.figure(figsize=(16, 9))
    pos = {
        "TPA1": (0, 0),
        "RDM1": (1, 0),
        "RDM2": (2, 0),
        "TPA2": (3, 0),
    }
    nx.draw_networkx_nodes(topo_parallel_narrow, pos, node_color='lightgreen', node_size=500)
    nx.draw_networkx_labels(topo_parallel_narrow, pos, font_size=8, font_weight='bold')
    
    for u, v, key, data in topo_parallel_narrow.edges(keys=True, data=True):
        rad = 0.1 + (key * 0.15) 
        color = data.get('edge_colors', 'black')
        nx.draw_networkx_edges(topo_parallel_narrow, pos, edgelist=[(u, v)], 
                             connectionstyle=f'arc3, rad={rad}', 
                             edge_color=color, arrows=True, width=2)
    
    plt.title("Topo: Narrow Parallel (3-1-3)")
    plt.axis('equal')
    plt.tight_layout()
    
    output_path = 'static/topology_parallel_narrow.png'
    plt.savefig(output_path, bbox_inches='tight')
    print(f"Topology graph saved to {output_path}")
    plt.close()
    
    return topo_parallel_narrow

if __name__ == "__main__":
    G = create_topo()
    # G_parallel = create_topo_parallel()
    G_narrow = create_topo_parallel_narrow()
    
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
            edge_data = G.get_edge_data(u, v)
            if edge_data:
                data = edge_data[0] 
                ports_info = []
                if 'tp_port' in data: ports_info.append(f"TP Port: {data['tp_port']}")
                if 'rdm_port_out' in data: ports_info.append(f"RDM_Out: {data['rdm_port_out']}")
                if 'rdm_port_in' in data: ports_info.append(f"RDM_In: {data['rdm_port_in']}")
                print(f"{u} --[{', '.join(ports_info)}]--> {v}")
                
    except nx.NetworkXNoPath:
        print(f"No path found from {source} to {target}")

    # Calculate shortest path from TPA2 to TPA4
    source2 = "TPA2"
    target2 = "TPA4"
    print(f"\n--- Calculating path from {source2} to {target2} ---")
    try:
        path2 = nx.dijkstra_path(G, source=source2, target=target2)
        print(f"Shortest path from {source2} to {target2}: {path2}")
        
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

    # Calculate ALL paths from TPA1 to TPA2 in Narrow Topology
    source3 = "TPA1"
    target3 = "TPA2"
    print(f"\n--- Calculating ALL paths from {source3} to {target3} (Narrow Topology) ---")
    try:
        # Find all simple paths
        paths = list(nx.all_simple_paths(G_narrow, source=source3, target=target3))
        print(f"Found {len(paths)} paths from {source3} to {target3}:")
        
        for idx, path3 in enumerate(paths):
            print(f"\nPath {idx + 1}: {path3}")
            
            print("  Detailed Path with Ports:")
            for i in range(len(path3) - 1):
                u = path3[i]
                v = path3[i+1]
                # Get all edges between u and v
                edge_data_dict = G_narrow.get_edge_data(u, v)
                
                if edge_data_dict:
                    for key, data in edge_data_dict.items():
                        ports_info = []
                        if 'tp_port' in data: ports_info.append(f"TP Port: {data['tp_port']}")
                        if 'rdm_port_out' in data: ports_info.append(f"RDM_Out: {data['rdm_port_out']}")
                        if 'rdm_port_in' in data: ports_info.append(f"RDM_In: {data['rdm_port_in']}")
                        print(f"    {u} --[{', '.join(ports_info)}]--> {v} (Key: {key})")

    except nx.NetworkXNoPath:
        print(f"No path found from {source3} to {target3}")