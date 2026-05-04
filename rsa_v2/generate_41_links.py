import math
import random

cities = {
    'RDMparis': (2.3522, 48.8566),
    'RDMlondon': (-0.1276, 51.5074),
    'RDMberlin': (13.4050, 52.5200),
    'RDMmadrid': (-3.7038, 40.4168),
    'RDMbarcelona': (2.1686, 41.3874),
    'RDMnaples': (14.2681, 40.8518),
    'RDMmilan': (9.1900, 45.4642),
    'RDMathens': (23.7275, 37.9838),
    'RDMvienna': (16.3738, 48.2082),
    'RDMwarsaw': (21.0122, 52.2297),
    'RDMmunich': (11.5820, 48.1351),
    'RDMlyon': (4.8357, 45.7640),
    'RDMturin': (7.6869, 45.0703),
    'RDMkatowice': (19.0238, 50.2584),
    'RDMtimisoara': (21.2272, 45.7489),
    'RDMtampere': (23.7608, 61.4978),
    'RDMcork': (-8.4756, 51.8985),
    'RDMleeds': (-1.5491, 53.7997),
    'RDMsofia': (23.3219, 42.6977),
    'RDMzagreb': (15.9819, 45.8150),
    'RDMprague': (14.4378, 50.0755),
    'RDMcopenhagen': (12.5683, 55.6761),
    'RDMtallinn': (24.7535, 59.4370),
    'RDMhelsinki': (24.9384, 60.1695),
    'RDMstrasbourg': (7.7521, 48.5734),
    'RDMrome': (12.4964, 41.9028),
    'RDMvalencia': (-0.3763, 39.4699),
    'RDMbrno': (16.6068, 49.1951)
}

def distance(c1, c2):
    x1, y1 = cities[c1]
    x2, y2 = cities[c2]
    # Simple Euclidean is fine for this small range, but let's scale y slightly for aspect ratio
    return math.sqrt((x1-x2)**2 + ((y1-y2)*1.5)**2)

nodes = list(cities.keys())
links = set()

# First connect nearest neighbors to ensure connectedness (MST-like approach)
connected = set([nodes[0]])
unconnected = set(nodes[1:])
while unconnected:
    best_dist = float('inf')
    best_edge = None
    for c in connected:
        for u in unconnected:
            d = distance(c, u)
            if d < best_dist:
                best_dist = d
                best_edge = (c, u)
    c, u = best_edge
    connected.add(u)
    unconnected.remove(u)
    edge = tuple(sorted([c, u]))
    links.add(edge)

# We have 27 links now. We need 41 total, so we need 14 more.
# Add links between close nodes to form a mesh, prioritizing center nodes.
center_lon, center_lat = 9.0, 48.0 # roughly around Switzerland/Germany
def dist_to_center(c):
    return math.sqrt((cities[c][0]-center_lon)**2 + ((cities[c][1]-center_lat)*1.5)**2)

# Score pairs by distance between them + distance to center
potential_links = []
for i in range(len(nodes)):
    for j in range(i+1, len(nodes)):
        edge = tuple(sorted([nodes[i], nodes[j]]))
        if edge not in links:
            d = distance(nodes[i], nodes[j])
            c_dist = dist_to_center(nodes[i]) + dist_to_center(nodes[j])
            score = d * 1.0 + c_dist * 0.3
            potential_links.append((score, edge))

potential_links.sort()
for i in range(14):
    links.add(potential_links[i][1])

print(f"Generated {len(links)} links")

with open('sql/paneu_topo/optical_links.sql', 'w') as f:
    f.write("-- Pan-EU Topology: Optical Links (Single Links between RDMs)\n")
    f.write("-- 28 Nodes, 41 Links Mesh Network\n\n")
    
    f.write("INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES\n")
    
    # We will use endpoint 2001, 2002, etc. for the devices.
    # Keep track of used endpoints per device.
    used_endpoints = {n: 0 for n in nodes}
    
    link_idx = 1
    total_links = len(links) * 2 # Bidirectional in terms of TeraFlow? Wait, the original SQL is unidirectional?
    # Actually, RSA usually assumes unidirectional links defined in pairs, or bidirectional link definition.
    # In the original file it was: INSERT INTO optical_links ... 
    # TPathens->RDMathens_1 etc.
    # Let's see if we need to do RDM1->RDM2 and RDM2->RDM1. TeraFlow SDN usually models links as bidirectional natively or as two unidirectional links.
    # The user said "single links. Which means use one endpoint of a ROADM to another ROADM for one connection."
    # A single optical link usually has src and dst. If we define A->B, do we also need B->A?
    # Let's generate A->B.
    pass

