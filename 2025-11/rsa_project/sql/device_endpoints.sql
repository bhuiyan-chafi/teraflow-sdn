-- TPA1
INSERT INTO endpoints (id, device_id, name, type, otn_type, in_use, c_slot, l_slot, created_at, updated_at) VALUES
(gen_random_uuid(), '856b9450-46a4-4804-9b1e-88848a4e132e', '1101', 'muxponder', 'och', false, 34359738368, 34359738368, NOW(), NOW()),
(gen_random_uuid(), '856b9450-46a4-4804-9b1e-88848a4e132e', '1102', 'muxponder', 'och', false, 34359738368, 34359738368, NOW(), NOW()),
(gen_random_uuid(), '856b9450-46a4-4804-9b1e-88848a4e132e', '1103', 'muxponder', 'och', false, 34359738368, 34359738368, NOW(), NOW());

-- TPA2
INSERT INTO endpoints (id, device_id, name, type, otn_type, in_use, c_slot, l_slot, created_at, updated_at) VALUES
(gen_random_uuid(), '2b4e7a61-b62f-4fd1-94c1-72b9e3887942', '1101', 'muxponder', 'och', false, 34359738368, 34359738368, NOW(), NOW()),
(gen_random_uuid(), '2b4e7a61-b62f-4fd1-94c1-72b9e3887942', '1102', 'muxponder', 'och', false, 34359738368, 34359738368, NOW(), NOW()),
(gen_random_uuid(), '2b4e7a61-b62f-4fd1-94c1-72b9e3887942', '1103', 'muxponder', 'och', false, 34359738368, 34359738368, NOW(), NOW());

-- TPA3
INSERT INTO endpoints (id, device_id, name, type, otn_type, in_use, c_slot, l_slot, created_at, updated_at) VALUES
(gen_random_uuid(), '44e96f93-3f5c-4c9e-8d31-bc82f05a210d', '1101', 'muxponder', 'och', false, 34359738368, 34359738368, NOW(), NOW()),
(gen_random_uuid(), '44e96f93-3f5c-4c9e-8d31-bc82f05a210d', '1102', 'muxponder', 'och', false, 34359738368, 34359738368, NOW(), NOW()),
(gen_random_uuid(), '44e96f93-3f5c-4c9e-8d31-bc82f05a210d', '1103', 'muxponder', 'och', false, 34359738368, 34359738368, NOW(), NOW());

-- TPA4
INSERT INTO endpoints (id, device_id, name, type, otn_type, in_use, c_slot, l_slot, created_at, updated_at) VALUES
(gen_random_uuid(), '64adbdf0-3060-440e-aac8-eb406ae34261', '1101', 'muxponder', 'och', false, 34359738368, 34359738368, NOW(), NOW()),
(gen_random_uuid(), '64adbdf0-3060-440e-aac8-eb406ae34261', '1102', 'muxponder', 'och', false, 34359738368, 34359738368, NOW(), NOW()),
(gen_random_uuid(), '64adbdf0-3060-440e-aac8-eb406ae34261', '1103', 'muxponder', 'och', false, 34359738368, 34359738368, NOW(), NOW());

