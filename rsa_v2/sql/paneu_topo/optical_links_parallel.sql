-- Pan-EU 27-Node Topology: Optical Links (PARALLEL - 3 links per connection)
-- 27 nodes, 55 connections x 3 = 165 total links

--- GLASGOW-LONDON (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMglasgow->RDMlondon_1',
    (SELECT id FROM devices WHERE name='RDMglasgow'),
    (SELECT id FROM devices WHERE name='RDMlondon'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMglasgow') AND name='2001' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlondon') AND name='2001' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMglasgow->RDMlondon_2',
    (SELECT id FROM devices WHERE name='RDMglasgow'),
    (SELECT id FROM devices WHERE name='RDMlondon'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMglasgow') AND name='2002' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlondon') AND name='2002' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMglasgow->RDMlondon_3',
    (SELECT id FROM devices WHERE name='RDMglasgow'),
    (SELECT id FROM devices WHERE name='RDMlondon'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMglasgow') AND name='2003' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlondon') AND name='2003' LIMIT 1),
    NOW(), NOW());

--- GLASGOW-OSLO (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMglasgow->RDMoslo_1',
    (SELECT id FROM devices WHERE name='RDMglasgow'),
    (SELECT id FROM devices WHERE name='RDMoslo'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMglasgow') AND name='2004' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMoslo') AND name='2001' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMglasgow->RDMoslo_2',
    (SELECT id FROM devices WHERE name='RDMglasgow'),
    (SELECT id FROM devices WHERE name='RDMoslo'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMglasgow') AND name='2005' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMoslo') AND name='2002' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMglasgow->RDMoslo_3',
    (SELECT id FROM devices WHERE name='RDMglasgow'),
    (SELECT id FROM devices WHERE name='RDMoslo'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMglasgow') AND name='2006' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMoslo') AND name='2003' LIMIT 1),
    NOW(), NOW());

--- OSLO-STOCKHOLM (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMoslo->RDMstockholm_1',
    (SELECT id FROM devices WHERE name='RDMoslo'),
    (SELECT id FROM devices WHERE name='RDMstockholm'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMoslo') AND name='2004' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMstockholm') AND name='2001' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMoslo->RDMstockholm_2',
    (SELECT id FROM devices WHERE name='RDMoslo'),
    (SELECT id FROM devices WHERE name='RDMstockholm'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMoslo') AND name='2005' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMstockholm') AND name='2002' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMoslo->RDMstockholm_3',
    (SELECT id FROM devices WHERE name='RDMoslo'),
    (SELECT id FROM devices WHERE name='RDMstockholm'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMoslo') AND name='2006' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMstockholm') AND name='2003' LIMIT 1),
    NOW(), NOW());

--- OSLO-COPENHAGEN (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMoslo->RDMcopenhagen_1',
    (SELECT id FROM devices WHERE name='RDMoslo'),
    (SELECT id FROM devices WHERE name='RDMcopenhagen'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMoslo') AND name='2007' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMcopenhagen') AND name='2001' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMoslo->RDMcopenhagen_2',
    (SELECT id FROM devices WHERE name='RDMoslo'),
    (SELECT id FROM devices WHERE name='RDMcopenhagen'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMoslo') AND name='2008' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMcopenhagen') AND name='2002' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMoslo->RDMcopenhagen_3',
    (SELECT id FROM devices WHERE name='RDMoslo'),
    (SELECT id FROM devices WHERE name='RDMcopenhagen'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMoslo') AND name='2009' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMcopenhagen') AND name='2003' LIMIT 1),
    NOW(), NOW());

--- STOCKHOLM-COPENHAGEN (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMstockholm->RDMcopenhagen_1',
    (SELECT id FROM devices WHERE name='RDMstockholm'),
    (SELECT id FROM devices WHERE name='RDMcopenhagen'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMstockholm') AND name='2004' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMcopenhagen') AND name='2004' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMstockholm->RDMcopenhagen_2',
    (SELECT id FROM devices WHERE name='RDMstockholm'),
    (SELECT id FROM devices WHERE name='RDMcopenhagen'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMstockholm') AND name='2005' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMcopenhagen') AND name='2005' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMstockholm->RDMcopenhagen_3',
    (SELECT id FROM devices WHERE name='RDMstockholm'),
    (SELECT id FROM devices WHERE name='RDMcopenhagen'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMstockholm') AND name='2006' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMcopenhagen') AND name='2006' LIMIT 1),
    NOW(), NOW());

--- STOCKHOLM-BERLIN (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMstockholm->RDMberlin_1',
    (SELECT id FROM devices WHERE name='RDMstockholm'),
    (SELECT id FROM devices WHERE name='RDMberlin'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMstockholm') AND name='2007' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMberlin') AND name='2001' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMstockholm->RDMberlin_2',
    (SELECT id FROM devices WHERE name='RDMstockholm'),
    (SELECT id FROM devices WHERE name='RDMberlin'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMstockholm') AND name='2008' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMberlin') AND name='2002' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMstockholm->RDMberlin_3',
    (SELECT id FROM devices WHERE name='RDMstockholm'),
    (SELECT id FROM devices WHERE name='RDMberlin'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMstockholm') AND name='2009' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMberlin') AND name='2003' LIMIT 1),
    NOW(), NOW());

