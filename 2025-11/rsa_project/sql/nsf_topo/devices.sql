-- NSF Topology Devices (only devices used in optical_links.sql)

INSERT INTO devices (id, name, type, vendor, model, created_at, updated_at) VALUES
(gen_random_uuid(), 'TPcalifornia', 'optical-transponder', 'Cisco', 'NCS1004', NOW(), NOW()),
(gen_random_uuid(), 'TPillinois', 'optical-transponder', 'Cisco', 'NCS1004', NOW(), NOW()),
(gen_random_uuid(), 'TPmissouri', 'optical-transponder', 'Cisco', 'NCS1004', NOW(), NOW()),
(gen_random_uuid(), 'TPnewyork', 'optical-transponder', 'Cisco', 'NCS1004', NOW(), NOW()),
(gen_random_uuid(), 'TPtexas', 'optical-transponder', 'Cisco', 'NCS1004', NOW(), NOW()),
(gen_random_uuid(), 'RDMarizona', 'optical-roadm', 'Ciena', '6500', NOW(), NOW()),
(gen_random_uuid(), 'RDMcalifornia', 'optical-roadm', 'Ciena', '6500', NOW(), NOW()),
(gen_random_uuid(), 'RDMcolorado', 'optical-roadm', 'Ciena', '6500', NOW(), NOW()),
(gen_random_uuid(), 'RDMflorida', 'optical-roadm', 'Ciena', '6500', NOW(), NOW()),
(gen_random_uuid(), 'RDMgeorgia', 'optical-roadm', 'Ciena', '6500', NOW(), NOW()),
(gen_random_uuid(), 'RDMillinois', 'optical-roadm', 'Ciena', '6500', NOW(), NOW()),
(gen_random_uuid(), 'RDMindiana', 'optical-roadm', 'Ciena', '6500', NOW(), NOW()),
(gen_random_uuid(), 'RDMmaryland', 'optical-roadm', 'Ciena', '6500', NOW(), NOW()),
(gen_random_uuid(), 'RDMmassachusetts', 'optical-roadm', 'Ciena', '6500', NOW(), NOW()),
(gen_random_uuid(), 'RDMmichigan', 'optical-roadm', 'Ciena', '6500', NOW(), NOW()),
(gen_random_uuid(), 'RDMmissouri', 'optical-roadm', 'Ciena', '6500', NOW(), NOW()),
(gen_random_uuid(), 'RDMnewyork', 'optical-roadm', 'Ciena', '6500', NOW(), NOW()),
(gen_random_uuid(), 'RDMohio', 'optical-roadm', 'Ciena', '6500', NOW(), NOW()),
(gen_random_uuid(), 'RDMpennsylvania', 'optical-roadm', 'Ciena', '6500', NOW(), NOW()),
(gen_random_uuid(), 'RDMtennessee', 'optical-roadm', 'Ciena', '6500', NOW(), NOW()),
(gen_random_uuid(), 'RDMtexas', 'optical-roadm', 'Ciena', '6500', NOW(), NOW()),
(gen_random_uuid(), 'RDMvirginia', 'optical-roadm', 'Ciena', '6500', NOW(), NOW()),
(gen_random_uuid(), 'RDMwashington', 'optical-roadm', 'Ciena', '6500', NOW(), NOW())
ON CONFLICT (name) DO NOTHING;