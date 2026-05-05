-- Pan-EU 27-Node Topology: Optical Links
-- 27 nodes, 55 links (one per device pair)

--- GLASGOW-LONDON
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMglasgow->RDMlondon_1',
    (SELECT id FROM devices WHERE name='RDMglasgow'),
    (SELECT id FROM devices WHERE name='RDMlondon'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMglasgow') AND name='2001' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlondon') AND name='2001' LIMIT 1),
    NOW(), NOW());

--- GLASGOW-OSLO
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMglasgow->RDMoslo_1',
    (SELECT id FROM devices WHERE name='RDMglasgow'),
    (SELECT id FROM devices WHERE name='RDMoslo'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMglasgow') AND name='2002' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMoslo') AND name='2001' LIMIT 1),
    NOW(), NOW());

--- OSLO-STOCKHOLM
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMoslo->RDMstockholm_1',
    (SELECT id FROM devices WHERE name='RDMoslo'),
    (SELECT id FROM devices WHERE name='RDMstockholm'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMoslo') AND name='2002' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMstockholm') AND name='2001' LIMIT 1),
    NOW(), NOW());

--- OSLO-COPENHAGEN
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMoslo->RDMcopenhagen_1',
    (SELECT id FROM devices WHERE name='RDMoslo'),
    (SELECT id FROM devices WHERE name='RDMcopenhagen'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMoslo') AND name='2003' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMcopenhagen') AND name='2001' LIMIT 1),
    NOW(), NOW());

--- STOCKHOLM-COPENHAGEN
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMstockholm->RDMcopenhagen_1',
    (SELECT id FROM devices WHERE name='RDMstockholm'),
    (SELECT id FROM devices WHERE name='RDMcopenhagen'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMstockholm') AND name='2002' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMcopenhagen') AND name='2002' LIMIT 1),
    NOW(), NOW());

--- STOCKHOLM-BERLIN
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMstockholm->RDMberlin_1',
    (SELECT id FROM devices WHERE name='RDMstockholm'),
    (SELECT id FROM devices WHERE name='RDMberlin'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMstockholm') AND name='2003' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMberlin') AND name='2001' LIMIT 1),
    NOW(), NOW());

--- STOCKHOLM-WARSAW
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMstockholm->RDMwarsaw_1',
    (SELECT id FROM devices WHERE name='RDMstockholm'),
    (SELECT id FROM devices WHERE name='RDMwarsaw'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMstockholm') AND name='2004' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMwarsaw') AND name='2001' LIMIT 1),
    NOW(), NOW());

--- DUBLIN-LONDON
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMdublin->RDMlondon_1',
    (SELECT id FROM devices WHERE name='RDMdublin'),
    (SELECT id FROM devices WHERE name='RDMlondon'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMdublin') AND name='2001' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlondon') AND name='2002' LIMIT 1),
    NOW(), NOW());

--- DUBLIN-PARIS
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMdublin->RDMparis_1',
    (SELECT id FROM devices WHERE name='RDMdublin'),
    (SELECT id FROM devices WHERE name='RDMparis'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMdublin') AND name='2002' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMparis') AND name='2001' LIMIT 1),
    NOW(), NOW());

--- LONDON-AMSTERDAM
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMlondon->RDMamsterdam_1',
    (SELECT id FROM devices WHERE name='RDMlondon'),
    (SELECT id FROM devices WHERE name='RDMamsterdam'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlondon') AND name='2003' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMamsterdam') AND name='2001' LIMIT 1),
    NOW(), NOW());

--- LONDON-BRUSSELS
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMlondon->RDMbrussels_1',
    (SELECT id FROM devices WHERE name='RDMlondon'),
    (SELECT id FROM devices WHERE name='RDMbrussels'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlondon') AND name='2004' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbrussels') AND name='2001' LIMIT 1),
    NOW(), NOW());

--- LONDON-PARIS
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMlondon->RDMparis_1',
    (SELECT id FROM devices WHERE name='RDMlondon'),
    (SELECT id FROM devices WHERE name='RDMparis'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlondon') AND name='2005' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMparis') AND name='2002' LIMIT 1),
    NOW(), NOW());

--- AMSTERDAM-PARIS
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMamsterdam->RDMparis_1',
    (SELECT id FROM devices WHERE name='RDMamsterdam'),
    (SELECT id FROM devices WHERE name='RDMparis'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMamsterdam') AND name='2002' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMparis') AND name='2003' LIMIT 1),
    NOW(), NOW());