--- STOCKHOLM-WARSAW (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMstockholm->RDMwarsaw_1',
    (SELECT id FROM devices WHERE name='RDMstockholm'),
    (SELECT id FROM devices WHERE name='RDMwarsaw'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMstockholm') AND name='2010' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMwarsaw') AND name='2001' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMstockholm->RDMwarsaw_2',
    (SELECT id FROM devices WHERE name='RDMstockholm'),
    (SELECT id FROM devices WHERE name='RDMwarsaw'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMstockholm') AND name='2011' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMwarsaw') AND name='2002' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMstockholm->RDMwarsaw_3',
    (SELECT id FROM devices WHERE name='RDMstockholm'),
    (SELECT id FROM devices WHERE name='RDMwarsaw'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMstockholm') AND name='2012' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMwarsaw') AND name='2003' LIMIT 1),
    NOW(), NOW());

--- DUBLIN-LONDON (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMdublin->RDMlondon_1',
    (SELECT id FROM devices WHERE name='RDMdublin'),
    (SELECT id FROM devices WHERE name='RDMlondon'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMdublin') AND name='2001' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlondon') AND name='2004' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMdublin->RDMlondon_2',
    (SELECT id FROM devices WHERE name='RDMdublin'),
    (SELECT id FROM devices WHERE name='RDMlondon'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMdublin') AND name='2002' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlondon') AND name='2005' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMdublin->RDMlondon_3',
    (SELECT id FROM devices WHERE name='RDMdublin'),
    (SELECT id FROM devices WHERE name='RDMlondon'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMdublin') AND name='2003' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlondon') AND name='2006' LIMIT 1),
    NOW(), NOW());

--- DUBLIN-PARIS (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMdublin->RDMparis_1',
    (SELECT id FROM devices WHERE name='RDMdublin'),
    (SELECT id FROM devices WHERE name='RDMparis'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMdublin') AND name='2004' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMparis') AND name='2001' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMdublin->RDMparis_2',
    (SELECT id FROM devices WHERE name='RDMdublin'),
    (SELECT id FROM devices WHERE name='RDMparis'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMdublin') AND name='2005' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMparis') AND name='2002' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMdublin->RDMparis_3',
    (SELECT id FROM devices WHERE name='RDMdublin'),
    (SELECT id FROM devices WHERE name='RDMparis'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMdublin') AND name='2006' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMparis') AND name='2003' LIMIT 1),
    NOW(), NOW());

--- LONDON-AMSTERDAM (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMlondon->RDMamsterdam_1',
    (SELECT id FROM devices WHERE name='RDMlondon'),
    (SELECT id FROM devices WHERE name='RDMamsterdam'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlondon') AND name='2007' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMamsterdam') AND name='2001' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMlondon->RDMamsterdam_2',
    (SELECT id FROM devices WHERE name='RDMlondon'),
    (SELECT id FROM devices WHERE name='RDMamsterdam'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlondon') AND name='2008' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMamsterdam') AND name='2002' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMlondon->RDMamsterdam_3',
    (SELECT id FROM devices WHERE name='RDMlondon'),
    (SELECT id FROM devices WHERE name='RDMamsterdam'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlondon') AND name='2009' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMamsterdam') AND name='2003' LIMIT 1),
    NOW(), NOW());

--- LONDON-BRUSSELS (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMlondon->RDMbrussels_1',
    (SELECT id FROM devices WHERE name='RDMlondon'),
    (SELECT id FROM devices WHERE name='RDMbrussels'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlondon') AND name='2010' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbrussels') AND name='2001' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMlondon->RDMbrussels_2',
    (SELECT id FROM devices WHERE name='RDMlondon'),
    (SELECT id FROM devices WHERE name='RDMbrussels'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlondon') AND name='2011' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbrussels') AND name='2002' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMlondon->RDMbrussels_3',
    (SELECT id FROM devices WHERE name='RDMlondon'),
    (SELECT id FROM devices WHERE name='RDMbrussels'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlondon') AND name='2012' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbrussels') AND name='2003' LIMIT 1),
    NOW(), NOW());

--- LONDON-PARIS (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMlondon->RDMparis_1',
    (SELECT id FROM devices WHERE name='RDMlondon'),
    (SELECT id FROM devices WHERE name='RDMparis'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlondon') AND name='2013' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMparis') AND name='2004' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMlondon->RDMparis_2',
    (SELECT id FROM devices WHERE name='RDMlondon'),
    (SELECT id FROM devices WHERE name='RDMparis'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlondon') AND name='2014' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMparis') AND name='2005' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMlondon->RDMparis_3',
    (SELECT id FROM devices WHERE name='RDMlondon'),
    (SELECT id FROM devices WHERE name='RDMparis'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlondon') AND name='2015' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMparis') AND name='2006' LIMIT 1),
    NOW(), NOW());

--- AMSTERDAM-PARIS (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMamsterdam->RDMparis_1',
    (SELECT id FROM devices WHERE name='RDMamsterdam'),
    (SELECT id FROM devices WHERE name='RDMparis'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMamsterdam') AND name='2004' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMparis') AND name='2007' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMamsterdam->RDMparis_2',
    (SELECT id FROM devices WHERE name='RDMamsterdam'),
    (SELECT id FROM devices WHERE name='RDMparis'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMamsterdam') AND name='2005' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMparis') AND name='2008' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMamsterdam->RDMparis_3',
    (SELECT id FROM devices WHERE name='RDMamsterdam'),
    (SELECT id FROM devices WHERE name='RDMparis'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMamsterdam') AND name='2006' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMparis') AND name='2009' LIMIT 1),
    NOW(), NOW());

--- PARIS-BRUSSELS (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMparis->RDMbrussels_1',
    (SELECT id FROM devices WHERE name='RDMparis'),
    (SELECT id FROM devices WHERE name='RDMbrussels'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMparis') AND name='2010' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbrussels') AND name='2004' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMparis->RDMbrussels_2',
    (SELECT id FROM devices WHERE name='RDMparis'),
    (SELECT id FROM devices WHERE name='RDMbrussels'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMparis') AND name='2011' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbrussels') AND name='2005' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMparis->RDMbrussels_3',
    (SELECT id FROM devices WHERE name='RDMparis'),
    (SELECT id FROM devices WHERE name='RDMbrussels'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMparis') AND name='2012' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbrussels') AND name='2006' LIMIT 1),
    NOW(), NOW());

