-- NSF Parallel Topology: Optical Links
-- TP->RDM links use OCH ports on both sides
-- RDM->RDM links use OMS ports on both sides

--- TPcalifornia-RDMcalifornia
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'TPcalifornia->RDMcalifornia_1', (SELECT id FROM devices WHERE name='TPcalifornia'), (SELECT id FROM devices WHERE name='RDMcalifornia'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPcalifornia') AND name='1101' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMcalifornia') AND name='1001' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'TPcalifornia->RDMcalifornia_2', (SELECT id FROM devices WHERE name='TPcalifornia'), (SELECT id FROM devices WHERE name='RDMcalifornia'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPcalifornia') AND name='1102' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMcalifornia') AND name='1002' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'TPcalifornia->RDMcalifornia_3', (SELECT id FROM devices WHERE name='TPcalifornia'), (SELECT id FROM devices WHERE name='RDMcalifornia'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPcalifornia') AND name='1103' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMcalifornia') AND name='1003' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'TPcalifornia->RDMcalifornia_4', (SELECT id FROM devices WHERE name='TPcalifornia'), (SELECT id FROM devices WHERE name='RDMcalifornia'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPcalifornia') AND name='1104' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMcalifornia') AND name='1004' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- TPtexas-RDMtexas
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'TPtexas->RDMtexas_4', (SELECT id FROM devices WHERE name='TPtexas'), (SELECT id FROM devices WHERE name='RDMtexas'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPtexas') AND name='1101' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMtexas') AND name='1001' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'TPtexas->RDMtexas_5', (SELECT id FROM devices WHERE name='TPtexas'), (SELECT id FROM devices WHERE name='RDMtexas'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPtexas') AND name='1102' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMtexas') AND name='1002' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'TPtexas->RDMtexas_6', (SELECT id FROM devices WHERE name='TPtexas'), (SELECT id FROM devices WHERE name='RDMtexas'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPtexas') AND name='1103' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMtexas') AND name='1003' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'TPtexas->RDMtexas_100', (SELECT id FROM devices WHERE name='TPtexas'), (SELECT id FROM devices WHERE name='RDMtexas'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPtexas') AND name='1104' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMtexas') AND name='1004' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- TPnewyork-RDMnewyork
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'TPnewyork->RDMnewyork_7', (SELECT id FROM devices WHERE name='TPnewyork'), (SELECT id FROM devices WHERE name='RDMnewyork'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPnewyork') AND name='1101' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMnewyork') AND name='1001' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'TPnewyork->RDMnewyork_8', (SELECT id FROM devices WHERE name='TPnewyork'), (SELECT id FROM devices WHERE name='RDMnewyork'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPnewyork') AND name='1102' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMnewyork') AND name='1002' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'TPnewyork->RDMnewyork_9', (SELECT id FROM devices WHERE name='TPnewyork'), (SELECT id FROM devices WHERE name='RDMnewyork'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPnewyork') AND name='1103' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMnewyork') AND name='1003' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'TPnewyork->RDMnewyork_101', (SELECT id FROM devices WHERE name='TPnewyork'), (SELECT id FROM devices WHERE name='RDMnewyork'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPnewyork') AND name='1104' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMnewyork') AND name='1004' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- TPmissouri-RDMmissouri
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'TPmissouri->RDMmissouri_10', (SELECT id FROM devices WHERE name='TPmissouri'), (SELECT id FROM devices WHERE name='RDMmissouri'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPmissouri') AND name='1101' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmissouri') AND name='1001' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'TPmissouri->RDMmissouri_11', (SELECT id FROM devices WHERE name='TPmissouri'), (SELECT id FROM devices WHERE name='RDMmissouri'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPmissouri') AND name='1102' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmissouri') AND name='1002' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'TPmissouri->RDMmissouri_12', (SELECT id FROM devices WHERE name='TPmissouri'), (SELECT id FROM devices WHERE name='RDMmissouri'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPmissouri') AND name='1103' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmissouri') AND name='1003' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'TPmissouri->RDMmissouri_102', (SELECT id FROM devices WHERE name='TPmissouri'), (SELECT id FROM devices WHERE name='RDMmissouri'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPmissouri') AND name='1104' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmissouri') AND name='1004' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- TPillinois-RDMillinois
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'TPillinois->RDMillinois_13', (SELECT id FROM devices WHERE name='TPillinois'), (SELECT id FROM devices WHERE name='RDMillinois'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPillinois') AND name='1101' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMillinois') AND name='1001' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'TPillinois->RDMillinois_14', (SELECT id FROM devices WHERE name='TPillinois'), (SELECT id FROM devices WHERE name='RDMillinois'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPillinois') AND name='1102' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMillinois') AND name='1002' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'TPillinois->RDMillinois_15', (SELECT id FROM devices WHERE name='TPillinois'), (SELECT id FROM devices WHERE name='RDMillinois'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPillinois') AND name='1103' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMillinois') AND name='1003' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'TPillinois->RDMillinois_103', (SELECT id FROM devices WHERE name='TPillinois'), (SELECT id FROM devices WHERE name='RDMillinois'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPillinois') AND name='1104' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMillinois') AND name='1004' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;