--- PARIS-BRUSSELS
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMparis->RDMbrussels_1',
    (SELECT id FROM devices WHERE name='RDMparis'),
    (SELECT id FROM devices WHERE name='RDMbrussels'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMparis') AND name='2004' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbrussels') AND name='2002' LIMIT 1),
    NOW(), NOW());

--- PARIS-STRASBOURG
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMparis->RDMstrasbourg_1',
    (SELECT id FROM devices WHERE name='RDMparis'),
    (SELECT id FROM devices WHERE name='RDMstrasbourg'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMparis') AND name='2005' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMstrasbourg') AND name='2001' LIMIT 1),
    NOW(), NOW());

--- PARIS-BORDEAUX
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMparis->RDMbordeaux_1',
    (SELECT id FROM devices WHERE name='RDMparis'),
    (SELECT id FROM devices WHERE name='RDMbordeaux'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMparis') AND name='2006' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbordeaux') AND name='2001' LIMIT 1),
    NOW(), NOW());

--- AMSTERDAM-HAMBURG
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMamsterdam->RDMhamburg_1',
    (SELECT id FROM devices WHERE name='RDMamsterdam'),
    (SELECT id FROM devices WHERE name='RDMhamburg'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMamsterdam') AND name='2003' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMhamburg') AND name='2001' LIMIT 1),
    NOW(), NOW());

--- AMSTERDAM-BRUSSELS
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMamsterdam->RDMbrussels_1',
    (SELECT id FROM devices WHERE name='RDMamsterdam'),
    (SELECT id FROM devices WHERE name='RDMbrussels'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMamsterdam') AND name='2004' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbrussels') AND name='2003' LIMIT 1),
    NOW(), NOW());

--- HAMBURG-COPENHAGEN
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMhamburg->RDMcopenhagen_1',
    (SELECT id FROM devices WHERE name='RDMhamburg'),
    (SELECT id FROM devices WHERE name='RDMcopenhagen'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMhamburg') AND name='2002' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMcopenhagen') AND name='2003' LIMIT 1),
    NOW(), NOW());

--- HAMBURG-BERLIN
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMhamburg->RDMberlin_1',
    (SELECT id FROM devices WHERE name='RDMhamburg'),
    (SELECT id FROM devices WHERE name='RDMberlin'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMhamburg') AND name='2003' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMberlin') AND name='2002' LIMIT 1),
    NOW(), NOW());

--- HAMBURG-FRANKFURT
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMhamburg->RDMfrankfurt_1',
    (SELECT id FROM devices WHERE name='RDMhamburg'),
    (SELECT id FROM devices WHERE name='RDMfrankfurt'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMhamburg') AND name='2004' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMfrankfurt') AND name='2001' LIMIT 1),
    NOW(), NOW());

--- BRUSSELS-FRANKFURT
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMbrussels->RDMfrankfurt_1',
    (SELECT id FROM devices WHERE name='RDMbrussels'),
    (SELECT id FROM devices WHERE name='RDMfrankfurt'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbrussels') AND name='2004' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMfrankfurt') AND name='2002' LIMIT 1),
    NOW(), NOW());

--- BERLIN-WARSAW
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMberlin->RDMwarsaw_1',
    (SELECT id FROM devices WHERE name='RDMberlin'),
    (SELECT id FROM devices WHERE name='RDMwarsaw'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMberlin') AND name='2003' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMwarsaw') AND name='2002' LIMIT 1),
    NOW(), NOW());

--- BERLIN-FRANKFURT
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMberlin->RDMfrankfurt_1',
    (SELECT id FROM devices WHERE name='RDMberlin'),
    (SELECT id FROM devices WHERE name='RDMfrankfurt'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMberlin') AND name='2004' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMfrankfurt') AND name='2003' LIMIT 1),
    NOW(), NOW());

--- BERLIN-PRAGUE
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMberlin->RDMprague_1',
    (SELECT id FROM devices WHERE name='RDMberlin'),
    (SELECT id FROM devices WHERE name='RDMprague'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMberlin') AND name='2005' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMprague') AND name='2001' LIMIT 1),
    NOW(), NOW());

--- FRANKFURT-PRAGUE
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMfrankfurt->RDMprague_1',
    (SELECT id FROM devices WHERE name='RDMfrankfurt'),
    (SELECT id FROM devices WHERE name='RDMprague'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMfrankfurt') AND name='2004' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMprague') AND name='2002' LIMIT 1),
    NOW(), NOW());

--- FRANKFURT-MUNICH
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMfrankfurt->RDMmunich_1',
    (SELECT id FROM devices WHERE name='RDMfrankfurt'),
    (SELECT id FROM devices WHERE name='RDMmunich'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMfrankfurt') AND name='2005' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmunich') AND name='2001' LIMIT 1),
    NOW(), NOW());