--- PARIS-STRASBOURG (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMparis->RDMstrasbourg_1',
    (SELECT id FROM devices WHERE name='RDMparis'),
    (SELECT id FROM devices WHERE name='RDMstrasbourg'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMparis') AND name='2013' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMstrasbourg') AND name='2001' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMparis->RDMstrasbourg_2',
    (SELECT id FROM devices WHERE name='RDMparis'),
    (SELECT id FROM devices WHERE name='RDMstrasbourg'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMparis') AND name='2014' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMstrasbourg') AND name='2002' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMparis->RDMstrasbourg_3',
    (SELECT id FROM devices WHERE name='RDMparis'),
    (SELECT id FROM devices WHERE name='RDMstrasbourg'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMparis') AND name='2015' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMstrasbourg') AND name='2003' LIMIT 1),
    NOW(), NOW());

--- PARIS-BORDEAUX (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMparis->RDMbordeaux_1',
    (SELECT id FROM devices WHERE name='RDMparis'),
    (SELECT id FROM devices WHERE name='RDMbordeaux'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMparis') AND name='2016' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbordeaux') AND name='2001' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMparis->RDMbordeaux_2',
    (SELECT id FROM devices WHERE name='RDMparis'),
    (SELECT id FROM devices WHERE name='RDMbordeaux'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMparis') AND name='2017' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbordeaux') AND name='2002' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMparis->RDMbordeaux_3',
    (SELECT id FROM devices WHERE name='RDMparis'),
    (SELECT id FROM devices WHERE name='RDMbordeaux'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMparis') AND name='2018' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbordeaux') AND name='2003' LIMIT 1),
    NOW(), NOW());

--- AMSTERDAM-HAMBURG (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMamsterdam->RDMhamburg_1',
    (SELECT id FROM devices WHERE name='RDMamsterdam'),
    (SELECT id FROM devices WHERE name='RDMhamburg'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMamsterdam') AND name='2007' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMhamburg') AND name='2001' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMamsterdam->RDMhamburg_2',
    (SELECT id FROM devices WHERE name='RDMamsterdam'),
    (SELECT id FROM devices WHERE name='RDMhamburg'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMamsterdam') AND name='2008' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMhamburg') AND name='2002' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMamsterdam->RDMhamburg_3',
    (SELECT id FROM devices WHERE name='RDMamsterdam'),
    (SELECT id FROM devices WHERE name='RDMhamburg'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMamsterdam') AND name='2009' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMhamburg') AND name='2003' LIMIT 1),
    NOW(), NOW());

--- AMSTERDAM-BRUSSELS (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMamsterdam->RDMbrussels_1',
    (SELECT id FROM devices WHERE name='RDMamsterdam'),
    (SELECT id FROM devices WHERE name='RDMbrussels'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMamsterdam') AND name='2010' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbrussels') AND name='2007' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMamsterdam->RDMbrussels_2',
    (SELECT id FROM devices WHERE name='RDMamsterdam'),
    (SELECT id FROM devices WHERE name='RDMbrussels'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMamsterdam') AND name='2011' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbrussels') AND name='2008' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMamsterdam->RDMbrussels_3',
    (SELECT id FROM devices WHERE name='RDMamsterdam'),
    (SELECT id FROM devices WHERE name='RDMbrussels'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMamsterdam') AND name='2012' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbrussels') AND name='2009' LIMIT 1),
    NOW(), NOW());

--- HAMBURG-COPENHAGEN (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMhamburg->RDMcopenhagen_1',
    (SELECT id FROM devices WHERE name='RDMhamburg'),
    (SELECT id FROM devices WHERE name='RDMcopenhagen'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMhamburg') AND name='2004' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMcopenhagen') AND name='2007' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMhamburg->RDMcopenhagen_2',
    (SELECT id FROM devices WHERE name='RDMhamburg'),
    (SELECT id FROM devices WHERE name='RDMcopenhagen'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMhamburg') AND name='2005' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMcopenhagen') AND name='2008' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMhamburg->RDMcopenhagen_3',
    (SELECT id FROM devices WHERE name='RDMhamburg'),
    (SELECT id FROM devices WHERE name='RDMcopenhagen'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMhamburg') AND name='2006' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMcopenhagen') AND name='2009' LIMIT 1),
    NOW(), NOW());

--- HAMBURG-BERLIN (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMhamburg->RDMberlin_1',
    (SELECT id FROM devices WHERE name='RDMhamburg'),
    (SELECT id FROM devices WHERE name='RDMberlin'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMhamburg') AND name='2007' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMberlin') AND name='2004' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMhamburg->RDMberlin_2',
    (SELECT id FROM devices WHERE name='RDMhamburg'),
    (SELECT id FROM devices WHERE name='RDMberlin'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMhamburg') AND name='2008' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMberlin') AND name='2005' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMhamburg->RDMberlin_3',
    (SELECT id FROM devices WHERE name='RDMhamburg'),
    (SELECT id FROM devices WHERE name='RDMberlin'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMhamburg') AND name='2009' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMberlin') AND name='2006' LIMIT 1),
    NOW(), NOW());

