import networkx as nx

G = nx.MultiGraph()
G.add_edges_from([
    ('A', 'B', {'id': 1}), ('A', 'B', {'id': 2}), ('A', 'B', {'id': 3}),
    ('B', 'C', {'id': 4}), ('B', 'C', {'id': 5})
])

print("all_shortest_paths:")
print(list(nx.all_shortest_paths(G, 'A', 'C')))

print("\nall_simple_paths:")
print(list(nx.all_simple_paths(G, 'A', 'C')))
