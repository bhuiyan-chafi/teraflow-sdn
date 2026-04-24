-- NSF Topology: Optical Links
-- RDM->RDM single links using OMS ports (2001-2012)

--- RDMwa-RDMca1
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMwa->RDMca1_1', (SELECT id FROM devices WHERE name='RDMwa'), (SELECT id FROM devices WHERE name='RDMca1'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMwa') AND name='2001' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMca1') AND name='2001' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMwa-RDMut
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMwa->RDMut_2', (SELECT id FROM devices WHERE name='RDMwa'), (SELECT id FROM devices WHERE name='RDMut'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMwa') AND name='2002' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMut') AND name='2001' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMwa-RDMny
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMwa->RDMny_3', (SELECT id FROM devices WHERE name='RDMwa'), (SELECT id FROM devices WHERE name='RDMny'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMwa') AND name='2003' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMny') AND name='2001' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMca1-RDMca2
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMca1->RDMca2_4', (SELECT id FROM devices WHERE name='RDMca1'), (SELECT id FROM devices WHERE name='RDMca2'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMca1') AND name='2002' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMca2') AND name='2001' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMca1-RDMut
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMca1->RDMut_5', (SELECT id FROM devices WHERE name='RDMca1'), (SELECT id FROM devices WHERE name='RDMut'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMca1') AND name='2003' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMut') AND name='2002' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMca2-RDMtx
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMca2->RDMtx_6', (SELECT id FROM devices WHERE name='RDMca2'), (SELECT id FROM devices WHERE name='RDMtx'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMca2') AND name='2002' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMtx') AND name='2001' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMut-RDMco
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMut->RDMco_7', (SELECT id FROM devices WHERE name='RDMut'), (SELECT id FROM devices WHERE name='RDMco'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMut') AND name='2003' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMco') AND name='2001' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMut-RDMmi
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMut->RDMmi_8', (SELECT id FROM devices WHERE name='RDMut'), (SELECT id FROM devices WHERE name='RDMmi'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMut') AND name='2004' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmi') AND name='2001' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMco-RDMne
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMco->RDMne_9', (SELECT id FROM devices WHERE name='RDMco'), (SELECT id FROM devices WHERE name='RDMne'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMco') AND name='2002' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMne') AND name='2001' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMco-RDMtx
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMco->RDMtx_10', (SELECT id FROM devices WHERE name='RDMco'), (SELECT id FROM devices WHERE name='RDMtx'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMco') AND name='2003' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMtx') AND name='2002' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMne-RDMil
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMne->RDMil_11', (SELECT id FROM devices WHERE name='RDMne'), (SELECT id FROM devices WHERE name='RDMil'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMne') AND name='2002' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMil') AND name='2001' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMtx-RDMil
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMtx->RDMil_12', (SELECT id FROM devices WHERE name='RDMtx'), (SELECT id FROM devices WHERE name='RDMil'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMtx') AND name='2003' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMil') AND name='2002' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMtx-RDMga
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMtx->RDMga_13', (SELECT id FROM devices WHERE name='RDMtx'), (SELECT id FROM devices WHERE name='RDMga'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMtx') AND name='2004' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMga') AND name='2001' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMil-RDMmi
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMil->RDMmi_14', (SELECT id FROM devices WHERE name='RDMil'), (SELECT id FROM devices WHERE name='RDMmi'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMil') AND name='2003' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmi') AND name='2002' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMil-RDMpa
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMil->RDMpa_15', (SELECT id FROM devices WHERE name='RDMil'), (SELECT id FROM devices WHERE name='RDMpa'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMil') AND name='2004' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMpa') AND name='2001' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMmi-RDMny
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMmi->RDMny_16', (SELECT id FROM devices WHERE name='RDMmi'), (SELECT id FROM devices WHERE name='RDMny'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmi') AND name='2003' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMny') AND name='2002' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMpa-RDMny
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMpa->RDMny_17', (SELECT id FROM devices WHERE name='RDMpa'), (SELECT id FROM devices WHERE name='RDMny'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMpa') AND name='2002' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMny') AND name='2003' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMpa-RDMnj
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMpa->RDMnj_18', (SELECT id FROM devices WHERE name='RDMpa'), (SELECT id FROM devices WHERE name='RDMnj'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMpa') AND name='2003' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMnj') AND name='2001' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMpa-RDMma
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMpa->RDMma_19', (SELECT id FROM devices WHERE name='RDMpa'), (SELECT id FROM devices WHERE name='RDMma'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMpa') AND name='2004' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMma') AND name='2001' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMny-RDMnj
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMny->RDMnj_20', (SELECT id FROM devices WHERE name='RDMny'), (SELECT id FROM devices WHERE name='RDMnj'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMny') AND name='2004' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMnj') AND name='2002' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMnj-RDMma
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMnj->RDMma_21', (SELECT id FROM devices WHERE name='RDMnj'), (SELECT id FROM devices WHERE name='RDMma'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMnj') AND name='2003' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMma') AND name='2002' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

--- RDMga-RDMma
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
	(gen_random_uuid(), 'RDMga->RDMma_22', (SELECT id FROM devices WHERE name='RDMga'), (SELECT id FROM devices WHERE name='RDMma'), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMga') AND name='2002' LIMIT 1), (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMma') AND name='2003' LIMIT 1), NOW(), NOW())
ON CONFLICT (src_endpoint_id, dst_endpoint_id) DO NOTHING;

