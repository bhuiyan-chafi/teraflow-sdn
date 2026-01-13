INSERT INTO devices (id, name, type, vendor, model, created_at, updated_at) VALUES
(gen_random_uuid(), 'TP1', 'optical-transponder', 'Cisco', 'NCS1004', NOW(), NOW()),
(gen_random_uuid(), 'TP2', 'optical-transponder', 'Cisco', 'NCS1004', NOW(), NOW()),
(gen_random_uuid(), 'TP3', 'optical-transponder', 'Ciena', 'Waveserver 5', NOW(), NOW()),
(gen_random_uuid(), 'TP4', 'optical-transponder', 'Ciena', 'Waveserver 5', NOW(), NOW()),
(gen_random_uuid(), 'RDM1', 'optical-roadm', 'ADVA', 'FSP 3000', NOW(), NOW()),
(gen_random_uuid(), 'RDM2', 'optical-roadm', 'ADVA', 'FSP 3000', NOW(), NOW()),
(gen_random_uuid(), 'RDM3', 'optical-roadm', 'Infinera', 'GX Series', NOW(), NOW()),
(gen_random_uuid(), 'RDM4', 'optical-roadm', 'Infinera', 'GX Series', NOW(), NOW()),
(gen_random_uuid(), 'RDM5', 'optical-roadm', 'Nokia', '1830 PSS', NOW(), NOW()),
(gen_random_uuid(), 'RDM6', 'optical-roadm', 'Nokia', '1830 PSS', NOW(), NOW())
ON CONFLICT (name) DO NOTHING;