--- HAMBURG-FRANKFURT (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMhamburg->RDMfrankfurt_1',
    (SELECT id FROM devices WHERE name='RDMhamburg'),
    (SELECT id FROM devices WHERE name='RDMfrankfurt'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMhamburg') AND name='2010' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMfrankfurt') AND name='2001' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMhamburg->RDMfrankfurt_2',
    (SELECT id FROM devices WHERE name='RDMhamburg'),
    (SELECT id FROM devices WHERE name='RDMfrankfurt'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMhamburg') AND name='2011' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMfrankfurt') AND name='2002' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMhamburg->RDMfrankfurt_3',
    (SELECT id FROM devices WHERE name='RDMhamburg'),
    (SELECT id FROM devices WHERE name='RDMfrankfurt'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMhamburg') AND name='2012' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMfrankfurt') AND name='2003' LIMIT 1),
    NOW(), NOW());

--- BRUSSELS-FRANKFURT (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMbrussels->RDMfrankfurt_1',
    (SELECT id FROM devices WHERE name='RDMbrussels'),
    (SELECT id FROM devices WHERE name='RDMfrankfurt'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbrussels') AND name='2010' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMfrankfurt') AND name='2004' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMbrussels->RDMfrankfurt_2',
    (SELECT id FROM devices WHERE name='RDMbrussels'),
    (SELECT id FROM devices WHERE name='RDMfrankfurt'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbrussels') AND name='2011' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMfrankfurt') AND name='2005' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMbrussels->RDMfrankfurt_3',
    (SELECT id FROM devices WHERE name='RDMbrussels'),
    (SELECT id FROM devices WHERE name='RDMfrankfurt'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbrussels') AND name='2012' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMfrankfurt') AND name='2006' LIMIT 1),
    NOW(), NOW());

--- BERLIN-WARSAW (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMberlin->RDMwarsaw_1',
    (SELECT id FROM devices WHERE name='RDMberlin'),
    (SELECT id FROM devices WHERE name='RDMwarsaw'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMberlin') AND name='2007' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMwarsaw') AND name='2004' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMberlin->RDMwarsaw_2',
    (SELECT id FROM devices WHERE name='RDMberlin'),
    (SELECT id FROM devices WHERE name='RDMwarsaw'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMberlin') AND name='2008' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMwarsaw') AND name='2005' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMberlin->RDMwarsaw_3',
    (SELECT id FROM devices WHERE name='RDMberlin'),
    (SELECT id FROM devices WHERE name='RDMwarsaw'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMberlin') AND name='2009' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMwarsaw') AND name='2006' LIMIT 1),
    NOW(), NOW());

--- BERLIN-FRANKFURT (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMberlin->RDMfrankfurt_1',
    (SELECT id FROM devices WHERE name='RDMberlin'),
    (SELECT id FROM devices WHERE name='RDMfrankfurt'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMberlin') AND name='2010' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMfrankfurt') AND name='2007' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMberlin->RDMfrankfurt_2',
    (SELECT id FROM devices WHERE name='RDMberlin'),
    (SELECT id FROM devices WHERE name='RDMfrankfurt'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMberlin') AND name='2011' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMfrankfurt') AND name='2008' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMberlin->RDMfrankfurt_3',
    (SELECT id FROM devices WHERE name='RDMberlin'),
    (SELECT id FROM devices WHERE name='RDMfrankfurt'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMberlin') AND name='2012' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMfrankfurt') AND name='2009' LIMIT 1),
    NOW(), NOW());

--- BERLIN-PRAGUE (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMberlin->RDMprague_1',
    (SELECT id FROM devices WHERE name='RDMberlin'),
    (SELECT id FROM devices WHERE name='RDMprague'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMberlin') AND name='2013' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMprague') AND name='2001' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMberlin->RDMprague_2',
    (SELECT id FROM devices WHERE name='RDMberlin'),
    (SELECT id FROM devices WHERE name='RDMprague'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMberlin') AND name='2014' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMprague') AND name='2002' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMberlin->RDMprague_3',
    (SELECT id FROM devices WHERE name='RDMberlin'),
    (SELECT id FROM devices WHERE name='RDMprague'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMberlin') AND name='2015' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMprague') AND name='2003' LIMIT 1),
    NOW(), NOW());

--- FRANKFURT-PRAGUE (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMfrankfurt->RDMprague_1',
    (SELECT id FROM devices WHERE name='RDMfrankfurt'),
    (SELECT id FROM devices WHERE name='RDMprague'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMfrankfurt') AND name='2010' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMprague') AND name='2004' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMfrankfurt->RDMprague_2',
    (SELECT id FROM devices WHERE name='RDMfrankfurt'),
    (SELECT id FROM devices WHERE name='RDMprague'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMfrankfurt') AND name='2011' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMprague') AND name='2005' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMfrankfurt->RDMprague_3',
    (SELECT id FROM devices WHERE name='RDMfrankfurt'),
    (SELECT id FROM devices WHERE name='RDMprague'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMfrankfurt') AND name='2012' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMprague') AND name='2006' LIMIT 1),
    NOW(), NOW());

--- FRANKFURT-MUNICH (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMfrankfurt->RDMmunich_1',
    (SELECT id FROM devices WHERE name='RDMfrankfurt'),
    (SELECT id FROM devices WHERE name='RDMmunich'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMfrankfurt') AND name='2013' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmunich') AND name='2001' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMfrankfurt->RDMmunich_2',
    (SELECT id FROM devices WHERE name='RDMfrankfurt'),
    (SELECT id FROM devices WHERE name='RDMmunich'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMfrankfurt') AND name='2014' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmunich') AND name='2002' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMfrankfurt->RDMmunich_3',
    (SELECT id FROM devices WHERE name='RDMfrankfurt'),
    (SELECT id FROM devices WHERE name='RDMmunich'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMfrankfurt') AND name='2015' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmunich') AND name='2003' LIMIT 1),
    NOW(), NOW());

