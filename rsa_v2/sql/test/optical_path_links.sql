-- TPA1 -> RDM1 -> RDM2 -> TPA3: Tx path
-- TPA3 -> RDM2 -> RDM1 -> TPA1: Rx path
INSERT INTO optical_path_links (id, optical_path_uuid, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
(gen_random_uuid(), 'ef870065-fa8b-4fd7-aade-4eb93f03cb4f', 'f1813a94-6ba5-49ea-9b1e-2ded9de38747', 'bb0a0ba0-defc-49bd-93dd-bdf685092d59', 'a43a31b4-665b-4df9-8455-3053aa152c77', '2838095d-5098-41a3-99dc-3213b17c1801', 'up', NOW(), NOW()),
(gen_random_uuid(), 'ef870065-fa8b-4fd7-aade-4eb93f03cb4f', 'bb0a0ba0-defc-49bd-93dd-bdf685092d59', 'e6bc3376-0607-4f24-8b3e-67cb1e4aa02a', '6af38d0b-0be2-4e20-b167-e8b495d5ee85', '75a97ebd-f958-461a-a55d-2ee7ff2c73fe', 'up', NOW(), NOW()),
(gen_random_uuid(), 'ef870065-fa8b-4fd7-aade-4eb93f03cb4f', 'e6bc3376-0607-4f24-8b3e-67cb1e4aa02a', '44e96f93-3f5c-4c9e-8d31-bc82f05a210d', '25fcf1f4-b143-401a-ae5f-a9c1e1290c76', '8e08780f-6f04-4e30-8073-4c0947f97960', 'up', NOW(), NOW()),
(gen_random_uuid(), 'ef870065-fa8b-4fd7-aade-4eb93f03cb4f', '44e96f93-3f5c-4c9e-8d31-bc82f05a210d', 'e6bc3376-0607-4f24-8b3e-67cb1e4aa02a', '8e08780f-6f04-4e30-8073-4c0947f97960', 'e0b7fd14-d2bc-488a-91dd-27bd8b670cd5', 'up', NOW(), NOW()),
(gen_random_uuid(), 'ef870065-fa8b-4fd7-aade-4eb93f03cb4f', 'e6bc3376-0607-4f24-8b3e-67cb1e4aa02a', 'bb0a0ba0-defc-49bd-93dd-bdf685092d59', '106173f3-d280-4fbf-a5ca-0f7528638b2d', 'eaf11645-c8fa-462c-acb6-bc77debd1bc7', 'up', NOW(), NOW()),
(gen_random_uuid(), 'ef870065-fa8b-4fd7-aade-4eb93f03cb4f', 'bb0a0ba0-defc-49bd-93dd-bdf685092d59', 'f1813a94-6ba5-49ea-9b1e-2ded9de38747', '3bff189f-e436-42de-99aa-fc61a9a04bf9', 'a43a31b4-665b-4df9-8455-3053aa152c77', 'up', NOW(), NOW());

-- TPA2 -> RDM1 -> RDM2 -> TPA4: Tx path
-- TPA4 -> RDM2 -> RDM1 -> TPA2: Rx path
INSERT INTO optical_path_links (id, optical_path_uuid, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
(gen_random_uuid(), '30861664-8519-4498-bdfa-2ef7a810d4d6', 'd0e50594-0466-4d56-a402-01fb3a2e6a74', 'bb0a0ba0-defc-49bd-93dd-bdf685092d59', '85ec37a4-4afa-41a1-9dbc-dd8ab731f3b6', '2838095d-5098-41a3-99dc-3213b17c1801', 'up', NOW(), NOW()),
(gen_random_uuid(), '30861664-8519-4498-bdfa-2ef7a810d4d6', 'bb0a0ba0-defc-49bd-93dd-bdf685092d59', 'e6bc3376-0607-4f24-8b3e-67cb1e4aa02a', '6af38d0b-0be2-4e20-b167-e8b495d5ee85', '75a97ebd-f958-461a-a55d-2ee7ff2c73fe', 'up', NOW(), NOW()),
(gen_random_uuid(), '30861664-8519-4498-bdfa-2ef7a810d4d6', 'e6bc3376-0607-4f24-8b3e-67cb1e4aa02a', '64adbdf0-3060-440e-aac8-eb406ae34261', '25fcf1f4-b143-401a-ae5f-a9c1e1290c76', '16888d53-b880-47fb-8e58-0cb3c2d1c200', 'up', NOW(), NOW()),
(gen_random_uuid(), '30861664-8519-4498-bdfa-2ef7a810d4d6', '64adbdf0-3060-440e-aac8-eb406ae34261', 'e6bc3376-0607-4f24-8b3e-67cb1e4aa02a', '16888d53-b880-47fb-8e58-0cb3c2d1c200', 'e0b7fd14-d2bc-488a-91dd-27bd8b670cd5', 'up', NOW(), NOW()),
(gen_random_uuid(), '30861664-8519-4498-bdfa-2ef7a810d4d6', 'e6bc3376-0607-4f24-8b3e-67cb1e4aa02a', 'bb0a0ba0-defc-49bd-93dd-bdf685092d59', '106173f3-d280-4fbf-a5ca-0f7528638b2d', 'eaf11645-c8fa-462c-acb6-bc77debd1bc7', 'up', NOW(), NOW()),
(gen_random_uuid(), '30861664-8519-4498-bdfa-2ef7a810d4d6', 'bb0a0ba0-defc-49bd-93dd-bdf685092d59', 'd0e50594-0466-4d56-a402-01fb3a2e6a74', '3bff189f-e436-42de-99aa-fc61a9a04bf9', '85ec37a4-4afa-41a1-9dbc-dd8ab731f3b6', 'up', NOW(), NOW());

-- TPA5 -> RDM1 -> RDM2 -> TPA6: Tx path
-- TPA6 -> RDM2 -> RDM1 -> TPA5: Rx path
INSERT INTO optical_path_links (id, optical_path_uuid, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
(gen_random_uuid(), 'b7be9234-cffb-4fb8-95cf-bcf94021c104', '856b9450-46a4-4804-9b1e-88848a4e132e', 'bb0a0ba0-defc-49bd-93dd-bdf685092d59', '3cbe9a5e-6548-40fa-928b-f46ea26add91', '2838095d-5098-41a3-99dc-3213b17c1801', 'up', NOW(), NOW()),
(gen_random_uuid(), 'b7be9234-cffb-4fb8-95cf-bcf94021c104', 'bb0a0ba0-defc-49bd-93dd-bdf685092d59', 'e6bc3376-0607-4f24-8b3e-67cb1e4aa02a', '6af38d0b-0be2-4e20-b167-e8b495d5ee85', '75a97ebd-f958-461a-a55d-2ee7ff2c73fe', 'up', NOW(), NOW()),
(gen_random_uuid(), 'b7be9234-cffb-4fb8-95cf-bcf94021c104', 'e6bc3376-0607-4f24-8b3e-67cb1e4aa02a', '2b4e7a61-b62f-4fd1-94c1-72b9e3887942', '25fcf1f4-b143-401a-ae5f-a9c1e1290c76', '09f1f1e2-42c8-4a9f-9ca0-1e8b30b68636', 'up', NOW(), NOW()),
(gen_random_uuid(), 'b7be9234-cffb-4fb8-95cf-bcf94021c104', '2b4e7a61-b62f-4fd1-94c1-72b9e3887942', 'e6bc3376-0607-4f24-8b3e-67cb1e4aa02a', '09f1f1e2-42c8-4a9f-9ca0-1e8b30b68636', 'e0b7fd14-d2bc-488a-91dd-27bd8b670cd5', 'up', NOW(), NOW()),
(gen_random_uuid(), 'b7be9234-cffb-4fb8-95cf-bcf94021c104', 'e6bc3376-0607-4f24-8b3e-67cb1e4aa02a', 'bb0a0ba0-defc-49bd-93dd-bdf685092d59', '106173f3-d280-4fbf-a5ca-0f7528638b2d', 'eaf11645-c8fa-462c-acb6-bc77debd1bc7', 'up', NOW(), NOW()),
(gen_random_uuid(), 'b7be9234-cffb-4fb8-95cf-bcf94021c104', 'bb0a0ba0-defc-49bd-93dd-bdf685092d59', '856b9450-46a4-4804-9b1e-88848a4e132e', '3bff189f-e436-42de-99aa-fc61a9a04bf9', '3cbe9a5e-6548-40fa-928b-f46ea26add91', 'up', NOW(), NOW());