--- ZURICH-STRASBOURG
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMzurich->RDMstrasbourg_1',
    (SELECT id FROM devices WHERE name='RDMzurich'),
    (SELECT id FROM devices WHERE name='RDMstrasbourg'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMzurich') AND name='2001' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMstrasbourg') AND name='2002' LIMIT 1),
    NOW(), NOW());

--- ZURICH-MUNICH
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMzurich->RDMmunich_1',
    (SELECT id FROM devices WHERE name='RDMzurich'),
    (SELECT id FROM devices WHERE name='RDMmunich'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMzurich') AND name='2002' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmunich') AND name='2002' LIMIT 1),
    NOW(), NOW());

--- ZURICH-MILAN
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMzurich->RDMmilan_1',
    (SELECT id FROM devices WHERE name='RDMzurich'),
    (SELECT id FROM devices WHERE name='RDMmilan'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMzurich') AND name='2003' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmilan') AND name='2001' LIMIT 1),
    NOW(), NOW());

--- ZURICH-LYON
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMzurich->RDMlyon_1',
    (SELECT id FROM devices WHERE name='RDMzurich'),
    (SELECT id FROM devices WHERE name='RDMlyon'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMzurich') AND name='2004' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlyon') AND name='2001' LIMIT 1),
    NOW(), NOW());

--- MUNICH-PRAGUE
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMmunich->RDMprague_1',
    (SELECT id FROM devices WHERE name='RDMmunich'),
    (SELECT id FROM devices WHERE name='RDMprague'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmunich') AND name='2003' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMprague') AND name='2003' LIMIT 1),
    NOW(), NOW());

--- MUNICH-MILAN
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMmunich->RDMmilan_1',
    (SELECT id FROM devices WHERE name='RDMmunich'),
    (SELECT id FROM devices WHERE name='RDMmilan'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmunich') AND name='2004' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmilan') AND name='2002' LIMIT 1),
    NOW(), NOW());

--- MUNICH-VIENNA
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMmunich->RDMvienna_1',
    (SELECT id FROM devices WHERE name='RDMmunich'),
    (SELECT id FROM devices WHERE name='RDMvienna'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmunich') AND name='2005' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMvienna') AND name='2001' LIMIT 1),
    NOW(), NOW());

--- STRASBOURG-LYON
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMstrasbourg->RDMlyon_1',
    (SELECT id FROM devices WHERE name='RDMstrasbourg'),
    (SELECT id FROM devices WHERE name='RDMlyon'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMstrasbourg') AND name='2003' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlyon') AND name='2002' LIMIT 1),
    NOW(), NOW());

--- LYON-PARIS
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMlyon->RDMparis_1',
    (SELECT id FROM devices WHERE name='RDMlyon'),
    (SELECT id FROM devices WHERE name='RDMparis'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlyon') AND name='2003' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMparis') AND name='2007' LIMIT 1),
    NOW(), NOW());

--- LYON-BORDEAUX
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMlyon->RDMbordeaux_1',
    (SELECT id FROM devices WHERE name='RDMlyon'),
    (SELECT id FROM devices WHERE name='RDMbordeaux'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlyon') AND name='2004' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbordeaux') AND name='2002' LIMIT 1),
    NOW(), NOW());

--- LYON-BARCELONA
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMlyon->RDMbarcelona_1',
    (SELECT id FROM devices WHERE name='RDMlyon'),
    (SELECT id FROM devices WHERE name='RDMbarcelona'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlyon') AND name='2005' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbarcelona') AND name='2001' LIMIT 1),
    NOW(), NOW());

--- LYON-MILAN
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMlyon->RDMmilan_1',
    (SELECT id FROM devices WHERE name='RDMlyon'),
    (SELECT id FROM devices WHERE name='RDMmilan'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlyon') AND name='2006' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmilan') AND name='2003' LIMIT 1),
    NOW(), NOW());

--- BORDEAUX-BARCELONA
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMbordeaux->RDMbarcelona_1',
    (SELECT id FROM devices WHERE name='RDMbordeaux'),
    (SELECT id FROM devices WHERE name='RDMbarcelona'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbordeaux') AND name='2003' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbarcelona') AND name='2002' LIMIT 1),
    NOW(), NOW());

--- BORDEAUX-MADRID
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMbordeaux->RDMmadrid_1',
    (SELECT id FROM devices WHERE name='RDMbordeaux'),
    (SELECT id FROM devices WHERE name='RDMmadrid'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbordeaux') AND name='2004' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmadrid') AND name='2001' LIMIT 1),
    NOW(), NOW());

