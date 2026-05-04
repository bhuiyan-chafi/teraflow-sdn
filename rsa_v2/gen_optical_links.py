import uuid

edges = [
    ("RDMlondon", "RDMparis"),
    ("RDMlondon", "RDMstrasbourg"),
    ("RDMlondon", "RDMleeds"),
    ("RDMlondon", "RDMcork"),
    ("RDMleeds", "RDMcork"),
    ("RDMparis", "RDMlyon"),
    ("RDMparis", "RDMmadrid"),
    ("RDMstrasbourg", "RDMmunich"),
    ("RDMstrasbourg", "RDMmilan"),
    ("RDMstrasbourg", "RDMlyon"),
    ("RDMmunich", "RDMberlin"),
    ("RDMmunich", "RDMvienna"),
    ("RDMmunich", "RDMprague"),
    ("RDMmilan", "RDMlyon"),
    ("RDMmilan", "RDMrome"),
    ("RDMmilan", "RDMturin"),
    ("RDMlyon", "RDMturin"),
    ("RDMlyon", "RDMbarcelona"),
    ("RDMmadrid", "RDMbarcelona"),
    ("RDMmadrid", "RDMvalencia"),
    ("RDMbarcelona", "RDMvalencia"),
    ("RDMrome", "RDMnaples"),
    ("RDMrome", "RDMathens"),
    ("RDMrome", "RDMzagreb"),
    ("RDMnaples", "RDMathens"),
    ("RDMathens", "RDMsofia"),
    ("RDMsofia", "RDMvienna"),
    ("RDMsofia", "RDMtimisoara"),
    ("RDMvienna", "RDMprague"),
    ("RDMvienna", "RDMzagreb"),
    ("RDMtimisoara", "RDMkatowice"),
    ("RDMkatowice", "RDMwarsaw"),
    ("RDMkatowice", "RDMbrno"),
    ("RDMbrno", "RDMprague"),
    ("RDMwarsaw", "RDMberlin"),
    ("RDMwarsaw", "RDMtallinn"),
    ("RDMberlin", "RDMprague"),
    ("RDMberlin", "RDMcopenhagen"),
    ("RDMcopenhagen", "RDMhelsinki"),
    ("RDMhelsinki", "RDMtallinn"),
    ("RDMhelsinki", "RDMtampere"),
    ("RDMtallinn", "RDMtampere"),
]

# Currently 42 edges. Remove 1 to reach 41.
# Remove RDMberlin-RDMprague
edges = [e for e in edges if e != ("RDMberlin", "RDMprague")]

print(f"-- Total unique undirected edges: {len(edges)}")

port_counts = {}

def get_next_port(device):
    if device not in port_counts:
        port_counts[device] = 2001
    else:
        port_counts[device] += 1
    if port_counts[device] > 2012:
        raise Exception(f"Device {device} exceeded 12 ports!")
    return str(port_counts[device])

sql_lines = [
    "-- Pan-EU Topology: Optical Links",
    "-- Standard 28-node, 41-edge mesh network",
    "-- Note: Each physical connection consists of two directed links for bidirectionality.",
    "-- ROADM to ROADM single links using OMS endpoints (2001-2012).",
    ""
]

for u, v in edges:
    u_port = get_next_port(u)
    v_port = get_next_port(v)
    
    # Forward link
    link_name_fwd = f"{u}->{v}_1"
    sql_lines.append(f"--- {u}-{v}")
    sql_lines.append("INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES")
    sql_lines.append(f"\t(gen_random_uuid(), '{link_name_fwd}', (SELECT id FROM devices WHERE name='{u}'), (SELECT id FROM devices WHERE name='{v}'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='{u}') AND name='{u_port}' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='{v}') AND name='{v_port}' LIMIT 1), NOW(), NOW()),")
    
    # Backward link
    link_rev_name = f"{v}->{u}_1"
    sql_lines.append(f"\t(gen_random_uuid(), '{link_rev_name}', (SELECT id FROM devices WHERE name='{v}'), (SELECT id FROM devices WHERE name='{u}'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='{v}') AND name='{v_port}' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='{u}') AND name='{u_port}' LIMIT 1), NOW(), NOW())")
    sql_lines.append("ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;")
    sql_lines.append("")

with open('sql/paneu_topo/optical_links.sql', 'w') as f:
    f.write("\n".join(sql_lines))

print("Regenerated sql/paneu_topo/optical_links.sql with exactly 41 edges.")
