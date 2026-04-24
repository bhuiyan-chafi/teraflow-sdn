-- NSF Topology Devices

INSERT INTO devices (id, name, type, vendor, model, created_at, updated_at) VALUES
(gen_random_uuid(), 'RDMwa', 'optical-roadm', 'Ciena', '6500', NOW(), NOW()),
(gen_random_uuid(), 'RDMca1', 'optical-roadm', 'Ciena', '6500', NOW(), NOW()),
(gen_random_uuid(), 'RDMca2', 'optical-roadm', 'Ciena', '6500', NOW(), NOW()),
(gen_random_uuid(), 'RDMut', 'optical-roadm', 'Ciena', '6500', NOW(), NOW()),
(gen_random_uuid(), 'RDMco', 'optical-roadm', 'Ciena', '6500', NOW(), NOW()),
(gen_random_uuid(), 'RDMne', 'optical-roadm', 'Ciena', '6500', NOW(), NOW()),
(gen_random_uuid(), 'RDMtx', 'optical-roadm', 'Ciena', '6500', NOW(), NOW()),
(gen_random_uuid(), 'RDMil', 'optical-roadm', 'Ciena', '6500', NOW(), NOW()),
(gen_random_uuid(), 'RDMmi', 'optical-roadm', 'Ciena', '6500', NOW(), NOW()),
(gen_random_uuid(), 'RDMpa', 'optical-roadm', 'Ciena', '6500', NOW(), NOW()),
(gen_random_uuid(), 'RDMny', 'optical-roadm', 'Ciena', '6500', NOW(), NOW()),
(gen_random_uuid(), 'RDMnj', 'optical-roadm', 'Ciena', '6500', NOW(), NOW()),
(gen_random_uuid(), 'RDMma', 'optical-roadm', 'Ciena', '6500', NOW(), NOW()),
(gen_random_uuid(), 'RDMga', 'optical-roadm', 'Ciena', '6500', NOW(), NOW())
ON CONFLICT (name) DO NOTHING;
