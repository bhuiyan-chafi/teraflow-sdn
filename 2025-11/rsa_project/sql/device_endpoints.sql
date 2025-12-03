-- TP1
INSERT INTO endpoints (id, device_id, name, type, otn_type, in_use, created_at, updated_at) VALUES
(gen_random_uuid(), (SELECT id FROM devices WHERE name='TP1'), '1101', 'duplex', 'OCH', false, NOW(), NOW()),
(gen_random_uuid(), (SELECT id FROM devices WHERE name='TP1'), '1102', 'duplex', 'OCH', false, NOW(), NOW());

-- TP2
INSERT INTO endpoints (id, device_id, name, type, otn_type, in_use, created_at, updated_at) VALUES
(gen_random_uuid(), (SELECT id FROM devices WHERE name='TP2'), '1101', 'duplex', 'OCH', false, NOW(), NOW()),
(gen_random_uuid(), (SELECT id FROM devices WHERE name='TP2'), '1102', 'duplex', 'OCH', false, NOW(), NOW());

-- TP3
INSERT INTO endpoints (id, device_id, name, type, otn_type, in_use, created_at, updated_at) VALUES
(gen_random_uuid(), (SELECT id FROM devices WHERE name='TP3'), '1101', 'duplex', 'OCH', false, NOW(), NOW()),
(gen_random_uuid(), (SELECT id FROM devices WHERE name='TP3'), '1102', 'duplex', 'OCH', false, NOW(), NOW());

-- TP4
INSERT INTO endpoints (id, device_id, name, type, otn_type, in_use, created_at, updated_at) VALUES
(gen_random_uuid(), (SELECT id FROM devices WHERE name='TP4'), '1101', 'duplex', 'OCH', false, NOW(), NOW()),
(gen_random_uuid(), (SELECT id FROM devices WHERE name='TP4'), '1102', 'duplex', 'OCH', false, NOW(), NOW());

-- RDM1
INSERT INTO endpoints (id, device_id, name, type, otn_type, in_use, created_at, updated_at) VALUES
(gen_random_uuid(), (SELECT id FROM devices WHERE name='RDM1'), '1001', 'duplex', 'OCH', false, NOW(), NOW()),
(gen_random_uuid(), (SELECT id FROM devices WHERE name='RDM1'), '1002', 'duplex', 'OCH', false, NOW(), NOW()),
(gen_random_uuid(), (SELECT id FROM devices WHERE name='RDM1'), '1003', 'duplex', 'OCH', false, NOW(), NOW()),
(gen_random_uuid(), (SELECT id FROM devices WHERE name='RDM1'), '1004', 'duplex', 'OCH', false, NOW(), NOW()),
(gen_random_uuid(), (SELECT id FROM devices WHERE name='RDM1'), '1005', 'duplex', 'OCH', false, NOW(), NOW()),
(gen_random_uuid(), (SELECT id FROM devices WHERE name='RDM1'), '2001', 'duplex', 'OMS', false, NOW(), NOW()),
(gen_random_uuid(), (SELECT id FROM devices WHERE name='RDM1'), '2002', 'duplex', 'OMS', false, NOW(), NOW()),
(gen_random_uuid(), (SELECT id FROM devices WHERE name='RDM1'), '2003', 'duplex', 'OMS', false, NOW(), NOW()),
(gen_random_uuid(), (SELECT id FROM devices WHERE name='RDM1'), '2004', 'duplex', 'OMS', false, NOW(), NOW()),
(gen_random_uuid(), (SELECT id FROM devices WHERE name='RDM1'), '2005', 'duplex', 'OMS', false, NOW(), NOW());