--- ZURICH-STRASBOURG (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMzurich->RDMstrasbourg_1',
    (SELECT id FROM devices WHERE name='RDMzurich'),
    (SELECT id FROM devices WHERE name='RDMstrasbourg'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMzurich') AND name='2001' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMstrasbourg') AND name='2004' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMzurich->RDMstrasbourg_2',
    (SELECT id FROM devices WHERE name='RDMzurich'),
    (SELECT id FROM devices WHERE name='RDMstrasbourg'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMzurich') AND name='2002' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMstrasbourg') AND name='2005' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMzurich->RDMstrasbourg_3',
    (SELECT id FROM devices WHERE name='RDMzurich'),
    (SELECT id FROM devices WHERE name='RDMstrasbourg'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMzurich') AND name='2003' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMstrasbourg') AND name='2006' LIMIT 1),
    NOW(), NOW());

--- ZURICH-MUNICH (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMzurich->RDMmunich_1',
    (SELECT id FROM devices WHERE name='RDMzurich'),
    (SELECT id FROM devices WHERE name='RDMmunich'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMzurich') AND name='2004' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmunich') AND name='2004' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMzurich->RDMmunich_2',
    (SELECT id FROM devices WHERE name='RDMzurich'),
    (SELECT id FROM devices WHERE name='RDMmunich'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMzurich') AND name='2005' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmunich') AND name='2005' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMzurich->RDMmunich_3',
    (SELECT id FROM devices WHERE name='RDMzurich'),
    (SELECT id FROM devices WHERE name='RDMmunich'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMzurich') AND name='2006' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmunich') AND name='2006' LIMIT 1),
    NOW(), NOW());

--- ZURICH-MILAN (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMzurich->RDMmilan_1',
    (SELECT id FROM devices WHERE name='RDMzurich'),
    (SELECT id FROM devices WHERE name='RDMmilan'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMzurich') AND name='2007' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmilan') AND name='2001' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMzurich->RDMmilan_2',
    (SELECT id FROM devices WHERE name='RDMzurich'),
    (SELECT id FROM devices WHERE name='RDMmilan'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMzurich') AND name='2008' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmilan') AND name='2002' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMzurich->RDMmilan_3',
    (SELECT id FROM devices WHERE name='RDMzurich'),
    (SELECT id FROM devices WHERE name='RDMmilan'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMzurich') AND name='2009' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmilan') AND name='2003' LIMIT 1),
    NOW(), NOW());

--- ZURICH-LYON (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMzurich->RDMlyon_1',
    (SELECT id FROM devices WHERE name='RDMzurich'),
    (SELECT id FROM devices WHERE name='RDMlyon'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMzurich') AND name='2010' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlyon') AND name='2001' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMzurich->RDMlyon_2',
    (SELECT id FROM devices WHERE name='RDMzurich'),
    (SELECT id FROM devices WHERE name='RDMlyon'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMzurich') AND name='2011' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlyon') AND name='2002' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMzurich->RDMlyon_3',
    (SELECT id FROM devices WHERE name='RDMzurich'),
    (SELECT id FROM devices WHERE name='RDMlyon'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMzurich') AND name='2012' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlyon') AND name='2003' LIMIT 1),
    NOW(), NOW());

--- MUNICH-PRAGUE (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMmunich->RDMprague_1',
    (SELECT id FROM devices WHERE name='RDMmunich'),
    (SELECT id FROM devices WHERE name='RDMprague'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmunich') AND name='2007' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMprague') AND name='2007' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMmunich->RDMprague_2',
    (SELECT id FROM devices WHERE name='RDMmunich'),
    (SELECT id FROM devices WHERE name='RDMprague'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmunich') AND name='2008' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMprague') AND name='2008' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMmunich->RDMprague_3',
    (SELECT id FROM devices WHERE name='RDMmunich'),
    (SELECT id FROM devices WHERE name='RDMprague'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmunich') AND name='2009' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMprague') AND name='2009' LIMIT 1),
    NOW(), NOW());

--- MUNICH-MILAN (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMmunich->RDMmilan_1',
    (SELECT id FROM devices WHERE name='RDMmunich'),
    (SELECT id FROM devices WHERE name='RDMmilan'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmunich') AND name='2010' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmilan') AND name='2004' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMmunich->RDMmilan_2',
    (SELECT id FROM devices WHERE name='RDMmunich'),
    (SELECT id FROM devices WHERE name='RDMmilan'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmunich') AND name='2011' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmilan') AND name='2005' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMmunich->RDMmilan_3',
    (SELECT id FROM devices WHERE name='RDMmunich'),
    (SELECT id FROM devices WHERE name='RDMmilan'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmunich') AND name='2012' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmilan') AND name='2006' LIMIT 1),
    NOW(), NOW());

--- MUNICH-VIENNA (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMmunich->RDMvienna_1',
    (SELECT id FROM devices WHERE name='RDMmunich'),
    (SELECT id FROM devices WHERE name='RDMvienna'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmunich') AND name='2013' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMvienna') AND name='2001' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMmunich->RDMvienna_2',
    (SELECT id FROM devices WHERE name='RDMmunich'),
    (SELECT id FROM devices WHERE name='RDMvienna'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmunich') AND name='2014' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMvienna') AND name='2002' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMmunich->RDMvienna_3',
    (SELECT id FROM devices WHERE name='RDMmunich'),
    (SELECT id FROM devices WHERE name='RDMvienna'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmunich') AND name='2015' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMvienna') AND name='2003' LIMIT 1),
    NOW(), NOW());

