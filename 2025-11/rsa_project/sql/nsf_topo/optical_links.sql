-- NSF Parallel Topology: Optical Links
-- TP->RDM links use OCH ports on both sides
-- RDM->RDM links use OMS ports on both sides

--- TPcalifornia-RDMcalifornia
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'TPcalifornia->RDMcalifornia_1', (SELECT id FROM devices WHERE name='TPcalifornia'), (SELECT id FROM devices WHERE name='RDMcalifornia'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPcalifornia') AND name='1101' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMcalifornia') AND name='1001' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'TPcalifornia->RDMcalifornia_2', (SELECT id FROM devices WHERE name='TPcalifornia'), (SELECT id FROM devices WHERE name='RDMcalifornia'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPcalifornia') AND name='1102' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMcalifornia') AND name='1002' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'TPcalifornia->RDMcalifornia_3', (SELECT id FROM devices WHERE name='TPcalifornia'), (SELECT id FROM devices WHERE name='RDMcalifornia'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPcalifornia') AND name='1103' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMcalifornia') AND name='1003' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- TPtexas-RDMtexas
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'TPtexas->RDMtexas_4', (SELECT id FROM devices WHERE name='TPtexas'), (SELECT id FROM devices WHERE name='RDMtexas'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPtexas') AND name='1101' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMtexas') AND name='1001' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'TPtexas->RDMtexas_5', (SELECT id FROM devices WHERE name='TPtexas'), (SELECT id FROM devices WHERE name='RDMtexas'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPtexas') AND name='1102' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMtexas') AND name='1002' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'TPtexas->RDMtexas_6', (SELECT id FROM devices WHERE name='TPtexas'), (SELECT id FROM devices WHERE name='RDMtexas'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPtexas') AND name='1103' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMtexas') AND name='1003' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- TPnewyork-RDMnewyork
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'TPnewyork->RDMnewyork_7', (SELECT id FROM devices WHERE name='TPnewyork'), (SELECT id FROM devices WHERE name='RDMnewyork'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPnewyork') AND name='1101' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMnewyork') AND name='1001' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'TPnewyork->RDMnewyork_8', (SELECT id FROM devices WHERE name='TPnewyork'), (SELECT id FROM devices WHERE name='RDMnewyork'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPnewyork') AND name='1102' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMnewyork') AND name='1002' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'TPnewyork->RDMnewyork_9', (SELECT id FROM devices WHERE name='TPnewyork'), (SELECT id FROM devices WHERE name='RDMnewyork'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPnewyork') AND name='1103' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMnewyork') AND name='1003' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- TPmissouri-RDMmissouri
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'TPmissouri->RDMmissouri_10', (SELECT id FROM devices WHERE name='TPmissouri'), (SELECT id FROM devices WHERE name='RDMmissouri'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPmissouri') AND name='1101' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmissouri') AND name='1001' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'TPmissouri->RDMmissouri_11', (SELECT id FROM devices WHERE name='TPmissouri'), (SELECT id FROM devices WHERE name='RDMmissouri'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPmissouri') AND name='1102' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmissouri') AND name='1002' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'TPmissouri->RDMmissouri_12', (SELECT id FROM devices WHERE name='TPmissouri'), (SELECT id FROM devices WHERE name='RDMmissouri'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPmissouri') AND name='1103' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmissouri') AND name='1003' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- TPillinois-RDMillinois
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'TPillinois->RDMillinois_13', (SELECT id FROM devices WHERE name='TPillinois'), (SELECT id FROM devices WHERE name='RDMillinois'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPillinois') AND name='1101' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMillinois') AND name='1001' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'TPillinois->RDMillinois_14', (SELECT id FROM devices WHERE name='TPillinois'), (SELECT id FROM devices WHERE name='RDMillinois'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPillinois') AND name='1102' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMillinois') AND name='1002' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'TPillinois->RDMillinois_15', (SELECT id FROM devices WHERE name='TPillinois'), (SELECT id FROM devices WHERE name='RDMillinois'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='TPillinois') AND name='1103' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMillinois') AND name='1003' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMcalifornia-RDMwashington
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMcalifornia->RDMwashington_16', (SELECT id FROM devices WHERE name='RDMcalifornia'), (SELECT id FROM devices WHERE name='RDMwashington'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMcalifornia') AND name='2001' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMwashington') AND name='2001' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'RDMcalifornia->RDMwashington_44', (SELECT id FROM devices WHERE name='RDMcalifornia'), (SELECT id FROM devices WHERE name='RDMwashington'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMcalifornia') AND name='2003' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMwashington') AND name='2004' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMcalifornia-RDMgeorgia
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMcalifornia->RDMgeorgia_17', (SELECT id FROM devices WHERE name='RDMcalifornia'), (SELECT id FROM devices WHERE name='RDMgeorgia'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMcalifornia') AND name='2002' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMgeorgia') AND name='2001' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'RDMcalifornia->RDMgeorgia_45', (SELECT id FROM devices WHERE name='RDMcalifornia'), (SELECT id FROM devices WHERE name='RDMgeorgia'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMcalifornia') AND name='2004' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMgeorgia') AND name='2006' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMwashington-RDMtexas
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMwashington->RDMtexas_18', (SELECT id FROM devices WHERE name='RDMwashington'), (SELECT id FROM devices WHERE name='RDMtexas'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMwashington') AND name='2002' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMtexas') AND name='2001' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'RDMwashington->RDMtexas_46', (SELECT id FROM devices WHERE name='RDMwashington'), (SELECT id FROM devices WHERE name='RDMtexas'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMwashington') AND name='2005' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMtexas') AND name='2003' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMwashington-RDMnewyork
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMwashington->RDMnewyork_19', (SELECT id FROM devices WHERE name='RDMwashington'), (SELECT id FROM devices WHERE name='RDMnewyork'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMwashington') AND name='2003' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMnewyork') AND name='2001' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'RDMwashington->RDMnewyork_47', (SELECT id FROM devices WHERE name='RDMwashington'), (SELECT id FROM devices WHERE name='RDMnewyork'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMwashington') AND name='2006' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMnewyork') AND name='2003' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMtexas-RDMgeorgia
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMtexas->RDMgeorgia_20', (SELECT id FROM devices WHERE name='RDMtexas'), (SELECT id FROM devices WHERE name='RDMgeorgia'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMtexas') AND name='2002' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMgeorgia') AND name='2002' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMnewyork-RDMvirginia
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMnewyork->RDMvirginia_21', (SELECT id FROM devices WHERE name='RDMnewyork'), (SELECT id FROM devices WHERE name='RDMvirginia'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMnewyork') AND name='2002' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMvirginia') AND name='2001' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'RDMnewyork->RDMvirginia_48', (SELECT id FROM devices WHERE name='RDMnewyork'), (SELECT id FROM devices WHERE name='RDMvirginia'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMnewyork') AND name='2004' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMvirginia') AND name='2006' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMflorida-RDMgeorgia
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMflorida->RDMgeorgia_22', (SELECT id FROM devices WHERE name='RDMflorida'), (SELECT id FROM devices WHERE name='RDMgeorgia'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMflorida') AND name='2001' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMgeorgia') AND name='2003' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMflorida-RDMvirginia
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMflorida->RDMvirginia_23', (SELECT id FROM devices WHERE name='RDMflorida'), (SELECT id FROM devices WHERE name='RDMvirginia'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMflorida') AND name='2002' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMvirginia') AND name='2002' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMgeorgia-RDMmichigan
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMgeorgia->RDMmichigan_24', (SELECT id FROM devices WHERE name='RDMgeorgia'), (SELECT id FROM devices WHERE name='RDMmichigan'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMgeorgia') AND name='2004' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmichigan') AND name='2001' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMgeorgia-RDMarizona
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMgeorgia->RDMarizona_25', (SELECT id FROM devices WHERE name='RDMgeorgia'), (SELECT id FROM devices WHERE name='RDMarizona'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMgeorgia') AND name='2005' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMarizona') AND name='2001' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMvirginia-RDMmichigan
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMvirginia->RDMmichigan_26', (SELECT id FROM devices WHERE name='RDMvirginia'), (SELECT id FROM devices WHERE name='RDMmichigan'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMvirginia') AND name='2003' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmichigan') AND name='2002' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMvirginia-RDMohio
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMvirginia->RDMohio_27', (SELECT id FROM devices WHERE name='RDMvirginia'), (SELECT id FROM devices WHERE name='RDMohio'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMvirginia') AND name='2004' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMohio') AND name='2001' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMvirginia-RDMtennessee
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMvirginia->RDMtennessee_28', (SELECT id FROM devices WHERE name='RDMvirginia'), (SELECT id FROM devices WHERE name='RDMtennessee'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMvirginia') AND name='2005' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMtennessee') AND name='2001' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMmichigan-RDMillinois
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMmichigan->RDMillinois_29', (SELECT id FROM devices WHERE name='RDMmichigan'), (SELECT id FROM devices WHERE name='RDMillinois'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmichigan') AND name='2003' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMillinois') AND name='2001' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'RDMmichigan->RDMillinois_49', (SELECT id FROM devices WHERE name='RDMmichigan'), (SELECT id FROM devices WHERE name='RDMillinois'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmichigan') AND name='2004' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMillinois') AND name='2003' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'RDMmichigan->RDMillinois_58', (SELECT id FROM devices WHERE name='RDMmichigan'), (SELECT id FROM devices WHERE name='RDMillinois'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmichigan') AND name='2005' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMillinois') AND name='2005' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'RDMmichigan->RDMillinois_60', (SELECT id FROM devices WHERE name='RDMmichigan'), (SELECT id FROM devices WHERE name='RDMillinois'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmichigan') AND name='2006' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMillinois') AND name='2006' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMillinois-RDMpennsylvania
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMillinois->RDMpennsylvania_30', (SELECT id FROM devices WHERE name='RDMillinois'), (SELECT id FROM devices WHERE name='RDMpennsylvania'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMillinois') AND name='2002' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMpennsylvania') AND name='2001' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'RDMillinois->RDMpennsylvania_50', (SELECT id FROM devices WHERE name='RDMillinois'), (SELECT id FROM devices WHERE name='RDMpennsylvania'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMillinois') AND name='2004' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMpennsylvania') AND name='2004' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMpennsylvania-RDMarizona
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMpennsylvania->RDMarizona_31', (SELECT id FROM devices WHERE name='RDMpennsylvania'), (SELECT id FROM devices WHERE name='RDMarizona'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMpennsylvania') AND name='2002' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMarizona') AND name='2002' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'RDMpennsylvania->RDMarizona_51', (SELECT id FROM devices WHERE name='RDMpennsylvania'), (SELECT id FROM devices WHERE name='RDMarizona'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMpennsylvania') AND name='2005' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMarizona') AND name='2005' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMpennsylvania-RDMmassachusetts
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMpennsylvania->RDMmassachusetts_32', (SELECT id FROM devices WHERE name='RDMpennsylvania'), (SELECT id FROM devices WHERE name='RDMmassachusetts'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMpennsylvania') AND name='2003' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmassachusetts') AND name='2001' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'RDMpennsylvania->RDMmassachusetts_52', (SELECT id FROM devices WHERE name='RDMpennsylvania'), (SELECT id FROM devices WHERE name='RDMmassachusetts'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMpennsylvania') AND name='2006' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmassachusetts') AND name='2005' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMohio-RDMmassachusetts
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMohio->RDMmassachusetts_33', (SELECT id FROM devices WHERE name='RDMohio'), (SELECT id FROM devices WHERE name='RDMmassachusetts'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMohio') AND name='2002' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmassachusetts') AND name='2002' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'RDMohio->RDMmassachusetts_53', (SELECT id FROM devices WHERE name='RDMohio'), (SELECT id FROM devices WHERE name='RDMmassachusetts'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMohio') AND name='2004' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmassachusetts') AND name='2006' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMohio-RDMtennessee
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMohio->RDMtennessee_34', (SELECT id FROM devices WHERE name='RDMohio'), (SELECT id FROM devices WHERE name='RDMtennessee'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMohio') AND name='2003' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMtennessee') AND name='2002' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'RDMohio->RDMtennessee_54', (SELECT id FROM devices WHERE name='RDMohio'), (SELECT id FROM devices WHERE name='RDMtennessee'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMohio') AND name='2005' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMtennessee') AND name='2006' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMarizona-RDMmaryland
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMarizona->RDMmaryland_35', (SELECT id FROM devices WHERE name='RDMarizona'), (SELECT id FROM devices WHERE name='RDMmaryland'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMarizona') AND name='2003' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmaryland') AND name='2001' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'RDMarizona->RDMmaryland_55', (SELECT id FROM devices WHERE name='RDMarizona'), (SELECT id FROM devices WHERE name='RDMmaryland'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMarizona') AND name='2006' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmaryland') AND name='2004' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMarizona-RDMcolorado
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMarizona->RDMcolorado_36', (SELECT id FROM devices WHERE name='RDMarizona'), (SELECT id FROM devices WHERE name='RDMcolorado'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMarizona') AND name='2004' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMcolorado') AND name='2001' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMmassachusetts-RDMmaryland
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMmassachusetts->RDMmaryland_37', (SELECT id FROM devices WHERE name='RDMmassachusetts'), (SELECT id FROM devices WHERE name='RDMmaryland'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmassachusetts') AND name='2003' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmaryland') AND name='2002' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMmassachusetts-RDMindiana
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMmassachusetts->RDMindiana_38', (SELECT id FROM devices WHERE name='RDMmassachusetts'), (SELECT id FROM devices WHERE name='RDMindiana'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmassachusetts') AND name='2004' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMindiana') AND name='2001' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMtennessee-RDMmissouri
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMtennessee->RDMmissouri_39', (SELECT id FROM devices WHERE name='RDMtennessee'), (SELECT id FROM devices WHERE name='RDMmissouri'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMtennessee') AND name='2003' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmissouri') AND name='2001' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMtennessee-RDMindiana
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMtennessee->RDMindiana_40', (SELECT id FROM devices WHERE name='RDMtennessee'), (SELECT id FROM devices WHERE name='RDMindiana'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMtennessee') AND name='2004' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMindiana') AND name='2002' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMtennessee-RDMcolorado
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMtennessee->RDMcolorado_41', (SELECT id FROM devices WHERE name='RDMtennessee'), (SELECT id FROM devices WHERE name='RDMcolorado'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMtennessee') AND name='2005' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMcolorado') AND name='2002' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMmaryland-RDMmissouri
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMmaryland->RDMmissouri_42', (SELECT id FROM devices WHERE name='RDMmaryland'), (SELECT id FROM devices WHERE name='RDMmissouri'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmaryland') AND name='2003' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmissouri') AND name='2002' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'RDMmaryland->RDMmissouri_56', (SELECT id FROM devices WHERE name='RDMmaryland'), (SELECT id FROM devices WHERE name='RDMmissouri'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmaryland') AND name='2005' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmissouri') AND name='2004' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'RDMmaryland->RDMmissouri_59', (SELECT id FROM devices WHERE name='RDMmaryland'), (SELECT id FROM devices WHERE name='RDMmissouri'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmaryland') AND name='2006' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmissouri') AND name='2006' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMmissouri-RDMindiana
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, status, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMmissouri->RDMindiana_43', (SELECT id FROM devices WHERE name='RDMmissouri'), (SELECT id FROM devices WHERE name='RDMindiana'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmissouri') AND name='2003' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMindiana') AND name='2003' LIMIT 1), 'FREE', NOW(), NOW()),
	(gen_random_uuid(), 'RDMmissouri->RDMindiana_57', (SELECT id FROM devices WHERE name='RDMmissouri'), (SELECT id FROM devices WHERE name='RDMindiana'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmissouri') AND name='2005' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMindiana') AND name='2004' LIMIT 1), 'FREE', NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;