-- RDM2
INSERT INTO endpoints (id, device_id, name, type, otn_type, in_use, created_at, updated_at) VALUES
(gen_random_uuid(), (SELECT id FROM devices WHERE name='RDM2'), '1001', 'duplex', 'OCH', false, NOW(), NOW()),
(gen_random_uuid(), (SELECT id FROM devices WHERE name='RDM2'), '1002', 'duplex', 'OCH', false, NOW(), NOW()),
(gen_random_uuid(), (SELECT id FROM devices WHERE name='RDM2'), '1003', 'duplex', 'OCH', false, NOW(), NOW()),
(gen_random_uuid(), (SELECT id FROM devices WHERE name='RDM2'), '1004', 'duplex', 'OCH', false, NOW(), NOW()),
(gen_random_uuid(), (SELECT id FROM devices WHERE name='RDM2'), '1005', 'duplex', 'OCH', false, NOW(), NOW()),
(gen_random_uuid(), (SELECT id FROM devices WHERE name='RDM2'), '2001', 'duplex', 'OMS', false, NOW(), NOW()),
(gen_random_uuid(), (SELECT id FROM devices WHERE name='RDM2'), '2002', 'duplex', 'OMS', false, NOW(), NOW()),
(gen_random_uuid(), (SELECT id FROM devices WHERE name='RDM2'), '2003', 'duplex', 'OMS', false, NOW(), NOW()),
(gen_random_uuid(), (SELECT id FROM devices WHERE name='RDM2'), '2004', 'duplex', 'OMS', false, NOW(), NOW()),
(gen_random_uuid(), (SELECT id FROM devices WHERE name='RDM2'), '2005', 'duplex', 'OMS', false, NOW(), NOW());

-- RDM3
INSERT INTO endpoints (id, device_id, name, type, otn_type, in_use, created_at, updated_at) VALUES
(gen_random_uuid(), (SELECT id FROM devices WHERE name='RDM3'), '1001', 'duplex', 'OCH', false, NOW(), NOW()),
(gen_random_uuid(), (SELECT id FROM devices WHERE name='RDM3'), '1002', 'duplex', 'OCH', false, NOW(), NOW()),
(gen_random_uuid(), (SELECT id FROM devices WHERE name='RDM3'), '1003', 'duplex', 'OCH', false, NOW(), NOW()),
(gen_random_uuid(), (SELECT id FROM devices WHERE name='RDM3'), '1004', 'duplex', 'OCH', false, NOW(), NOW()),
(gen_random_uuid(), (SELECT id FROM devices WHERE name='RDM3'), '1005', 'duplex', 'OCH', false, NOW(), NOW()),
(gen_random_uuid(), (SELECT id FROM devices WHERE name='RDM3'), '2001', 'duplex', 'OMS', false, NOW(), NOW()),
(gen_random_uuid(), (SELECT id FROM devices WHERE name='RDM3'), '2002', 'duplex', 'OMS', false, NOW(), NOW()),
(gen_random_uuid(), (SELECT id FROM devices WHERE name='RDM3'), '2003', 'duplex', 'OMS', false, NOW(), NOW()),
(gen_random_uuid(), (SELECT id FROM devices WHERE name='RDM3'), '2004', 'duplex', 'OMS', false, NOW(), NOW()),
(gen_random_uuid(), (SELECT id FROM devices WHERE name='RDM3'), '2005', 'duplex', 'OMS', false, NOW(), NOW());

--- RDM4
INSERT INTO endpoints (id, device_id, name, type, otn_type, in_use, created_at, updated_at) VALUES
(gen_random_uuid(), (SELECT id FROM devices WHERE name='RDM4'), '1001', 'duplex', 'OCH', false, NOW(), NOW()),
(gen_random_uuid(), (SELECT id FROM devices WHERE name='RDM4'), '1002', 'duplex', 'OCH', false, NOW(), NOW()),
(gen_random_uuid(), (SELECT id FROM devices WHERE name='RDM4'), '1003', 'duplex', 'OCH', false, NOW(), NOW()),
(gen_random_uuid(), (SELECT id FROM devices WHERE name='RDM4'), '1004', 'duplex', 'OCH', false, NOW(), NOW()),
(gen_random_uuid(), (SELECT id FROM devices WHERE name='RDM4'), '1005', 'duplex', 'OCH', false, NOW(), NOW()),
(gen_random_uuid(), (SELECT id FROM devices WHERE name='RDM4'), '2001', 'duplex', 'OMS', false, NOW(), NOW()),
(gen_random_uuid(), (SELECT id FROM devices WHERE name='RDM4'), '2002', 'duplex', 'OMS', false, NOW(), NOW()),
(gen_random_uuid(), (SELECT id FROM devices WHERE name='RDM4'), '2003', 'duplex', 'OMS', false, NOW(), NOW()),
(gen_random_uuid(), (SELECT id FROM devices WHERE name='RDM4'), '2004', 'duplex', 'OMS', false, NOW(), NOW()),
(gen_random_uuid(), (SELECT id FROM devices WHERE name='RDM4'), '2005', 'duplex', 'OMS', false, NOW(), NOW());