--- STRASBOURG-LYON (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMstrasbourg->RDMlyon_1',
    (SELECT id FROM devices WHERE name='RDMstrasbourg'),
    (SELECT id FROM devices WHERE name='RDMlyon'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMstrasbourg') AND name='2007' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlyon') AND name='2004' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMstrasbourg->RDMlyon_2',
    (SELECT id FROM devices WHERE name='RDMstrasbourg'),
    (SELECT id FROM devices WHERE name='RDMlyon'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMstrasbourg') AND name='2008' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlyon') AND name='2005' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMstrasbourg->RDMlyon_3',
    (SELECT id FROM devices WHERE name='RDMstrasbourg'),
    (SELECT id FROM devices WHERE name='RDMlyon'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMstrasbourg') AND name='2009' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlyon') AND name='2006' LIMIT 1),
    NOW(), NOW());

--- LYON-PARIS (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMlyon->RDMparis_1',
    (SELECT id FROM devices WHERE name='RDMlyon'),
    (SELECT id FROM devices WHERE name='RDMparis'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlyon') AND name='2007' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMparis') AND name='2019' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMlyon->RDMparis_2',
    (SELECT id FROM devices WHERE name='RDMlyon'),
    (SELECT id FROM devices WHERE name='RDMparis'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlyon') AND name='2008' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMparis') AND name='2020' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMlyon->RDMparis_3',
    (SELECT id FROM devices WHERE name='RDMlyon'),
    (SELECT id FROM devices WHERE name='RDMparis'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlyon') AND name='2009' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMparis') AND name='2021' LIMIT 1),
    NOW(), NOW());

--- LYON-BORDEAUX (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMlyon->RDMbordeaux_1',
    (SELECT id FROM devices WHERE name='RDMlyon'),
    (SELECT id FROM devices WHERE name='RDMbordeaux'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlyon') AND name='2010' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbordeaux') AND name='2004' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMlyon->RDMbordeaux_2',
    (SELECT id FROM devices WHERE name='RDMlyon'),
    (SELECT id FROM devices WHERE name='RDMbordeaux'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlyon') AND name='2011' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbordeaux') AND name='2005' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMlyon->RDMbordeaux_3',
    (SELECT id FROM devices WHERE name='RDMlyon'),
    (SELECT id FROM devices WHERE name='RDMbordeaux'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlyon') AND name='2012' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbordeaux') AND name='2006' LIMIT 1),
    NOW(), NOW());

--- LYON-BARCELONA (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMlyon->RDMbarcelona_1',
    (SELECT id FROM devices WHERE name='RDMlyon'),
    (SELECT id FROM devices WHERE name='RDMbarcelona'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlyon') AND name='2013' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbarcelona') AND name='2001' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMlyon->RDMbarcelona_2',
    (SELECT id FROM devices WHERE name='RDMlyon'),
    (SELECT id FROM devices WHERE name='RDMbarcelona'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlyon') AND name='2014' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbarcelona') AND name='2002' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMlyon->RDMbarcelona_3',
    (SELECT id FROM devices WHERE name='RDMlyon'),
    (SELECT id FROM devices WHERE name='RDMbarcelona'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlyon') AND name='2015' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbarcelona') AND name='2003' LIMIT 1),
    NOW(), NOW());

--- LYON-MILAN (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMlyon->RDMmilan_1',
    (SELECT id FROM devices WHERE name='RDMlyon'),
    (SELECT id FROM devices WHERE name='RDMmilan'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlyon') AND name='2016' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmilan') AND name='2007' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMlyon->RDMmilan_2',
    (SELECT id FROM devices WHERE name='RDMlyon'),
    (SELECT id FROM devices WHERE name='RDMmilan'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlyon') AND name='2017' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmilan') AND name='2008' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMlyon->RDMmilan_3',
    (SELECT id FROM devices WHERE name='RDMlyon'),
    (SELECT id FROM devices WHERE name='RDMmilan'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlyon') AND name='2018' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmilan') AND name='2009' LIMIT 1),
    NOW(), NOW());

--- BORDEAUX-BARCELONA (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMbordeaux->RDMbarcelona_1',
    (SELECT id FROM devices WHERE name='RDMbordeaux'),
    (SELECT id FROM devices WHERE name='RDMbarcelona'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbordeaux') AND name='2007' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbarcelona') AND name='2004' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMbordeaux->RDMbarcelona_2',
    (SELECT id FROM devices WHERE name='RDMbordeaux'),
    (SELECT id FROM devices WHERE name='RDMbarcelona'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbordeaux') AND name='2008' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbarcelona') AND name='2005' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMbordeaux->RDMbarcelona_3',
    (SELECT id FROM devices WHERE name='RDMbordeaux'),
    (SELECT id FROM devices WHERE name='RDMbarcelona'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbordeaux') AND name='2009' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbarcelona') AND name='2006' LIMIT 1),
    NOW(), NOW());

--- BORDEAUX-MADRID (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMbordeaux->RDMmadrid_1',
    (SELECT id FROM devices WHERE name='RDMbordeaux'),
    (SELECT id FROM devices WHERE name='RDMmadrid'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbordeaux') AND name='2010' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmadrid') AND name='2001' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMbordeaux->RDMmadrid_2',
    (SELECT id FROM devices WHERE name='RDMbordeaux'),
    (SELECT id FROM devices WHERE name='RDMmadrid'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbordeaux') AND name='2011' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmadrid') AND name='2002' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMbordeaux->RDMmadrid_3',
    (SELECT id FROM devices WHERE name='RDMbordeaux'),
    (SELECT id FROM devices WHERE name='RDMmadrid'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbordeaux') AND name='2012' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmadrid') AND name='2003' LIMIT 1),
    NOW(), NOW());