-- RDM1
INSERT INTO endpoints (id, device_id, name, type, otn_type, in_use, c_slot, l_slot, created_at, updated_at) VALUES
(gen_random_uuid(), 'bb0a0ba0-defc-49bd-93dd-bdf685092d59', '1001', 'input', 'och', false, 34359738368, 34359738368, NOW(), NOW()),
(gen_random_uuid(), 'bb0a0ba0-defc-49bd-93dd-bdf685092d59', '2001', 'output', 'och', false, 34359738368, 34359738368, NOW(), NOW()),
(gen_random_uuid(), 'bb0a0ba0-defc-49bd-93dd-bdf685092d59', '1002', 'input', 'och', false, 34359738368, 34359738368, NOW(), NOW()),
(gen_random_uuid(), 'bb0a0ba0-defc-49bd-93dd-bdf685092d59', '2002', 'output', 'och', false, 34359738368, 34359738368, NOW(), NOW()),
(gen_random_uuid(), 'bb0a0ba0-defc-49bd-93dd-bdf685092d59', '1003', 'input', 'och', false, 34359738368, 34359738368, NOW(), NOW()),
(gen_random_uuid(), 'bb0a0ba0-defc-49bd-93dd-bdf685092d59', '2003', 'output', 'och', false, 34359738368, 34359738368, NOW(), NOW()),
(gen_random_uuid(), 'bb0a0ba0-defc-49bd-93dd-bdf685092d59', '3001', 'output', 'oms', false, 34359738368, 34359738368, NOW(), NOW()),
(gen_random_uuid(), 'bb0a0ba0-defc-49bd-93dd-bdf685092d59', '4001', 'input', 'oms', false, 34359738368, 34359738368, NOW(), NOW()),
(gen_random_uuid(), 'bb0a0ba0-defc-49bd-93dd-bdf685092d59', '3002', 'output', 'oms', false, 34359738368, 34359738368, NOW(), NOW()),
(gen_random_uuid(), 'bb0a0ba0-defc-49bd-93dd-bdf685092d59', '4002', 'input', 'oms', false, 34359738368, 34359738368, NOW(), NOW()),
(gen_random_uuid(), 'bb0a0ba0-defc-49bd-93dd-bdf685092d59', '3003', 'output', 'oms', false, 34359738368, 34359738368, NOW(), NOW()),
(gen_random_uuid(), 'bb0a0ba0-defc-49bd-93dd-bdf685092d59', '4003', 'input', 'oms', false, 34359738368, 34359738368, NOW(), NOW());

-- RDM2
INSERT INTO endpoints (id, device_id, name, type, otn_type, in_use, c_slot, l_slot, created_at, updated_at) VALUES
(gen_random_uuid(), 'e6bc3376-0607-4f24-8b3e-67cb1e4aa02a', '1001', 'input', 'och', false, 34359738368, 34359738368, NOW(), NOW()),
(gen_random_uuid(), 'e6bc3376-0607-4f24-8b3e-67cb1e4aa02a', '2001', 'output', 'och', false, 34359738368, 34359738368, NOW(), NOW()),
(gen_random_uuid(), 'e6bc3376-0607-4f24-8b3e-67cb1e4aa02a', '1002', 'input', 'och', false, 34359738368, 34359738368, NOW(), NOW()),
(gen_random_uuid(), 'e6bc3376-0607-4f24-8b3e-67cb1e4aa02a', '2002', 'output', 'och', false, 34359738368, 34359738368, NOW(), NOW()),
(gen_random_uuid(), 'e6bc3376-0607-4f24-8b3e-67cb1e4aa02a', '1003', 'input', 'och', false, 34359738368, 34359738368, NOW(), NOW()),
(gen_random_uuid(), 'e6bc3376-0607-4f24-8b3e-67cb1e4aa02a', '2003', 'output', 'och', false, 34359738368, 34359738368, NOW(), NOW()),
(gen_random_uuid(), 'e6bc3376-0607-4f24-8b3e-67cb1e4aa02a', '3001', 'output', 'oms', false, 34359738368, 34359738368, NOW(), NOW()),
(gen_random_uuid(), 'e6bc3376-0607-4f24-8b3e-67cb1e4aa02a', '4001', 'input', 'oms', false, 34359738368, 34359738368, NOW(), NOW()),
(gen_random_uuid(), 'e6bc3376-0607-4f24-8b3e-67cb1e4aa02a', '3002', 'output', 'oms', false, 34359738368, 34359738368, NOW(), NOW()),
(gen_random_uuid(), 'e6bc3376-0607-4f24-8b3e-67cb1e4aa02a', '4002', 'input', 'oms', false, 34359738368, 34359738368, NOW(), NOW()),
(gen_random_uuid(), 'e6bc3376-0607-4f24-8b3e-67cb1e4aa02a', '3003', 'output', 'oms', false, 34359738368, 34359738368, NOW(), NOW()),
(gen_random_uuid(), 'e6bc3376-0607-4f24-8b3e-67cb1e4aa02a', '4003', 'input', 'oms', false, 34359738368, 34359738368, NOW(), NOW());