--- RDM5
INSERT INTO endpoints (id, device_id, name, type, otn_type, in_use, created_at, updated_at) VALUES
(gen_random_uuid(), (SELECT id FROM devices WHERE name='RDM5'), '1001', 'duplex', 'OCH', false, NOW(), NOW()),
(gen_random_uuid(), (SELECT id FROM devices WHERE name='RDM5'), '1002', 'duplex', 'OCH', false, NOW(), NOW()),
(gen_random_uuid(), (SELECT id FROM devices WHERE name='RDM5'), '1003', 'duplex', 'OCH', false, NOW(), NOW()),
(gen_random_uuid(), (SELECT id FROM devices WHERE name='RDM5'), '1004', 'duplex', 'OCH', false, NOW(), NOW()),
(gen_random_uuid(), (SELECT id FROM devices WHERE name='RDM5'), '1005', 'duplex', 'OCH', false, NOW(), NOW()),
(gen_random_uuid(), (SELECT id FROM devices WHERE name='RDM5'), '2001', 'duplex', 'OMS', false, NOW(), NOW()),
(gen_random_uuid(), (SELECT id FROM devices WHERE name='RDM5'), '2002', 'duplex', 'OMS', false, NOW(), NOW()),
(gen_random_uuid(), (SELECT id FROM devices WHERE name='RDM5'), '2003', 'duplex', 'OMS', false, NOW(), NOW()),
(gen_random_uuid(), (SELECT id FROM devices WHERE name='RDM5'), '2004', 'duplex', 'OMS', false, NOW(), NOW()),
(gen_random_uuid(), (SELECT id FROM devices WHERE name='RDM5'), '2005', 'duplex', 'OMS', false, NOW(), NOW());

--- RDM6
INSERT INTO endpoints (id, device_id, name, type, otn_type, in_use, created_at, updated_at) VALUES
(gen_random_uuid(), (SELECT id FROM devices WHERE name='RDM6'), '1001', 'duplex', 'OCH', false, NOW(), NOW()),
(gen_random_uuid(), (SELECT id FROM devices WHERE name='RDM6'), '1002', 'duplex', 'OCH', false, NOW(), NOW()),
(gen_random_uuid(), (SELECT id FROM devices WHERE name='RDM6'), '1003', 'duplex', 'OCH', false, NOW(), NOW()),
(gen_random_uuid(), (SELECT id FROM devices WHERE name='RDM6'), '1004', 'duplex', 'OCH', false, NOW(), NOW()),
(gen_random_uuid(), (SELECT id FROM devices WHERE name='RDM6'), '1005', 'duplex', 'OCH', false, NOW(), NOW()),
(gen_random_uuid(), (SELECT id FROM devices WHERE name='RDM6'), '2001', 'duplex', 'OMS', false, NOW(), NOW()),
(gen_random_uuid(), (SELECT id FROM devices WHERE name='RDM6'), '2002', 'duplex', 'OMS', false, NOW(), NOW()),
(gen_random_uuid(), (SELECT id FROM devices WHERE name='RDM6'), '2003', 'duplex', 'OMS', false, NOW(), NOW()),
(gen_random_uuid(), (SELECT id FROM devices WHERE name='RDM6'), '2004', 'duplex', 'OMS', false, NOW(), NOW()),
(gen_random_uuid(), (SELECT id FROM devices WHERE name='RDM6'), '2005', 'duplex', 'OMS', false, NOW(), NOW());