--- BARCELONA-MADRID (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMbarcelona->RDMmadrid_1',
    (SELECT id FROM devices WHERE name='RDMbarcelona'),
    (SELECT id FROM devices WHERE name='RDMmadrid'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbarcelona') AND name='2007' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmadrid') AND name='2004' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMbarcelona->RDMmadrid_2',
    (SELECT id FROM devices WHERE name='RDMbarcelona'),
    (SELECT id FROM devices WHERE name='RDMmadrid'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbarcelona') AND name='2008' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmadrid') AND name='2005' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMbarcelona->RDMmadrid_3',
    (SELECT id FROM devices WHERE name='RDMbarcelona'),
    (SELECT id FROM devices WHERE name='RDMmadrid'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbarcelona') AND name='2009' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmadrid') AND name='2006' LIMIT 1),
    NOW(), NOW());

--- MILAN-VIENNA (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMmilan->RDMvienna_1',
    (SELECT id FROM devices WHERE name='RDMmilan'),
    (SELECT id FROM devices WHERE name='RDMvienna'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmilan') AND name='2010' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMvienna') AND name='2004' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMmilan->RDMvienna_2',
    (SELECT id FROM devices WHERE name='RDMmilan'),
    (SELECT id FROM devices WHERE name='RDMvienna'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmilan') AND name='2011' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMvienna') AND name='2005' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMmilan->RDMvienna_3',
    (SELECT id FROM devices WHERE name='RDMmilan'),
    (SELECT id FROM devices WHERE name='RDMvienna'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmilan') AND name='2012' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMvienna') AND name='2006' LIMIT 1),
    NOW(), NOW());

--- MILAN-ROME (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMmilan->RDMrome_1',
    (SELECT id FROM devices WHERE name='RDMmilan'),
    (SELECT id FROM devices WHERE name='RDMrome'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmilan') AND name='2013' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMrome') AND name='2001' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMmilan->RDMrome_2',
    (SELECT id FROM devices WHERE name='RDMmilan'),
    (SELECT id FROM devices WHERE name='RDMrome'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmilan') AND name='2014' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMrome') AND name='2002' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMmilan->RDMrome_3',
    (SELECT id FROM devices WHERE name='RDMmilan'),
    (SELECT id FROM devices WHERE name='RDMrome'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmilan') AND name='2015' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMrome') AND name='2003' LIMIT 1),
    NOW(), NOW());

--- PRAGUE-WARSAW (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMprague->RDMwarsaw_1',
    (SELECT id FROM devices WHERE name='RDMprague'),
    (SELECT id FROM devices WHERE name='RDMwarsaw'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMprague') AND name='2010' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMwarsaw') AND name='2007' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMprague->RDMwarsaw_2',
    (SELECT id FROM devices WHERE name='RDMprague'),
    (SELECT id FROM devices WHERE name='RDMwarsaw'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMprague') AND name='2011' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMwarsaw') AND name='2008' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMprague->RDMwarsaw_3',
    (SELECT id FROM devices WHERE name='RDMprague'),
    (SELECT id FROM devices WHERE name='RDMwarsaw'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMprague') AND name='2012' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMwarsaw') AND name='2009' LIMIT 1),
    NOW(), NOW());

--- PRAGUE-BUDAPEST (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMprague->RDMbudapest_1',
    (SELECT id FROM devices WHERE name='RDMprague'),
    (SELECT id FROM devices WHERE name='RDMbudapest'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMprague') AND name='2013' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbudapest') AND name='2001' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMprague->RDMbudapest_2',
    (SELECT id FROM devices WHERE name='RDMprague'),
    (SELECT id FROM devices WHERE name='RDMbudapest'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMprague') AND name='2014' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbudapest') AND name='2002' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMprague->RDMbudapest_3',
    (SELECT id FROM devices WHERE name='RDMprague'),
    (SELECT id FROM devices WHERE name='RDMbudapest'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMprague') AND name='2015' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbudapest') AND name='2003' LIMIT 1),
    NOW(), NOW());

--- PRAGUE-VIENNA (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMprague->RDMvienna_1',
    (SELECT id FROM devices WHERE name='RDMprague'),
    (SELECT id FROM devices WHERE name='RDMvienna'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMprague') AND name='2016' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMvienna') AND name='2007' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMprague->RDMvienna_2',
    (SELECT id FROM devices WHERE name='RDMprague'),
    (SELECT id FROM devices WHERE name='RDMvienna'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMprague') AND name='2017' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMvienna') AND name='2008' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMprague->RDMvienna_3',
    (SELECT id FROM devices WHERE name='RDMprague'),
    (SELECT id FROM devices WHERE name='RDMvienna'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMprague') AND name='2018' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMvienna') AND name='2009' LIMIT 1),
    NOW(), NOW());

--- WARSAW-BUDAPEST (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMwarsaw->RDMbudapest_1',
    (SELECT id FROM devices WHERE name='RDMwarsaw'),
    (SELECT id FROM devices WHERE name='RDMbudapest'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMwarsaw') AND name='2010' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbudapest') AND name='2004' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMwarsaw->RDMbudapest_2',
    (SELECT id FROM devices WHERE name='RDMwarsaw'),
    (SELECT id FROM devices WHERE name='RDMbudapest'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMwarsaw') AND name='2011' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbudapest') AND name='2005' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMwarsaw->RDMbudapest_3',
    (SELECT id FROM devices WHERE name='RDMwarsaw'),
    (SELECT id FROM devices WHERE name='RDMbudapest'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMwarsaw') AND name='2012' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbudapest') AND name='2006' LIMIT 1),
    NOW(), NOW());