--- BARCELONA-MADRID
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMbarcelona->RDMmadrid_1',
    (SELECT id FROM devices WHERE name='RDMbarcelona'),
    (SELECT id FROM devices WHERE name='RDMmadrid'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbarcelona') AND name='2003' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmadrid') AND name='2002' LIMIT 1),
    NOW(), NOW());

--- MILAN-VIENNA
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMmilan->RDMvienna_1',
    (SELECT id FROM devices WHERE name='RDMmilan'),
    (SELECT id FROM devices WHERE name='RDMvienna'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmilan') AND name='2004' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMvienna') AND name='2002' LIMIT 1),
    NOW(), NOW());

--- MILAN-ROME
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMmilan->RDMrome_1',
    (SELECT id FROM devices WHERE name='RDMmilan'),
    (SELECT id FROM devices WHERE name='RDMrome'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmilan') AND name='2005' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMrome') AND name='2001' LIMIT 1),
    NOW(), NOW());

--- PRAGUE-WARSAW
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMprague->RDMwarsaw_1',
    (SELECT id FROM devices WHERE name='RDMprague'),
    (SELECT id FROM devices WHERE name='RDMwarsaw'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMprague') AND name='2004' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMwarsaw') AND name='2003' LIMIT 1),
    NOW(), NOW());

--- PRAGUE-BUDAPEST
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMprague->RDMbudapest_1',
    (SELECT id FROM devices WHERE name='RDMprague'),
    (SELECT id FROM devices WHERE name='RDMbudapest'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMprague') AND name='2005' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbudapest') AND name='2001' LIMIT 1),
    NOW(), NOW());

--- PRAGUE-VIENNA
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMprague->RDMvienna_1',
    (SELECT id FROM devices WHERE name='RDMprague'),
    (SELECT id FROM devices WHERE name='RDMvienna'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMprague') AND name='2006' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMvienna') AND name='2003' LIMIT 1),
    NOW(), NOW());

--- WARSAW-BUDAPEST
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMwarsaw->RDMbudapest_1',
    (SELECT id FROM devices WHERE name='RDMwarsaw'),
    (SELECT id FROM devices WHERE name='RDMbudapest'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMwarsaw') AND name='2004' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbudapest') AND name='2002' LIMIT 1),
    NOW(), NOW());

--- BUDAPEST-VIENNA
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMbudapest->RDMvienna_1',
    (SELECT id FROM devices WHERE name='RDMbudapest'),
    (SELECT id FROM devices WHERE name='RDMvienna'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbudapest') AND name='2003' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMvienna') AND name='2004' LIMIT 1),
    NOW(), NOW());

--- BUDAPEST-BELGRADE
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMbudapest->RDMbelgrade_1',
    (SELECT id FROM devices WHERE name='RDMbudapest'),
    (SELECT id FROM devices WHERE name='RDMbelgrade'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbudapest') AND name='2004' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbelgrade') AND name='2001' LIMIT 1),
    NOW(), NOW());

--- VIENNA-ROME
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMvienna->RDMrome_1',
    (SELECT id FROM devices WHERE name='RDMvienna'),
    (SELECT id FROM devices WHERE name='RDMrome'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMvienna') AND name='2005' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMrome') AND name='2002' LIMIT 1),
    NOW(), NOW());

--- VIENNA-BELGRADE
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMvienna->RDMbelgrade_1',
    (SELECT id FROM devices WHERE name='RDMvienna'),
    (SELECT id FROM devices WHERE name='RDMbelgrade'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMvienna') AND name='2006' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbelgrade') AND name='2002' LIMIT 1),
    NOW(), NOW());

--- ROME-BELGRADE
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMrome->RDMbelgrade_1',
    (SELECT id FROM devices WHERE name='RDMrome'),
    (SELECT id FROM devices WHERE name='RDMbelgrade'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMrome') AND name='2003' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbelgrade') AND name='2003' LIMIT 1),
    NOW(), NOW());

--- ROME-ATHENS
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMrome->RDMathens_1',
    (SELECT id FROM devices WHERE name='RDMrome'),
    (SELECT id FROM devices WHERE name='RDMathens'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMrome') AND name='2004' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMathens') AND name='2001' LIMIT 1),
    NOW(), NOW());

--- BELGRADE-ATHENS
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMbelgrade->RDMathens_1',
    (SELECT id FROM devices WHERE name='RDMbelgrade'),
    (SELECT id FROM devices WHERE name='RDMathens'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbelgrade') AND name='2004' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMathens') AND name='2002' LIMIT 1),
    NOW(), NOW());

