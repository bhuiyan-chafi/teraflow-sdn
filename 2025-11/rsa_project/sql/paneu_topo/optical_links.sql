-- Pan-EU Parallel Topology: Optical Links
-- TP->RDM links: OCH on both sides
-- RDM->RDM links: OMS on both sides

--- TPlondon-RDMlondon
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'TPlondon->RDMlondon_1', (SELECT id FROM devices WHERE name='TPlondon'), (SELECT id FROM devices WHERE name='RDMlondon'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPlondon') AND name='1101' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlondon') AND name='1001' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'TPlondon->RDMlondon_2', (SELECT id FROM devices WHERE name='TPlondon'), (SELECT id FROM devices WHERE name='RDMlondon'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPlondon') AND name='1102' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlondon') AND name='1002' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'TPlondon->RDMlondon_3', (SELECT id FROM devices WHERE name='TPlondon'), (SELECT id FROM devices WHERE name='RDMlondon'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPlondon') AND name='1103' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlondon') AND name='1003' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- TPparis-RDMparis
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'TPparis->RDMparis_4', (SELECT id FROM devices WHERE name='TPparis'), (SELECT id FROM devices WHERE name='RDMparis'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPparis') AND name='1101' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMparis') AND name='1001' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'TPparis->RDMparis_5', (SELECT id FROM devices WHERE name='TPparis'), (SELECT id FROM devices WHERE name='RDMparis'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPparis') AND name='1102' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMparis') AND name='1002' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'TPparis->RDMparis_6', (SELECT id FROM devices WHERE name='TPparis'), (SELECT id FROM devices WHERE name='RDMparis'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPparis') AND name='1103' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMparis') AND name='1003' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- TPfrankfurt-RDMfrankfurt
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'TPfrankfurt->RDMfrankfurt_7', (SELECT id FROM devices WHERE name='TPfrankfurt'), (SELECT id FROM devices WHERE name='RDMfrankfurt'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPfrankfurt') AND name='1101' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMfrankfurt') AND name='1001' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'TPfrankfurt->RDMfrankfurt_8', (SELECT id FROM devices WHERE name='TPfrankfurt'), (SELECT id FROM devices WHERE name='RDMfrankfurt'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPfrankfurt') AND name='1102' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMfrankfurt') AND name='1002' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'TPfrankfurt->RDMfrankfurt_9', (SELECT id FROM devices WHERE name='TPfrankfurt'), (SELECT id FROM devices WHERE name='RDMfrankfurt'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPfrankfurt') AND name='1103' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMfrankfurt') AND name='1003' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- TPamsterdam-RDMamsterdam
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'TPamsterdam->RDMamsterdam_10', (SELECT id FROM devices WHERE name='TPamsterdam'), (SELECT id FROM devices WHERE name='RDMamsterdam'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPamsterdam') AND name='1101' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMamsterdam') AND name='1001' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'TPamsterdam->RDMamsterdam_11', (SELECT id FROM devices WHERE name='TPamsterdam'), (SELECT id FROM devices WHERE name='RDMamsterdam'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPamsterdam') AND name='1102' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMamsterdam') AND name='1002' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'TPamsterdam->RDMamsterdam_12', (SELECT id FROM devices WHERE name='TPamsterdam'), (SELECT id FROM devices WHERE name='RDMamsterdam'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPamsterdam') AND name='1103' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMamsterdam') AND name='1003' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- TPmadrid-RDMmadrid
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'TPmadrid->RDMmadrid_13', (SELECT id FROM devices WHERE name='TPmadrid'), (SELECT id FROM devices WHERE name='RDMmadrid'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPmadrid') AND name='1101' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmadrid') AND name='1001' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'TPmadrid->RDMmadrid_14', (SELECT id FROM devices WHERE name='TPmadrid'), (SELECT id FROM devices WHERE name='RDMmadrid'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPmadrid') AND name='1102' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmadrid') AND name='1002' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'TPmadrid->RDMmadrid_15', (SELECT id FROM devices WHERE name='TPmadrid'), (SELECT id FROM devices WHERE name='RDMmadrid'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPmadrid') AND name='1103' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmadrid') AND name='1003' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- TProme-RDMrome
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'TProme->RDMrome_16', (SELECT id FROM devices WHERE name='TProme'), (SELECT id FROM devices WHERE name='RDMrome'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TProme') AND name='1101' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMrome') AND name='1001' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'TProme->RDMrome_17', (SELECT id FROM devices WHERE name='TProme'), (SELECT id FROM devices WHERE name='RDMrome'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TProme') AND name='1102' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMrome') AND name='1002' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'TProme->RDMrome_18', (SELECT id FROM devices WHERE name='TProme'), (SELECT id FROM devices WHERE name='RDMrome'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TProme') AND name='1103' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMrome') AND name='1003' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- TPberlin-RDMberlin
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'TPberlin->RDMberlin_19', (SELECT id FROM devices WHERE name='TPberlin'), (SELECT id FROM devices WHERE name='RDMberlin'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPberlin') AND name='1101' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMberlin') AND name='1001' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'TPberlin->RDMberlin_20', (SELECT id FROM devices WHERE name='TPberlin'), (SELECT id FROM devices WHERE name='RDMberlin'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPberlin') AND name='1102' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMberlin') AND name='1002' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'TPberlin->RDMberlin_21', (SELECT id FROM devices WHERE name='TPberlin'), (SELECT id FROM devices WHERE name='RDMberlin'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPberlin') AND name='1103' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMberlin') AND name='1003' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- TPwarsaw-RDMwarsaw
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'TPwarsaw->RDMwarsaw_22', (SELECT id FROM devices WHERE name='TPwarsaw'), (SELECT id FROM devices WHERE name='RDMwarsaw'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPwarsaw') AND name='1101' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMwarsaw') AND name='1001' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'TPwarsaw->RDMwarsaw_23', (SELECT id FROM devices WHERE name='TPwarsaw'), (SELECT id FROM devices WHERE name='RDMwarsaw'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPwarsaw') AND name='1102' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMwarsaw') AND name='1002' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'TPwarsaw->RDMwarsaw_24', (SELECT id FROM devices WHERE name='TPwarsaw'), (SELECT id FROM devices WHERE name='RDMwarsaw'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPwarsaw') AND name='1103' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMwarsaw') AND name='1003' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- TPstockholm-RDMstockholm
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'TPstockholm->RDMstockholm_25', (SELECT id FROM devices WHERE name='TPstockholm'), (SELECT id FROM devices WHERE name='RDMstockholm'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPstockholm') AND name='1101' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMstockholm') AND name='1001' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'TPstockholm->RDMstockholm_26', (SELECT id FROM devices WHERE name='TPstockholm'), (SELECT id FROM devices WHERE name='RDMstockholm'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPstockholm') AND name='1102' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMstockholm') AND name='1002' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'TPstockholm->RDMstockholm_27', (SELECT id FROM devices WHERE name='TPstockholm'), (SELECT id FROM devices WHERE name='RDMstockholm'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPstockholm') AND name='1103' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMstockholm') AND name='1003' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- TPathens-RDMathens
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'TPathens->RDMathens_28', (SELECT id FROM devices WHERE name='TPathens'), (SELECT id FROM devices WHERE name='RDMathens'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPathens') AND name='1101' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMathens') AND name='1001' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'TPathens->RDMathens_29', (SELECT id FROM devices WHERE name='TPathens'), (SELECT id FROM devices WHERE name='RDMathens'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPathens') AND name='1102' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMathens') AND name='1002' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'TPathens->RDMathens_30', (SELECT id FROM devices WHERE name='TPathens'), (SELECT id FROM devices WHERE name='RDMathens'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPathens') AND name='1103' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMathens') AND name='1003' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMdublin-RDMglasgow
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMdublin->RDMglasgow_31', (SELECT id FROM devices WHERE name='RDMdublin'), (SELECT id FROM devices WHERE name='RDMglasgow'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMdublin') AND name='2001' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMglasgow') AND name='2001' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'RDMdublin->RDMglasgow_83', (SELECT id FROM devices WHERE name='RDMdublin'), (SELECT id FROM devices WHERE name='RDMglasgow'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMdublin') AND name='2003' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMglasgow') AND name='2005' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMdublin-RDMlondon
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMdublin->RDMlondon_32', (SELECT id FROM devices WHERE name='RDMdublin'), (SELECT id FROM devices WHERE name='RDMlondon'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMdublin') AND name='2002' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlondon') AND name='2001' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'RDMdublin->RDMlondon_84', (SELECT id FROM devices WHERE name='RDMdublin'), (SELECT id FROM devices WHERE name='RDMlondon'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMdublin') AND name='2004' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlondon') AND name='2006' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMglasgow-RDMlondon
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMglasgow->RDMlondon_33', (SELECT id FROM devices WHERE name='RDMglasgow'), (SELECT id FROM devices WHERE name='RDMlondon'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMglasgow') AND name='2002' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlondon') AND name='2002' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMglasgow-RDMamsterdam
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMglasgow->RDMamsterdam_34', (SELECT id FROM devices WHERE name='RDMglasgow'), (SELECT id FROM devices WHERE name='RDMamsterdam'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMglasgow') AND name='2003' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMamsterdam') AND name='2001' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'RDMglasgow->RDMamsterdam_85', (SELECT id FROM devices WHERE name='RDMglasgow'), (SELECT id FROM devices WHERE name='RDMamsterdam'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMglasgow') AND name='2006' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMamsterdam') AND name='2005' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMglasgow-RDMcopenhagen
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMglasgow->RDMcopenhagen_35', (SELECT id FROM devices WHERE name='RDMglasgow'), (SELECT id FROM devices WHERE name='RDMcopenhagen'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMglasgow') AND name='2004' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMcopenhagen') AND name='2001' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMlondon-RDMamsterdam
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMlondon->RDMamsterdam_36', (SELECT id FROM devices WHERE name='RDMlondon'), (SELECT id FROM devices WHERE name='RDMamsterdam'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlondon') AND name='2003' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMamsterdam') AND name='2002' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMlondon-RDMbrussels
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMlondon->RDMbrussels_37', (SELECT id FROM devices WHERE name='RDMlondon'), (SELECT id FROM devices WHERE name='RDMbrussels'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlondon') AND name='2004' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbrussels') AND name='2001' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMlondon-RDMparis
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMlondon->RDMparis_38', (SELECT id FROM devices WHERE name='RDMlondon'), (SELECT id FROM devices WHERE name='RDMparis'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlondon') AND name='2005' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMparis') AND name='2001' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMamsterdam-RDMbrussels
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMamsterdam->RDMbrussels_39', (SELECT id FROM devices WHERE name='RDMamsterdam'), (SELECT id FROM devices WHERE name='RDMbrussels'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMamsterdam') AND name='2003' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbrussels') AND name='2002' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'RDMamsterdam->RDMbrussels_86', (SELECT id FROM devices WHERE name='RDMamsterdam'), (SELECT id FROM devices WHERE name='RDMbrussels'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMamsterdam') AND name='2006' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbrussels') AND name='2005' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMamsterdam-RDMhamburg
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMamsterdam->RDMhamburg_40', (SELECT id FROM devices WHERE name='RDMamsterdam'), (SELECT id FROM devices WHERE name='RDMhamburg'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMamsterdam') AND name='2004' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMhamburg') AND name='2001' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMbrussels-RDMfrankfurt
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMbrussels->RDMfrankfurt_41', (SELECT id FROM devices WHERE name='RDMbrussels'), (SELECT id FROM devices WHERE name='RDMfrankfurt'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbrussels') AND name='2003' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMfrankfurt') AND name='2001' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'RDMbrussels->RDMfrankfurt_87', (SELECT id FROM devices WHERE name='RDMbrussels'), (SELECT id FROM devices WHERE name='RDMfrankfurt'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbrussels') AND name='2006' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMfrankfurt') AND name='2006' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMbrussels-RDMparis
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMbrussels->RDMparis_42', (SELECT id FROM devices WHERE name='RDMbrussels'), (SELECT id FROM devices WHERE name='RDMparis'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbrussels') AND name='2004' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMparis') AND name='2002' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMparis-RDMstrasbourg
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMparis->RDMstrasbourg_43', (SELECT id FROM devices WHERE name='RDMparis'), (SELECT id FROM devices WHERE name='RDMstrasbourg'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMparis') AND name='2003' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMstrasbourg') AND name='2001' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'RDMparis->RDMstrasbourg_88', (SELECT id FROM devices WHERE name='RDMparis'), (SELECT id FROM devices WHERE name='RDMstrasbourg'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMparis') AND name='2006' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMstrasbourg') AND name='2003' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMparis-RDMlyon
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMparis->RDMlyon_44', (SELECT id FROM devices WHERE name='RDMparis'), (SELECT id FROM devices WHERE name='RDMlyon'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMparis') AND name='2004' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlyon') AND name='2001' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMparis-RDMbordeaux
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMparis->RDMbordeaux_45', (SELECT id FROM devices WHERE name='RDMparis'), (SELECT id FROM devices WHERE name='RDMbordeaux'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMparis') AND name='2005' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbordeaux') AND name='2001' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMstrasbourg-RDMzurich
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMstrasbourg->RDMzurich_46', (SELECT id FROM devices WHERE name='RDMstrasbourg'), (SELECT id FROM devices WHERE name='RDMzurich'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMstrasbourg') AND name='2002' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMzurich') AND name='2001' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'RDMstrasbourg->RDMzurich_89', (SELECT id FROM devices WHERE name='RDMstrasbourg'), (SELECT id FROM devices WHERE name='RDMzurich'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMstrasbourg') AND name='2004' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMzurich') AND name='2005' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMlyon-RDMbordeaux
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMlyon->RDMbordeaux_47', (SELECT id FROM devices WHERE name='RDMlyon'), (SELECT id FROM devices WHERE name='RDMbordeaux'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlyon') AND name='2002' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbordeaux') AND name='2002' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'RDMlyon->RDMbordeaux_90', (SELECT id FROM devices WHERE name='RDMlyon'), (SELECT id FROM devices WHERE name='RDMbordeaux'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlyon') AND name='2006' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbordeaux') AND name='2005' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMlyon-RDMbarcelona
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMlyon->RDMbarcelona_48', (SELECT id FROM devices WHERE name='RDMlyon'), (SELECT id FROM devices WHERE name='RDMbarcelona'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlyon') AND name='2003' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbarcelona') AND name='2001' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMlyon-RDMmilan
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMlyon->RDMmilan_49', (SELECT id FROM devices WHERE name='RDMlyon'), (SELECT id FROM devices WHERE name='RDMmilan'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlyon') AND name='2004' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmilan') AND name='2001' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMlyon-RDMzurich
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMlyon->RDMzurich_50', (SELECT id FROM devices WHERE name='RDMlyon'), (SELECT id FROM devices WHERE name='RDMzurich'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlyon') AND name='2005' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMzurich') AND name='2002' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMbordeaux-RDMmadrid
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMbordeaux->RDMmadrid_51', (SELECT id FROM devices WHERE name='RDMbordeaux'), (SELECT id FROM devices WHERE name='RDMmadrid'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbordeaux') AND name='2003' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmadrid') AND name='2001' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'RDMbordeaux->RDMmadrid_91', (SELECT id FROM devices WHERE name='RDMbordeaux'), (SELECT id FROM devices WHERE name='RDMmadrid'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbordeaux') AND name='2006' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmadrid') AND name='2003' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMbordeaux-RDMbarcelona
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMbordeaux->RDMbarcelona_52', (SELECT id FROM devices WHERE name='RDMbordeaux'), (SELECT id FROM devices WHERE name='RDMbarcelona'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbordeaux') AND name='2004' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbarcelona') AND name='2002' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMmadrid-RDMbarcelona
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMmadrid->RDMbarcelona_53', (SELECT id FROM devices WHERE name='RDMmadrid'), (SELECT id FROM devices WHERE name='RDMbarcelona'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmadrid') AND name='2002' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbarcelona') AND name='2003' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'RDMmadrid->RDMbarcelona_92', (SELECT id FROM devices WHERE name='RDMmadrid'), (SELECT id FROM devices WHERE name='RDMbarcelona'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmadrid') AND name='2004' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbarcelona') AND name='2004' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'RDMmadrid->RDMbarcelona_103', (SELECT id FROM devices WHERE name='RDMmadrid'), (SELECT id FROM devices WHERE name='RDMbarcelona'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmadrid') AND name='2005' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbarcelona') AND name='2005' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'RDMmadrid->RDMbarcelona_105', (SELECT id FROM devices WHERE name='RDMmadrid'), (SELECT id FROM devices WHERE name='RDMbarcelona'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmadrid') AND name='2006' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbarcelona') AND name='2006' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMmilan-RDMzurich
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMmilan->RDMzurich_54', (SELECT id FROM devices WHERE name='RDMmilan'), (SELECT id FROM devices WHERE name='RDMzurich'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmilan') AND name='2002' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMzurich') AND name='2003' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'RDMmilan->RDMzurich_93', (SELECT id FROM devices WHERE name='RDMmilan'), (SELECT id FROM devices WHERE name='RDMzurich'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmilan') AND name='2005' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMzurich') AND name='2006' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMmilan-RDMvienna
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMmilan->RDMvienna_55', (SELECT id FROM devices WHERE name='RDMmilan'), (SELECT id FROM devices WHERE name='RDMvienna'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmilan') AND name='2003' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMvienna') AND name='2001' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'RDMmilan->RDMvienna_94', (SELECT id FROM devices WHERE name='RDMmilan'), (SELECT id FROM devices WHERE name='RDMvienna'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmilan') AND name='2006' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMvienna') AND name='2006' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMmilan-RDMrome
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMmilan->RDMrome_56', (SELECT id FROM devices WHERE name='RDMmilan'), (SELECT id FROM devices WHERE name='RDMrome'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmilan') AND name='2004' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMrome') AND name='2001' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMrome-RDMbelgrade
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMrome->RDMbelgrade_57', (SELECT id FROM devices WHERE name='RDMrome'), (SELECT id FROM devices WHERE name='RDMbelgrade'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMrome') AND name='2002' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbelgrade') AND name='2001' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'RDMrome->RDMbelgrade_95', (SELECT id FROM devices WHERE name='RDMrome'), (SELECT id FROM devices WHERE name='RDMbelgrade'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMrome') AND name='2004' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbelgrade') AND name='2005' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMrome-RDMathens
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMrome->RDMathens_58', (SELECT id FROM devices WHERE name='RDMrome'), (SELECT id FROM devices WHERE name='RDMathens'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMrome') AND name='2003' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMathens') AND name='2001' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'RDMrome->RDMathens_96', (SELECT id FROM devices WHERE name='RDMrome'), (SELECT id FROM devices WHERE name='RDMathens'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMrome') AND name='2005' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMathens') AND name='2003' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'RDMrome->RDMathens_104', (SELECT id FROM devices WHERE name='RDMrome'), (SELECT id FROM devices WHERE name='RDMathens'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMrome') AND name='2006' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMathens') AND name='2004' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMzurich-RDMmunich
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMzurich->RDMmunich_59', (SELECT id FROM devices WHERE name='RDMzurich'), (SELECT id FROM devices WHERE name='RDMmunich'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMzurich') AND name='2004' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmunich') AND name='2001' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMfrankfurt-RDMhamburg
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMfrankfurt->RDMhamburg_60', (SELECT id FROM devices WHERE name='RDMfrankfurt'), (SELECT id FROM devices WHERE name='RDMhamburg'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMfrankfurt') AND name='2002' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMhamburg') AND name='2002' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMfrankfurt-RDMberlin
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMfrankfurt->RDMberlin_61', (SELECT id FROM devices WHERE name='RDMfrankfurt'), (SELECT id FROM devices WHERE name='RDMberlin'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMfrankfurt') AND name='2003' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMberlin') AND name='2001' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMfrankfurt-RDMprague
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMfrankfurt->RDMprague_62', (SELECT id FROM devices WHERE name='RDMfrankfurt'), (SELECT id FROM devices WHERE name='RDMprague'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMfrankfurt') AND name='2004' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMprague') AND name='2001' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMfrankfurt-RDMmunich
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMfrankfurt->RDMmunich_63', (SELECT id FROM devices WHERE name='RDMfrankfurt'), (SELECT id FROM devices WHERE name='RDMmunich'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMfrankfurt') AND name='2005' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmunich') AND name='2002' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMmunich-RDMprague
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMmunich->RDMprague_64', (SELECT id FROM devices WHERE name='RDMmunich'), (SELECT id FROM devices WHERE name='RDMprague'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmunich') AND name='2003' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMprague') AND name='2002' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'RDMmunich->RDMprague_97', (SELECT id FROM devices WHERE name='RDMmunich'), (SELECT id FROM devices WHERE name='RDMprague'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmunich') AND name='2005' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMprague') AND name='2006' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMmunich-RDMvienna
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMmunich->RDMvienna_65', (SELECT id FROM devices WHERE name='RDMmunich'), (SELECT id FROM devices WHERE name='RDMvienna'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmunich') AND name='2004' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMvienna') AND name='2002' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMhamburg-RDMcopenhagen
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMhamburg->RDMcopenhagen_66', (SELECT id FROM devices WHERE name='RDMhamburg'), (SELECT id FROM devices WHERE name='RDMcopenhagen'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMhamburg') AND name='2003' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMcopenhagen') AND name='2002' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'RDMhamburg->RDMcopenhagen_98', (SELECT id FROM devices WHERE name='RDMhamburg'), (SELECT id FROM devices WHERE name='RDMcopenhagen'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMhamburg') AND name='2005' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMcopenhagen') AND name='2006' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMhamburg-RDMberlin
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMhamburg->RDMberlin_67', (SELECT id FROM devices WHERE name='RDMhamburg'), (SELECT id FROM devices WHERE name='RDMberlin'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMhamburg') AND name='2004' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMberlin') AND name='2002' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMberlin-RDMcopenhagen
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMberlin->RDMcopenhagen_68', (SELECT id FROM devices WHERE name='RDMberlin'), (SELECT id FROM devices WHERE name='RDMcopenhagen'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMberlin') AND name='2003' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMcopenhagen') AND name='2003' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMberlin-RDMstockholm
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMberlin->RDMstockholm_69', (SELECT id FROM devices WHERE name='RDMberlin'), (SELECT id FROM devices WHERE name='RDMstockholm'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMberlin') AND name='2004' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMstockholm') AND name='2001' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMberlin-RDMwarsaw
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMberlin->RDMwarsaw_70', (SELECT id FROM devices WHERE name='RDMberlin'), (SELECT id FROM devices WHERE name='RDMwarsaw'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMberlin') AND name='2005' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMwarsaw') AND name='2001' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMberlin-RDMprague
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMberlin->RDMprague_71', (SELECT id FROM devices WHERE name='RDMberlin'), (SELECT id FROM devices WHERE name='RDMprague'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMberlin') AND name='2006' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMprague') AND name='2003' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMprague-RDMwarsaw
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMprague->RDMwarsaw_72', (SELECT id FROM devices WHERE name='RDMprague'), (SELECT id FROM devices WHERE name='RDMwarsaw'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMprague') AND name='2004' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMwarsaw') AND name='2002' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMprague-RDMvienna
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMprague->RDMvienna_73', (SELECT id FROM devices WHERE name='RDMprague'), (SELECT id FROM devices WHERE name='RDMvienna'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMprague') AND name='2005' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMvienna') AND name='2003' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMvienna-RDMbelgrade
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMvienna->RDMbelgrade_74', (SELECT id FROM devices WHERE name='RDMvienna'), (SELECT id FROM devices WHERE name='RDMbelgrade'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMvienna') AND name='2004' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbelgrade') AND name='2002' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMvienna-RDMbudapest
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMvienna->RDMbudapest_75', (SELECT id FROM devices WHERE name='RDMvienna'), (SELECT id FROM devices WHERE name='RDMbudapest'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMvienna') AND name='2005' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbudapest') AND name='2001' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMcopenhagen-RDMoslo
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMcopenhagen->RDMoslo_76', (SELECT id FROM devices WHERE name='RDMcopenhagen'), (SELECT id FROM devices WHERE name='RDMoslo'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMcopenhagen') AND name='2004' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMoslo') AND name='2001' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMcopenhagen-RDMstockholm
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMcopenhagen->RDMstockholm_77', (SELECT id FROM devices WHERE name='RDMcopenhagen'), (SELECT id FROM devices WHERE name='RDMstockholm'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMcopenhagen') AND name='2005' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMstockholm') AND name='2002' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMoslo-RDMstockholm
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMoslo->RDMstockholm_78', (SELECT id FROM devices WHERE name='RDMoslo'), (SELECT id FROM devices WHERE name='RDMstockholm'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMoslo') AND name='2002' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMstockholm') AND name='2003' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'RDMoslo->RDMstockholm_99', (SELECT id FROM devices WHERE name='RDMoslo'), (SELECT id FROM devices WHERE name='RDMstockholm'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMoslo') AND name='2003' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMstockholm') AND name='2005' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMstockholm-RDMwarsaw
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMstockholm->RDMwarsaw_79', (SELECT id FROM devices WHERE name='RDMstockholm'), (SELECT id FROM devices WHERE name='RDMwarsaw'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMstockholm') AND name='2004' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMwarsaw') AND name='2003' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'RDMstockholm->RDMwarsaw_100', (SELECT id FROM devices WHERE name='RDMstockholm'), (SELECT id FROM devices WHERE name='RDMwarsaw'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMstockholm') AND name='2006' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMwarsaw') AND name='2005' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMwarsaw-RDMbudapest
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMwarsaw->RDMbudapest_80', (SELECT id FROM devices WHERE name='RDMwarsaw'), (SELECT id FROM devices WHERE name='RDMbudapest'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMwarsaw') AND name='2004' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbudapest') AND name='2002' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'RDMwarsaw->RDMbudapest_101', (SELECT id FROM devices WHERE name='RDMwarsaw'), (SELECT id FROM devices WHERE name='RDMbudapest'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMwarsaw') AND name='2006' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbudapest') AND name='2004' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMbudapest-RDMbelgrade
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMbudapest->RDMbelgrade_81', (SELECT id FROM devices WHERE name='RDMbudapest'), (SELECT id FROM devices WHERE name='RDMbelgrade'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbudapest') AND name='2003' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbelgrade') AND name='2003' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'RDMbudapest->RDMbelgrade_102', (SELECT id FROM devices WHERE name='RDMbudapest'), (SELECT id FROM devices WHERE name='RDMbelgrade'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbudapest') AND name='2005' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbelgrade') AND name='2006' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMbelgrade-RDMathens
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMbelgrade->RDMathens_82', (SELECT id FROM devices WHERE name='RDMbelgrade'), (SELECT id FROM devices WHERE name='RDMathens'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbelgrade') AND name='2004' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMathens') AND name='2002' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;