--- BUDAPEST-VIENNA (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMbudapest->RDMvienna_1',
    (SELECT id FROM devices WHERE name='RDMbudapest'),
    (SELECT id FROM devices WHERE name='RDMvienna'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbudapest') AND name='2007' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMvienna') AND name='2010' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMbudapest->RDMvienna_2',
    (SELECT id FROM devices WHERE name='RDMbudapest'),
    (SELECT id FROM devices WHERE name='RDMvienna'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbudapest') AND name='2008' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMvienna') AND name='2011' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMbudapest->RDMvienna_3',
    (SELECT id FROM devices WHERE name='RDMbudapest'),
    (SELECT id FROM devices WHERE name='RDMvienna'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbudapest') AND name='2009' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMvienna') AND name='2012' LIMIT 1),
    NOW(), NOW());

--- BUDAPEST-BELGRADE (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMbudapest->RDMbelgrade_1',
    (SELECT id FROM devices WHERE name='RDMbudapest'),
    (SELECT id FROM devices WHERE name='RDMbelgrade'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbudapest') AND name='2010' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbelgrade') AND name='2001' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMbudapest->RDMbelgrade_2',
    (SELECT id FROM devices WHERE name='RDMbudapest'),
    (SELECT id FROM devices WHERE name='RDMbelgrade'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbudapest') AND name='2011' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbelgrade') AND name='2002' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMbudapest->RDMbelgrade_3',
    (SELECT id FROM devices WHERE name='RDMbudapest'),
    (SELECT id FROM devices WHERE name='RDMbelgrade'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbudapest') AND name='2012' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbelgrade') AND name='2003' LIMIT 1),
    NOW(), NOW());

--- VIENNA-ROME (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMvienna->RDMrome_1',
    (SELECT id FROM devices WHERE name='RDMvienna'),
    (SELECT id FROM devices WHERE name='RDMrome'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMvienna') AND name='2013' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMrome') AND name='2004' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMvienna->RDMrome_2',
    (SELECT id FROM devices WHERE name='RDMvienna'),
    (SELECT id FROM devices WHERE name='RDMrome'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMvienna') AND name='2014' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMrome') AND name='2005' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMvienna->RDMrome_3',
    (SELECT id FROM devices WHERE name='RDMvienna'),
    (SELECT id FROM devices WHERE name='RDMrome'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMvienna') AND name='2015' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMrome') AND name='2006' LIMIT 1),
    NOW(), NOW());

--- VIENNA-BELGRADE (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMvienna->RDMbelgrade_1',
    (SELECT id FROM devices WHERE name='RDMvienna'),
    (SELECT id FROM devices WHERE name='RDMbelgrade'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMvienna') AND name='2016' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbelgrade') AND name='2004' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMvienna->RDMbelgrade_2',
    (SELECT id FROM devices WHERE name='RDMvienna'),
    (SELECT id FROM devices WHERE name='RDMbelgrade'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMvienna') AND name='2017' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbelgrade') AND name='2005' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMvienna->RDMbelgrade_3',
    (SELECT id FROM devices WHERE name='RDMvienna'),
    (SELECT id FROM devices WHERE name='RDMbelgrade'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMvienna') AND name='2018' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbelgrade') AND name='2006' LIMIT 1),
    NOW(), NOW());

--- ROME-BELGRADE (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMrome->RDMbelgrade_1',
    (SELECT id FROM devices WHERE name='RDMrome'),
    (SELECT id FROM devices WHERE name='RDMbelgrade'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMrome') AND name='2007' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbelgrade') AND name='2007' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMrome->RDMbelgrade_2',
    (SELECT id FROM devices WHERE name='RDMrome'),
    (SELECT id FROM devices WHERE name='RDMbelgrade'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMrome') AND name='2008' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbelgrade') AND name='2008' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMrome->RDMbelgrade_3',
    (SELECT id FROM devices WHERE name='RDMrome'),
    (SELECT id FROM devices WHERE name='RDMbelgrade'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMrome') AND name='2009' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbelgrade') AND name='2009' LIMIT 1),
    NOW(), NOW());

--- ROME-ATHENS (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMrome->RDMathens_1',
    (SELECT id FROM devices WHERE name='RDMrome'),
    (SELECT id FROM devices WHERE name='RDMathens'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMrome') AND name='2010' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMathens') AND name='2001' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMrome->RDMathens_2',
    (SELECT id FROM devices WHERE name='RDMrome'),
    (SELECT id FROM devices WHERE name='RDMathens'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMrome') AND name='2011' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMathens') AND name='2002' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMrome->RDMathens_3',
    (SELECT id FROM devices WHERE name='RDMrome'),
    (SELECT id FROM devices WHERE name='RDMathens'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMrome') AND name='2012' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMathens') AND name='2003' LIMIT 1),
    NOW(), NOW());

--- BELGRADE-ATHENS (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMbelgrade->RDMathens_1',
    (SELECT id FROM devices WHERE name='RDMbelgrade'),
    (SELECT id FROM devices WHERE name='RDMathens'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbelgrade') AND name='2010' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMathens') AND name='2004' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMbelgrade->RDMathens_2',
    (SELECT id FROM devices WHERE name='RDMbelgrade'),
    (SELECT id FROM devices WHERE name='RDMathens'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbelgrade') AND name='2011' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMathens') AND name='2005' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMbelgrade->RDMathens_3',
    (SELECT id FROM devices WHERE name='RDMbelgrade'),
    (SELECT id FROM devices WHERE name='RDMathens'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbelgrade') AND name='2012' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMathens') AND name='2006' LIMIT 1),
    NOW(), NOW());