--- TPcolorado-RDMcolorado
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'TPcolorado->RDMcolorado_1', (SELECT id FROM devices WHERE name='TPcolorado'), (SELECT id FROM devices WHERE name='RDMcolorado'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPcolorado') AND name='1101' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMcolorado') AND name='1001' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'TPcolorado->RDMcolorado_2', (SELECT id FROM devices WHERE name='TPcolorado'), (SELECT id FROM devices WHERE name='RDMcolorado'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPcolorado') AND name='1102' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMcolorado') AND name='1002' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'TPcolorado->RDMcolorado_3', (SELECT id FROM devices WHERE name='TPcolorado'), (SELECT id FROM devices WHERE name='RDMcolorado'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPcolorado') AND name='1103' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMcolorado') AND name='1003' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'TPcolorado->RDMcolorado_104', (SELECT id FROM devices WHERE name='TPcolorado'), (SELECT id FROM devices WHERE name='RDMcolorado'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPcolorado') AND name='1104' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMcolorado') AND name='1004' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- TPflorida-RDMflorida
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'TPflorida->RDMflorida_1', (SELECT id FROM devices WHERE name='TPflorida'), (SELECT id FROM devices WHERE name='RDMflorida'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPflorida') AND name='1101' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMflorida') AND name='1001' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'TPflorida->RDMflorida_2', (SELECT id FROM devices WHERE name='TPflorida'), (SELECT id FROM devices WHERE name='RDMflorida'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPflorida') AND name='1102' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMflorida') AND name='1002' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'TPflorida->RDMflorida_3', (SELECT id FROM devices WHERE name='TPflorida'), (SELECT id FROM devices WHERE name='RDMflorida'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPflorida') AND name='1103' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMflorida') AND name='1003' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'TPflorida->RDMflorida_105', (SELECT id FROM devices WHERE name='TPflorida'), (SELECT id FROM devices WHERE name='RDMflorida'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPflorida') AND name='1104' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMflorida') AND name='1004' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- TPmaryland-RDMmaryland
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'TPmaryland->RDMmaryland_1', (SELECT id FROM devices WHERE name='TPmaryland'), (SELECT id FROM devices WHERE name='RDMmaryland'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPmaryland') AND name='1101' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmaryland') AND name='1001' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'TPmaryland->RDMmaryland_2', (SELECT id FROM devices WHERE name='TPmaryland'), (SELECT id FROM devices WHERE name='RDMmaryland'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPmaryland') AND name='1102' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmaryland') AND name='1002' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'TPmaryland->RDMmaryland_3', (SELECT id FROM devices WHERE name='TPmaryland'), (SELECT id FROM devices WHERE name='RDMmaryland'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPmaryland') AND name='1103' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmaryland') AND name='1003' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'TPmaryland->RDMmaryland_106', (SELECT id FROM devices WHERE name='TPmaryland'), (SELECT id FROM devices WHERE name='RDMmaryland'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPmaryland') AND name='1104' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmaryland') AND name='1004' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- TPvirginia-RDMvirginia
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'TPvirginia->RDMvirginia_1', (SELECT id FROM devices WHERE name='TPvirginia'), (SELECT id FROM devices WHERE name='RDMvirginia'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPvirginia') AND name='1101' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMvirginia') AND name='1001' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'TPvirginia->RDMvirginia_2', (SELECT id FROM devices WHERE name='TPvirginia'), (SELECT id FROM devices WHERE name='RDMvirginia'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPvirginia') AND name='1102' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMvirginia') AND name='1002' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'TPvirginia->RDMvirginia_3', (SELECT id FROM devices WHERE name='TPvirginia'), (SELECT id FROM devices WHERE name='RDMvirginia'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPvirginia') AND name='1103' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMvirginia') AND name='1003' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'TPvirginia->RDMvirginia_107', (SELECT id FROM devices WHERE name='TPvirginia'), (SELECT id FROM devices WHERE name='RDMvirginia'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPvirginia') AND name='1104' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMvirginia') AND name='1004' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMcalifornia-RDMwashington
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMcalifornia->RDMwashington_16', (SELECT id FROM devices WHERE name='RDMcalifornia'), (SELECT id FROM devices WHERE name='RDMwashington'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMcalifornia') AND name='2001' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMwashington') AND name='2001' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'RDMcalifornia->RDMwashington_44', (SELECT id FROM devices WHERE name='RDMcalifornia'), (SELECT id FROM devices WHERE name='RDMwashington'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMcalifornia') AND name='2003' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMwashington') AND name='2004' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMcalifornia-RDMgeorgia
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMcalifornia->RDMgeorgia_17', (SELECT id FROM devices WHERE name='RDMcalifornia'), (SELECT id FROM devices WHERE name='RDMgeorgia'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMcalifornia') AND name='2002' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMgeorgia') AND name='2001' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'RDMcalifornia->RDMgeorgia_45', (SELECT id FROM devices WHERE name='RDMcalifornia'), (SELECT id FROM devices WHERE name='RDMgeorgia'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMcalifornia') AND name='2004' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMgeorgia') AND name='2006' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMwashington-RDMtexas
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMwashington->RDMtexas_18', (SELECT id FROM devices WHERE name='RDMwashington'), (SELECT id FROM devices WHERE name='RDMtexas'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMwashington') AND name='2002' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMtexas') AND name='2001' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'RDMwashington->RDMtexas_46', (SELECT id FROM devices WHERE name='RDMwashington'), (SELECT id FROM devices WHERE name='RDMtexas'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMwashington') AND name='2005' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMtexas') AND name='2003' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMwashington-RDMnewyork
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMwashington->RDMnewyork_19', (SELECT id FROM devices WHERE name='RDMwashington'), (SELECT id FROM devices WHERE name='RDMnewyork'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMwashington') AND name='2003' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMnewyork') AND name='2001' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'RDMwashington->RDMnewyork_47', (SELECT id FROM devices WHERE name='RDMwashington'), (SELECT id FROM devices WHERE name='RDMnewyork'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMwashington') AND name='2006' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMnewyork') AND name='2003' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMtexas-RDMgeorgia
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMtexas->RDMgeorgia_20', (SELECT id FROM devices WHERE name='RDMtexas'), (SELECT id FROM devices WHERE name='RDMgeorgia'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMtexas') AND name='2002' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMgeorgia') AND name='2002' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMnewyork-RDMvirginia
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMnewyork->RDMvirginia_21', (SELECT id FROM devices WHERE name='RDMnewyork'), (SELECT id FROM devices WHERE name='RDMvirginia'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMnewyork') AND name='2002' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMvirginia') AND name='2001' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'RDMnewyork->RDMvirginia_48', (SELECT id FROM devices WHERE name='RDMnewyork'), (SELECT id FROM devices WHERE name='RDMvirginia'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMnewyork') AND name='2004' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMvirginia') AND name='2006' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMflorida-RDMgeorgia
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMflorida->RDMgeorgia_22', (SELECT id FROM devices WHERE name='RDMflorida'), (SELECT id FROM devices WHERE name='RDMgeorgia'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMflorida') AND name='2001' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMgeorgia') AND name='2003' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMflorida-RDMvirginia
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMflorida->RDMvirginia_23', (SELECT id FROM devices WHERE name='RDMflorida'), (SELECT id FROM devices WHERE name='RDMvirginia'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMflorida') AND name='2002' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMvirginia') AND name='2002' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMgeorgia-RDMmichigan
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMgeorgia->RDMmichigan_24', (SELECT id FROM devices WHERE name='RDMgeorgia'), (SELECT id FROM devices WHERE name='RDMmichigan'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMgeorgia') AND name='2004' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmichigan') AND name='2001' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMgeorgia-RDMarizona
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMgeorgia->RDMarizona_25', (SELECT id FROM devices WHERE name='RDMgeorgia'), (SELECT id FROM devices WHERE name='RDMarizona'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMgeorgia') AND name='2005' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMarizona') AND name='2001' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMvirginia-RDMmichigan
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMvirginia->RDMmichigan_26', (SELECT id FROM devices WHERE name='RDMvirginia'), (SELECT id FROM devices WHERE name='RDMmichigan'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMvirginia') AND name='2003' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmichigan') AND name='2002' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMvirginia-RDMohio
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMvirginia->RDMohio_27', (SELECT id FROM devices WHERE name='RDMvirginia'), (SELECT id FROM devices WHERE name='RDMohio'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMvirginia') AND name='2004' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMohio') AND name='2001' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMvirginia-RDMtennessee
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMvirginia->RDMtennessee_28', (SELECT id FROM devices WHERE name='RDMvirginia'), (SELECT id FROM devices WHERE name='RDMtennessee'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMvirginia') AND name='2005' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMtennessee') AND name='2001' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMmichigan-RDMillinois
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMmichigan->RDMillinois_29', (SELECT id FROM devices WHERE name='RDMmichigan'), (SELECT id FROM devices WHERE name='RDMillinois'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmichigan') AND name='2003' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMillinois') AND name='2001' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'RDMmichigan->RDMillinois_49', (SELECT id FROM devices WHERE name='RDMmichigan'), (SELECT id FROM devices WHERE name='RDMillinois'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmichigan') AND name='2004' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMillinois') AND name='2003' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'RDMmichigan->RDMillinois_58', (SELECT id FROM devices WHERE name='RDMmichigan'), (SELECT id FROM devices WHERE name='RDMillinois'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmichigan') AND name='2005' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMillinois') AND name='2005' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'RDMmichigan->RDMillinois_60', (SELECT id FROM devices WHERE name='RDMmichigan'), (SELECT id FROM devices WHERE name='RDMillinois'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmichigan') AND name='2006' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMillinois') AND name='2006' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMillinois-RDMpennsylvania
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMillinois->RDMpennsylvania_30', (SELECT id FROM devices WHERE name='RDMillinois'), (SELECT id FROM devices WHERE name='RDMpennsylvania'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMillinois') AND name='2002' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMpennsylvania') AND name='2001' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'RDMillinois->RDMpennsylvania_50', (SELECT id FROM devices WHERE name='RDMillinois'), (SELECT id FROM devices WHERE name='RDMpennsylvania'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMillinois') AND name='2004' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMpennsylvania') AND name='2004' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMpennsylvania-RDMarizona
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMpennsylvania->RDMarizona_31', (SELECT id FROM devices WHERE name='RDMpennsylvania'), (SELECT id FROM devices WHERE name='RDMarizona'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMpennsylvania') AND name='2002' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMarizona') AND name='2002' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'RDMpennsylvania->RDMarizona_51', (SELECT id FROM devices WHERE name='RDMpennsylvania'), (SELECT id FROM devices WHERE name='RDMarizona'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMpennsylvania') AND name='2005' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMarizona') AND name='2005' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMpennsylvania-RDMmassachusetts
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMpennsylvania->RDMmassachusetts_32', (SELECT id FROM devices WHERE name='RDMpennsylvania'), (SELECT id FROM devices WHERE name='RDMmassachusetts'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMpennsylvania') AND name='2003' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmassachusetts') AND name='2001' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'RDMpennsylvania->RDMmassachusetts_52', (SELECT id FROM devices WHERE name='RDMpennsylvania'), (SELECT id FROM devices WHERE name='RDMmassachusetts'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMpennsylvania') AND name='2006' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmassachusetts') AND name='2005' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMohio-RDMmassachusetts
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMohio->RDMmassachusetts_33', (SELECT id FROM devices WHERE name='RDMohio'), (SELECT id FROM devices WHERE name='RDMmassachusetts'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMohio') AND name='2002' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmassachusetts') AND name='2002' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'RDMohio->RDMmassachusetts_53', (SELECT id FROM devices WHERE name='RDMohio'), (SELECT id FROM devices WHERE name='RDMmassachusetts'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMohio') AND name='2004' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmassachusetts') AND name='2006' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMohio-RDMtennessee
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMohio->RDMtennessee_34', (SELECT id FROM devices WHERE name='RDMohio'), (SELECT id FROM devices WHERE name='RDMtennessee'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMohio') AND name='2003' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMtennessee') AND name='2002' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'RDMohio->RDMtennessee_54', (SELECT id FROM devices WHERE name='RDMohio'), (SELECT id FROM devices WHERE name='RDMtennessee'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMohio') AND name='2005' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMtennessee') AND name='2006' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMarizona-RDMmaryland
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMarizona->RDMmaryland_35', (SELECT id FROM devices WHERE name='RDMarizona'), (SELECT id FROM devices WHERE name='RDMmaryland'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMarizona') AND name='2003' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmaryland') AND name='2001' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'RDMarizona->RDMmaryland_55', (SELECT id FROM devices WHERE name='RDMarizona'), (SELECT id FROM devices WHERE name='RDMmaryland'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMarizona') AND name='2006' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmaryland') AND name='2004' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMarizona-RDMcolorado
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMarizona->RDMcolorado_36', (SELECT id FROM devices WHERE name='RDMarizona'), (SELECT id FROM devices WHERE name='RDMcolorado'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMarizona') AND name='2004' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMcolorado') AND name='2001' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMmassachusetts-RDMmaryland
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMmassachusetts->RDMmaryland_37', (SELECT id FROM devices WHERE name='RDMmassachusetts'), (SELECT id FROM devices WHERE name='RDMmaryland'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmassachusetts') AND name='2003' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmaryland') AND name='2002' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMmassachusetts-RDMindiana
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMmassachusetts->RDMindiana_38', (SELECT id FROM devices WHERE name='RDMmassachusetts'), (SELECT id FROM devices WHERE name='RDMindiana'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmassachusetts') AND name='2004' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMindiana') AND name='2001' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMtennessee-RDMmissouri
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMtennessee->RDMmissouri_39', (SELECT id FROM devices WHERE name='RDMtennessee'), (SELECT id FROM devices WHERE name='RDMmissouri'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMtennessee') AND name='2003' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmissouri') AND name='2001' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMtennessee-RDMindiana
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMtennessee->RDMindiana_40', (SELECT id FROM devices WHERE name='RDMtennessee'), (SELECT id FROM devices WHERE name='RDMindiana'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMtennessee') AND name='2004' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMindiana') AND name='2002' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMtennessee-RDMcolorado
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMtennessee->RDMcolorado_41', (SELECT id FROM devices WHERE name='RDMtennessee'), (SELECT id FROM devices WHERE name='RDMcolorado'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMtennessee') AND name='2005' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMcolorado') AND name='2002' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMmaryland-RDMmissouri
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMmaryland->RDMmissouri_42', (SELECT id FROM devices WHERE name='RDMmaryland'), (SELECT id FROM devices WHERE name='RDMmissouri'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmaryland') AND name='2003' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmissouri') AND name='2002' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'RDMmaryland->RDMmissouri_56', (SELECT id FROM devices WHERE name='RDMmaryland'), (SELECT id FROM devices WHERE name='RDMmissouri'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmaryland') AND name='2005' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmissouri') AND name='2004' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'RDMmaryland->RDMmissouri_59', (SELECT id FROM devices WHERE name='RDMmaryland'), (SELECT id FROM devices WHERE name='RDMmissouri'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmaryland') AND name='2006' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmissouri') AND name='2006' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMmissouri-RDMindiana
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMmissouri->RDMindiana_43', (SELECT id FROM devices WHERE name='RDMmissouri'), (SELECT id FROM devices WHERE name='RDMindiana'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmissouri') AND name='2003' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMindiana') AND name='2003' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'RDMmissouri->RDMindiana_57', (SELECT id FROM devices WHERE name='RDMmissouri'), (SELECT id FROM devices WHERE name='RDMindiana'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmissouri') AND name='2005' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMindiana') AND name='2004' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- TPindiana-RDMindiana
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'TPindiana->RDMindiana_61', (SELECT id FROM devices WHERE name='TPindiana'), (SELECT id FROM devices WHERE name='RDMindiana'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPindiana') AND name='1101' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMindiana') AND name='1001' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'TPindiana->RDMindiana_62', (SELECT id FROM devices WHERE name='TPindiana'), (SELECT id FROM devices WHERE name='RDMindiana'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPindiana') AND name='1102' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMindiana') AND name='1002' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'TPindiana->RDMindiana_63', (SELECT id FROM devices WHERE name='TPindiana'), (SELECT id FROM devices WHERE name='RDMindiana'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPindiana') AND name='1103' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMindiana') AND name='1003' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'TPindiana->RDMindiana_108', (SELECT id FROM devices WHERE name='TPindiana'), (SELECT id FROM devices WHERE name='RDMindiana'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPindiana') AND name='1104' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMindiana') AND name='1004' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- TPohio-RDMohio
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'TPohio->RDMohio_64', (SELECT id FROM devices WHERE name='TPohio'), (SELECT id FROM devices WHERE name='RDMohio'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPohio') AND name='1101' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMohio') AND name='1001' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'TPohio->RDMohio_65', (SELECT id FROM devices WHERE name='TPohio'), (SELECT id FROM devices WHERE name='RDMohio'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPohio') AND name='1102' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMohio') AND name='1002' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'TPohio->RDMohio_66', (SELECT id FROM devices WHERE name='TPohio'), (SELECT id FROM devices WHERE name='RDMohio'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPohio') AND name='1103' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMohio') AND name='1003' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'TPohio->RDMohio_109', (SELECT id FROM devices WHERE name='TPohio'), (SELECT id FROM devices WHERE name='RDMohio'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPohio') AND name='1104' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMohio') AND name='1004' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- TPmassachusetts-RDMmassachusetts
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'TPmassachusetts->RDMmassachusetts_67', (SELECT id FROM devices WHERE name='TPmassachusetts'), (SELECT id FROM devices WHERE name='RDMmassachusetts'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPmassachusetts') AND name='1101' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmassachusetts') AND name='1001' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'TPmassachusetts->RDMmassachusetts_68', (SELECT id FROM devices WHERE name='TPmassachusetts'), (SELECT id FROM devices WHERE name='RDMmassachusetts'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPmassachusetts') AND name='1102' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmassachusetts') AND name='1002' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'TPmassachusetts->RDMmassachusetts_69', (SELECT id FROM devices WHERE name='TPmassachusetts'), (SELECT id FROM devices WHERE name='RDMmassachusetts'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPmassachusetts') AND name='1103' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmassachusetts') AND name='1003' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'TPmassachusetts->RDMmassachusetts_110', (SELECT id FROM devices WHERE name='TPmassachusetts'), (SELECT id FROM devices WHERE name='RDMmassachusetts'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPmassachusetts') AND name='1104' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmassachusetts') AND name='1004' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- TParizona-RDMarizona
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'TParizona->RDMarizona_70', (SELECT id FROM devices WHERE name='TParizona'), (SELECT id FROM devices WHERE name='RDMarizona'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TParizona') AND name='1101' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMarizona') AND name='1001' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'TParizona->RDMarizona_71', (SELECT id FROM devices WHERE name='TParizona'), (SELECT id FROM devices WHERE name='RDMarizona'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TParizona') AND name='1102' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMarizona') AND name='1002' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'TParizona->RDMarizona_72', (SELECT id FROM devices WHERE name='TParizona'), (SELECT id FROM devices WHERE name='RDMarizona'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TParizona') AND name='1103' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMarizona') AND name='1003' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'TParizona->RDMarizona_111', (SELECT id FROM devices WHERE name='TParizona'), (SELECT id FROM devices WHERE name='RDMarizona'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TParizona') AND name='1104' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMarizona') AND name='1004' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- TPwashington-RDMwashington
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'TPwashington->RDMwashington_73', (SELECT id FROM devices WHERE name='TPwashington'), (SELECT id FROM devices WHERE name='RDMwashington'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPwashington') AND name='1101' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMwashington') AND name='1001' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'TPwashington->RDMwashington_74', (SELECT id FROM devices WHERE name='TPwashington'), (SELECT id FROM devices WHERE name='RDMwashington'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPwashington') AND name='1102' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMwashington') AND name='1002' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'TPwashington->RDMwashington_75', (SELECT id FROM devices WHERE name='TPwashington'), (SELECT id FROM devices WHERE name='RDMwashington'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPwashington') AND name='1103' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMwashington') AND name='1003' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'TPwashington->RDMwashington_112', (SELECT id FROM devices WHERE name='TPwashington'), (SELECT id FROM devices WHERE name='RDMwashington'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPwashington') AND name='1104' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMwashington') AND name='1004' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- TPgeorgia-RDMgeorgia
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'TPgeorgia->RDMgeorgia_76', (SELECT id FROM devices WHERE name='TPgeorgia'), (SELECT id FROM devices WHERE name='RDMgeorgia'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPgeorgia') AND name='1101' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMgeorgia') AND name='1001' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'TPgeorgia->RDMgeorgia_77', (SELECT id FROM devices WHERE name='TPgeorgia'), (SELECT id FROM devices WHERE name='RDMgeorgia'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPgeorgia') AND name='1102' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMgeorgia') AND name='1002' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'TPgeorgia->RDMgeorgia_78', (SELECT id FROM devices WHERE name='TPgeorgia'), (SELECT id FROM devices WHERE name='RDMgeorgia'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPgeorgia') AND name='1103' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMgeorgia') AND name='1003' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'TPgeorgia->RDMgeorgia_113', (SELECT id FROM devices WHERE name='TPgeorgia'), (SELECT id FROM devices WHERE name='RDMgeorgia'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPgeorgia') AND name='1104' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMgeorgia') AND name='1004' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- TPtennessee-RDMtennessee
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'TPtennessee->RDMtennessee_79', (SELECT id FROM devices WHERE name='TPtennessee'), (SELECT id FROM devices WHERE name='RDMtennessee'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPtennessee') AND name='1101' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMtennessee') AND name='1001' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'TPtennessee->RDMtennessee_80', (SELECT id FROM devices WHERE name='TPtennessee'), (SELECT id FROM devices WHERE name='RDMtennessee'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPtennessee') AND name='1102' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMtennessee') AND name='1002' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'TPtennessee->RDMtennessee_81', (SELECT id FROM devices WHERE name='TPtennessee'), (SELECT id FROM devices WHERE name='RDMtennessee'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPtennessee') AND name='1103' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMtennessee') AND name='1003' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'TPtennessee->RDMtennessee_114', (SELECT id FROM devices WHERE name='TPtennessee'), (SELECT id FROM devices WHERE name='RDMtennessee'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPtennessee') AND name='1104' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMtennessee') AND name='1004' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- TPpennsylvania-RDMpennsylvania
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'TPpennsylvania->RDMpennsylvania_82', (SELECT id FROM devices WHERE name='TPpennsylvania'), (SELECT id FROM devices WHERE name='RDMpennsylvania'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPpennsylvania') AND name='1101' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMpennsylvania') AND name='1001' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'TPpennsylvania->RDMpennsylvania_83', (SELECT id FROM devices WHERE name='TPpennsylvania'), (SELECT id FROM devices WHERE name='RDMpennsylvania'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPpennsylvania') AND name='1102' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMpennsylvania') AND name='1002' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'TPpennsylvania->RDMpennsylvania_84', (SELECT id FROM devices WHERE name='TPpennsylvania'), (SELECT id FROM devices WHERE name='RDMpennsylvania'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPpennsylvania') AND name='1103' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMpennsylvania') AND name='1003' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'TPpennsylvania->RDMpennsylvania_115', (SELECT id FROM devices WHERE name='TPpennsylvania'), (SELECT id FROM devices WHERE name='RDMpennsylvania'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPpennsylvania') AND name='1104' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMpennsylvania') AND name='1004' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- TPmichigan-RDMmichigan
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'TPmichigan->RDMmichigan_85', (SELECT id FROM devices WHERE name='TPmichigan'), (SELECT id FROM devices WHERE name='RDMmichigan'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPmichigan') AND name='1101' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmichigan') AND name='1001' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'TPmichigan->RDMmichigan_86', (SELECT id FROM devices WHERE name='TPmichigan'), (SELECT id FROM devices WHERE name='RDMmichigan'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPmichigan') AND name='1102' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmichigan') AND name='1002' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'TPmichigan->RDMmichigan_87', (SELECT id FROM devices WHERE name='TPmichigan'), (SELECT id FROM devices WHERE name='RDMmichigan'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPmichigan') AND name='1103' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmichigan') AND name='1003' LIMIT 1), NOW(), NOW()),
	(gen_random_uuid(), 'TPmichigan->RDMmichigan_116', (SELECT id FROM devices WHERE name='TPmichigan'), (SELECT id FROM devices WHERE name='RDMmichigan'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPmichigan') AND name='1104' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmichigan') AND name='1004' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;
