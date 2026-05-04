-- Pan-EU Topology: Optical Links (PARALLEL - 3 links per connection)
-- 28 nodes, 41 connections x 3 = 123 total links

--- DUBLIN-GLASGOW (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMdublin->RDMglasgow_1',
    (SELECT id FROM devices WHERE name='RDMdublin'),
    (SELECT id FROM devices WHERE name='RDMglasgow'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMdublin') AND name='2001' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMglasgow') AND name='2001' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMdublin->RDMglasgow_2',
    (SELECT id FROM devices WHERE name='RDMdublin'),
    (SELECT id FROM devices WHERE name='RDMglasgow'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMdublin') AND name='2002' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMglasgow') AND name='2002' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMdublin->RDMglasgow_3',
    (SELECT id FROM devices WHERE name='RDMdublin'),
    (SELECT id FROM devices WHERE name='RDMglasgow'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMdublin') AND name='2003' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMglasgow') AND name='2003' LIMIT 1),
    NOW(), NOW());

--- DUBLIN-LONDON (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMdublin->RDMlondon_1',
    (SELECT id FROM devices WHERE name='RDMdublin'),
    (SELECT id FROM devices WHERE name='RDMlondon'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMdublin') AND name='2004' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlondon') AND name='2001' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMdublin->RDMlondon_2',
    (SELECT id FROM devices WHERE name='RDMdublin'),
    (SELECT id FROM devices WHERE name='RDMlondon'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMdublin') AND name='2005' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlondon') AND name='2002' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMdublin->RDMlondon_3',
    (SELECT id FROM devices WHERE name='RDMdublin'),
    (SELECT id FROM devices WHERE name='RDMlondon'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMdublin') AND name='2006' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlondon') AND name='2003' LIMIT 1),
    NOW(), NOW());

--- GLASGOW-LONDON (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMglasgow->RDMlondon_1',
    (SELECT id FROM devices WHERE name='RDMglasgow'),
    (SELECT id FROM devices WHERE name='RDMlondon'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMglasgow') AND name='2004' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlondon') AND name='2004' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMglasgow->RDMlondon_2',
    (SELECT id FROM devices WHERE name='RDMglasgow'),
    (SELECT id FROM devices WHERE name='RDMlondon'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMglasgow') AND name='2005' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlondon') AND name='2005' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMglasgow->RDMlondon_3',
    (SELECT id FROM devices WHERE name='RDMglasgow'),
    (SELECT id FROM devices WHERE name='RDMlondon'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMglasgow') AND name='2006' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlondon') AND name='2006' LIMIT 1),
    NOW(), NOW());

--- OSLO-COPENHAGEN (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMoslo->RDMcopenhagen_1',
    (SELECT id FROM devices WHERE name='RDMoslo'),
    (SELECT id FROM devices WHERE name='RDMcopenhagen'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMoslo') AND name='2001' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMcopenhagen') AND name='2001' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMoslo->RDMcopenhagen_2',
    (SELECT id FROM devices WHERE name='RDMoslo'),
    (SELECT id FROM devices WHERE name='RDMcopenhagen'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMoslo') AND name='2002' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMcopenhagen') AND name='2002' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMoslo->RDMcopenhagen_3',
    (SELECT id FROM devices WHERE name='RDMoslo'),
    (SELECT id FROM devices WHERE name='RDMcopenhagen'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMoslo') AND name='2003' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMcopenhagen') AND name='2003' LIMIT 1),
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

--- STOCKHOLM-WARSAW (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMstockholm->RDMwarsaw_1',
    (SELECT id FROM devices WHERE name='RDMstockholm'),
    (SELECT id FROM devices WHERE name='RDMwarsaw'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMstockholm') AND name='2004' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMwarsaw') AND name='2001' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMstockholm->RDMwarsaw_2',
    (SELECT id FROM devices WHERE name='RDMstockholm'),
    (SELECT id FROM devices WHERE name='RDMwarsaw'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMstockholm') AND name='2005' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMwarsaw') AND name='2002' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMstockholm->RDMwarsaw_3',
    (SELECT id FROM devices WHERE name='RDMstockholm'),
    (SELECT id FROM devices WHERE name='RDMwarsaw'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMstockholm') AND name='2006' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMwarsaw') AND name='2003' LIMIT 1),
    NOW(), NOW());

--- COPENHAGEN-HAMBURG (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMcopenhagen->RDMhamburg_1',
    (SELECT id FROM devices WHERE name='RDMcopenhagen'),
    (SELECT id FROM devices WHERE name='RDMhamburg'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMcopenhagen') AND name='2004' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMhamburg') AND name='2001' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMcopenhagen->RDMhamburg_2',
    (SELECT id FROM devices WHERE name='RDMcopenhagen'),
    (SELECT id FROM devices WHERE name='RDMhamburg'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMcopenhagen') AND name='2005' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMhamburg') AND name='2002' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMcopenhagen->RDMhamburg_3',
    (SELECT id FROM devices WHERE name='RDMcopenhagen'),
    (SELECT id FROM devices WHERE name='RDMhamburg'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMcopenhagen') AND name='2006' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMhamburg') AND name='2003' LIMIT 1),
    NOW(), NOW());

--- COPENHAGEN-BERLIN (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMcopenhagen->RDMberlin_1',
    (SELECT id FROM devices WHERE name='RDMcopenhagen'),
    (SELECT id FROM devices WHERE name='RDMberlin'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMcopenhagen') AND name='2007' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMberlin') AND name='2001' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMcopenhagen->RDMberlin_2',
    (SELECT id FROM devices WHERE name='RDMcopenhagen'),
    (SELECT id FROM devices WHERE name='RDMberlin'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMcopenhagen') AND name='2008' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMberlin') AND name='2002' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMcopenhagen->RDMberlin_3',
    (SELECT id FROM devices WHERE name='RDMcopenhagen'),
    (SELECT id FROM devices WHERE name='RDMberlin'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMcopenhagen') AND name='2009' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMberlin') AND name='2003' LIMIT 1),
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
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMparis') AND name='2001' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMlondon->RDMparis_2',
    (SELECT id FROM devices WHERE name='RDMlondon'),
    (SELECT id FROM devices WHERE name='RDMparis'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlondon') AND name='2014' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMparis') AND name='2002' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMlondon->RDMparis_3',
    (SELECT id FROM devices WHERE name='RDMlondon'),
    (SELECT id FROM devices WHERE name='RDMparis'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlondon') AND name='2015' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMparis') AND name='2003' LIMIT 1),
    NOW(), NOW());

--- AMSTERDAM-HAMBURG (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMamsterdam->RDMhamburg_1',
    (SELECT id FROM devices WHERE name='RDMamsterdam'),
    (SELECT id FROM devices WHERE name='RDMhamburg'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMamsterdam') AND name='2004' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMhamburg') AND name='2004' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMamsterdam->RDMhamburg_2',
    (SELECT id FROM devices WHERE name='RDMamsterdam'),
    (SELECT id FROM devices WHERE name='RDMhamburg'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMamsterdam') AND name='2005' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMhamburg') AND name='2005' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMamsterdam->RDMhamburg_3',
    (SELECT id FROM devices WHERE name='RDMamsterdam'),
    (SELECT id FROM devices WHERE name='RDMhamburg'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMamsterdam') AND name='2006' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMhamburg') AND name='2006' LIMIT 1),
    NOW(), NOW());

--- AMSTERDAM-FRANKFURT (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMamsterdam->RDMfrankfurt_1',
    (SELECT id FROM devices WHERE name='RDMamsterdam'),
    (SELECT id FROM devices WHERE name='RDMfrankfurt'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMamsterdam') AND name='2007' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMfrankfurt') AND name='2001' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMamsterdam->RDMfrankfurt_2',
    (SELECT id FROM devices WHERE name='RDMamsterdam'),
    (SELECT id FROM devices WHERE name='RDMfrankfurt'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMamsterdam') AND name='2008' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMfrankfurt') AND name='2002' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMamsterdam->RDMfrankfurt_3',
    (SELECT id FROM devices WHERE name='RDMamsterdam'),
    (SELECT id FROM devices WHERE name='RDMfrankfurt'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMamsterdam') AND name='2009' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMfrankfurt') AND name='2003' LIMIT 1),
    NOW(), NOW());

--- BRUSSELS-PARIS (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMbrussels->RDMparis_1',
    (SELECT id FROM devices WHERE name='RDMbrussels'),
    (SELECT id FROM devices WHERE name='RDMparis'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbrussels') AND name='2004' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMparis') AND name='2004' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMbrussels->RDMparis_2',
    (SELECT id FROM devices WHERE name='RDMbrussels'),
    (SELECT id FROM devices WHERE name='RDMparis'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbrussels') AND name='2005' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMparis') AND name='2005' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMbrussels->RDMparis_3',
    (SELECT id FROM devices WHERE name='RDMbrussels'),
    (SELECT id FROM devices WHERE name='RDMparis'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbrussels') AND name='2006' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMparis') AND name='2006' LIMIT 1),
    NOW(), NOW());

--- BRUSSELS-FRANKFURT (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMbrussels->RDMfrankfurt_1',
    (SELECT id FROM devices WHERE name='RDMbrussels'),
    (SELECT id FROM devices WHERE name='RDMfrankfurt'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbrussels') AND name='2007' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMfrankfurt') AND name='2004' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMbrussels->RDMfrankfurt_2',
    (SELECT id FROM devices WHERE name='RDMbrussels'),
    (SELECT id FROM devices WHERE name='RDMfrankfurt'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbrussels') AND name='2008' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMfrankfurt') AND name='2005' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMbrussels->RDMfrankfurt_3',
    (SELECT id FROM devices WHERE name='RDMbrussels'),
    (SELECT id FROM devices WHERE name='RDMfrankfurt'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbrussels') AND name='2009' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMfrankfurt') AND name='2006' LIMIT 1),
    NOW(), NOW());

--- PARIS-STRASBOURG (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMparis->RDMstrasbourg_1',
    (SELECT id FROM devices WHERE name='RDMparis'),
    (SELECT id FROM devices WHERE name='RDMstrasbourg'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMparis') AND name='2007' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMstrasbourg') AND name='2001' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMparis->RDMstrasbourg_2',
    (SELECT id FROM devices WHERE name='RDMparis'),
    (SELECT id FROM devices WHERE name='RDMstrasbourg'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMparis') AND name='2008' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMstrasbourg') AND name='2002' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMparis->RDMstrasbourg_3',
    (SELECT id FROM devices WHERE name='RDMparis'),
    (SELECT id FROM devices WHERE name='RDMstrasbourg'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMparis') AND name='2009' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMstrasbourg') AND name='2003' LIMIT 1),
    NOW(), NOW());

--- PARIS-LYON (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMparis->RDMlyon_1',
    (SELECT id FROM devices WHERE name='RDMparis'),
    (SELECT id FROM devices WHERE name='RDMlyon'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMparis') AND name='2010' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlyon') AND name='2001' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMparis->RDMlyon_2',
    (SELECT id FROM devices WHERE name='RDMparis'),
    (SELECT id FROM devices WHERE name='RDMlyon'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMparis') AND name='2011' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlyon') AND name='2002' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMparis->RDMlyon_3',
    (SELECT id FROM devices WHERE name='RDMparis'),
    (SELECT id FROM devices WHERE name='RDMlyon'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMparis') AND name='2012' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlyon') AND name='2003' LIMIT 1),
    NOW(), NOW());

--- PARIS-BORDEAUX (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMparis->RDMbordeaux_1',
    (SELECT id FROM devices WHERE name='RDMparis'),
    (SELECT id FROM devices WHERE name='RDMbordeaux'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMparis') AND name='2013' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbordeaux') AND name='2001' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMparis->RDMbordeaux_2',
    (SELECT id FROM devices WHERE name='RDMparis'),
    (SELECT id FROM devices WHERE name='RDMbordeaux'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMparis') AND name='2014' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbordeaux') AND name='2002' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMparis->RDMbordeaux_3',
    (SELECT id FROM devices WHERE name='RDMparis'),
    (SELECT id FROM devices WHERE name='RDMbordeaux'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMparis') AND name='2015' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbordeaux') AND name='2003' LIMIT 1),
    NOW(), NOW());

--- HAMBURG-FRANKFURT (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMhamburg->RDMfrankfurt_1',
    (SELECT id FROM devices WHERE name='RDMhamburg'),
    (SELECT id FROM devices WHERE name='RDMfrankfurt'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMhamburg') AND name='2007' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMfrankfurt') AND name='2007' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMhamburg->RDMfrankfurt_2',
    (SELECT id FROM devices WHERE name='RDMhamburg'),
    (SELECT id FROM devices WHERE name='RDMfrankfurt'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMhamburg') AND name='2008' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMfrankfurt') AND name='2008' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMhamburg->RDMfrankfurt_3',
    (SELECT id FROM devices WHERE name='RDMhamburg'),
    (SELECT id FROM devices WHERE name='RDMfrankfurt'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMhamburg') AND name='2009' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMfrankfurt') AND name='2009' LIMIT 1),
    NOW(), NOW());

--- FRANKFURT-BERLIN (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMfrankfurt->RDMberlin_1',
    (SELECT id FROM devices WHERE name='RDMfrankfurt'),
    (SELECT id FROM devices WHERE name='RDMberlin'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMfrankfurt') AND name='2010' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMberlin') AND name='2004' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMfrankfurt->RDMberlin_2',
    (SELECT id FROM devices WHERE name='RDMfrankfurt'),
    (SELECT id FROM devices WHERE name='RDMberlin'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMfrankfurt') AND name='2011' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMberlin') AND name='2005' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMfrankfurt->RDMberlin_3',
    (SELECT id FROM devices WHERE name='RDMfrankfurt'),
    (SELECT id FROM devices WHERE name='RDMberlin'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMfrankfurt') AND name='2012' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMberlin') AND name='2006' LIMIT 1),
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

--- FRANKFURT-ZURICH (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMfrankfurt->RDMzurich_1',
    (SELECT id FROM devices WHERE name='RDMfrankfurt'),
    (SELECT id FROM devices WHERE name='RDMzurich'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMfrankfurt') AND name='2016' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMzurich') AND name='2001' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMfrankfurt->RDMzurich_2',
    (SELECT id FROM devices WHERE name='RDMfrankfurt'),
    (SELECT id FROM devices WHERE name='RDMzurich'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMfrankfurt') AND name='2017' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMzurich') AND name='2002' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMfrankfurt->RDMzurich_3',
    (SELECT id FROM devices WHERE name='RDMfrankfurt'),
    (SELECT id FROM devices WHERE name='RDMzurich'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMfrankfurt') AND name='2018' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMzurich') AND name='2003' LIMIT 1),
    NOW(), NOW());

--- FRANKFURT-PRAGUE (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMfrankfurt->RDMprague_1',
    (SELECT id FROM devices WHERE name='RDMfrankfurt'),
    (SELECT id FROM devices WHERE name='RDMprague'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMfrankfurt') AND name='2019' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMprague') AND name='2001' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMfrankfurt->RDMprague_2',
    (SELECT id FROM devices WHERE name='RDMfrankfurt'),
    (SELECT id FROM devices WHERE name='RDMprague'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMfrankfurt') AND name='2020' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMprague') AND name='2002' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMfrankfurt->RDMprague_3',
    (SELECT id FROM devices WHERE name='RDMfrankfurt'),
    (SELECT id FROM devices WHERE name='RDMprague'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMfrankfurt') AND name='2021' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMprague') AND name='2003' LIMIT 1),
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

--- BERLIN-PRAGUE (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMberlin->RDMprague_1',
    (SELECT id FROM devices WHERE name='RDMberlin'),
    (SELECT id FROM devices WHERE name='RDMprague'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMberlin') AND name='2010' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMprague') AND name='2004' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMberlin->RDMprague_2',
    (SELECT id FROM devices WHERE name='RDMberlin'),
    (SELECT id FROM devices WHERE name='RDMprague'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMberlin') AND name='2011' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMprague') AND name='2005' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMberlin->RDMprague_3',
    (SELECT id FROM devices WHERE name='RDMberlin'),
    (SELECT id FROM devices WHERE name='RDMprague'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMberlin') AND name='2012' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMprague') AND name='2006' LIMIT 1),
    NOW(), NOW());

--- STRASBOURG-ZURICH (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMstrasbourg->RDMzurich_1',
    (SELECT id FROM devices WHERE name='RDMstrasbourg'),
    (SELECT id FROM devices WHERE name='RDMzurich'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMstrasbourg') AND name='2004' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMzurich') AND name='2004' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMstrasbourg->RDMzurich_2',
    (SELECT id FROM devices WHERE name='RDMstrasbourg'),
    (SELECT id FROM devices WHERE name='RDMzurich'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMstrasbourg') AND name='2005' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMzurich') AND name='2005' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMstrasbourg->RDMzurich_3',
    (SELECT id FROM devices WHERE name='RDMstrasbourg'),
    (SELECT id FROM devices WHERE name='RDMzurich'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMstrasbourg') AND name='2006' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMzurich') AND name='2006' LIMIT 1),
    NOW(), NOW());

--- ZURICH-MUNICH (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMzurich->RDMmunich_1',
    (SELECT id FROM devices WHERE name='RDMzurich'),
    (SELECT id FROM devices WHERE name='RDMmunich'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMzurich') AND name='2007' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmunich') AND name='2004' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMzurich->RDMmunich_2',
    (SELECT id FROM devices WHERE name='RDMzurich'),
    (SELECT id FROM devices WHERE name='RDMmunich'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMzurich') AND name='2008' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmunich') AND name='2005' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMzurich->RDMmunich_3',
    (SELECT id FROM devices WHERE name='RDMzurich'),
    (SELECT id FROM devices WHERE name='RDMmunich'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMzurich') AND name='2009' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmunich') AND name='2006' LIMIT 1),
    NOW(), NOW());

--- ZURICH-LYON (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMzurich->RDMlyon_1',
    (SELECT id FROM devices WHERE name='RDMzurich'),
    (SELECT id FROM devices WHERE name='RDMlyon'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMzurich') AND name='2010' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlyon') AND name='2004' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMzurich->RDMlyon_2',
    (SELECT id FROM devices WHERE name='RDMzurich'),
    (SELECT id FROM devices WHERE name='RDMlyon'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMzurich') AND name='2011' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlyon') AND name='2005' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMzurich->RDMlyon_3',
    (SELECT id FROM devices WHERE name='RDMzurich'),
    (SELECT id FROM devices WHERE name='RDMlyon'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMzurich') AND name='2012' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlyon') AND name='2006' LIMIT 1),
    NOW(), NOW());

--- MUNICH-VIENNA (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMmunich->RDMvienna_1',
    (SELECT id FROM devices WHERE name='RDMmunich'),
    (SELECT id FROM devices WHERE name='RDMvienna'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmunich') AND name='2007' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMvienna') AND name='2001' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMmunich->RDMvienna_2',
    (SELECT id FROM devices WHERE name='RDMmunich'),
    (SELECT id FROM devices WHERE name='RDMvienna'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmunich') AND name='2008' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMvienna') AND name='2002' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMmunich->RDMvienna_3',
    (SELECT id FROM devices WHERE name='RDMmunich'),
    (SELECT id FROM devices WHERE name='RDMvienna'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmunich') AND name='2009' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMvienna') AND name='2003' LIMIT 1),
    NOW(), NOW());

--- MUNICH-MILAN (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMmunich->RDMmilan_1',
    (SELECT id FROM devices WHERE name='RDMmunich'),
    (SELECT id FROM devices WHERE name='RDMmilan'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmunich') AND name='2010' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmilan') AND name='2001' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMmunich->RDMmilan_2',
    (SELECT id FROM devices WHERE name='RDMmunich'),
    (SELECT id FROM devices WHERE name='RDMmilan'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmunich') AND name='2011' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmilan') AND name='2002' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMmunich->RDMmilan_3',
    (SELECT id FROM devices WHERE name='RDMmunich'),
    (SELECT id FROM devices WHERE name='RDMmilan'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmunich') AND name='2012' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmilan') AND name='2003' LIMIT 1),
    NOW(), NOW());

--- MILAN-TURIN (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMmilan->RDMturin_1',
    (SELECT id FROM devices WHERE name='RDMmilan'),
    (SELECT id FROM devices WHERE name='RDMturin'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmilan') AND name='2004' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMturin') AND name='2001' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMmilan->RDMturin_2',
    (SELECT id FROM devices WHERE name='RDMmilan'),
    (SELECT id FROM devices WHERE name='RDMturin'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmilan') AND name='2005' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMturin') AND name='2002' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMmilan->RDMturin_3',
    (SELECT id FROM devices WHERE name='RDMmilan'),
    (SELECT id FROM devices WHERE name='RDMturin'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmilan') AND name='2006' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMturin') AND name='2003' LIMIT 1),
    NOW(), NOW());

--- LYON-TURIN (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMlyon->RDMturin_1',
    (SELECT id FROM devices WHERE name='RDMlyon'),
    (SELECT id FROM devices WHERE name='RDMturin'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlyon') AND name='2007' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMturin') AND name='2004' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMlyon->RDMturin_2',
    (SELECT id FROM devices WHERE name='RDMlyon'),
    (SELECT id FROM devices WHERE name='RDMturin'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlyon') AND name='2008' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMturin') AND name='2005' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMlyon->RDMturin_3',
    (SELECT id FROM devices WHERE name='RDMlyon'),
    (SELECT id FROM devices WHERE name='RDMturin'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlyon') AND name='2009' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMturin') AND name='2006' LIMIT 1),
    NOW(), NOW());

--- LYON-BARCELONA (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMlyon->RDMbarcelona_1',
    (SELECT id FROM devices WHERE name='RDMlyon'),
    (SELECT id FROM devices WHERE name='RDMbarcelona'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlyon') AND name='2010' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbarcelona') AND name='2001' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMlyon->RDMbarcelona_2',
    (SELECT id FROM devices WHERE name='RDMlyon'),
    (SELECT id FROM devices WHERE name='RDMbarcelona'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlyon') AND name='2011' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbarcelona') AND name='2002' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMlyon->RDMbarcelona_3',
    (SELECT id FROM devices WHERE name='RDMlyon'),
    (SELECT id FROM devices WHERE name='RDMbarcelona'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMlyon') AND name='2012' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbarcelona') AND name='2003' LIMIT 1),
    NOW(), NOW());

--- VIENNA-PRAGUE (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMvienna->RDMprague_1',
    (SELECT id FROM devices WHERE name='RDMvienna'),
    (SELECT id FROM devices WHERE name='RDMprague'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMvienna') AND name='2004' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMprague') AND name='2007' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMvienna->RDMprague_2',
    (SELECT id FROM devices WHERE name='RDMvienna'),
    (SELECT id FROM devices WHERE name='RDMprague'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMvienna') AND name='2005' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMprague') AND name='2008' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMvienna->RDMprague_3',
    (SELECT id FROM devices WHERE name='RDMvienna'),
    (SELECT id FROM devices WHERE name='RDMprague'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMvienna') AND name='2006' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMprague') AND name='2009' LIMIT 1),
    NOW(), NOW());

--- VIENNA-BUDAPEST (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMvienna->RDMbudapest_1',
    (SELECT id FROM devices WHERE name='RDMvienna'),
    (SELECT id FROM devices WHERE name='RDMbudapest'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMvienna') AND name='2007' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbudapest') AND name='2001' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMvienna->RDMbudapest_2',
    (SELECT id FROM devices WHERE name='RDMvienna'),
    (SELECT id FROM devices WHERE name='RDMbudapest'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMvienna') AND name='2008' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbudapest') AND name='2002' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMvienna->RDMbudapest_3',
    (SELECT id FROM devices WHERE name='RDMvienna'),
    (SELECT id FROM devices WHERE name='RDMbudapest'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMvienna') AND name='2009' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbudapest') AND name='2003' LIMIT 1),
    NOW(), NOW());

--- BUDAPEST-BELGRADE (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMbudapest->RDMbelgrade_1',
    (SELECT id FROM devices WHERE name='RDMbudapest'),
    (SELECT id FROM devices WHERE name='RDMbelgrade'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbudapest') AND name='2004' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbelgrade') AND name='2001' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMbudapest->RDMbelgrade_2',
    (SELECT id FROM devices WHERE name='RDMbudapest'),
    (SELECT id FROM devices WHERE name='RDMbelgrade'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbudapest') AND name='2005' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbelgrade') AND name='2002' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMbudapest->RDMbelgrade_3',
    (SELECT id FROM devices WHERE name='RDMbudapest'),
    (SELECT id FROM devices WHERE name='RDMbelgrade'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbudapest') AND name='2006' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbelgrade') AND name='2003' LIMIT 1),
    NOW(), NOW());

--- MILAN-ROME (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMmilan->RDMrome_1',
    (SELECT id FROM devices WHERE name='RDMmilan'),
    (SELECT id FROM devices WHERE name='RDMrome'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmilan') AND name='2007' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMrome') AND name='2001' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMmilan->RDMrome_2',
    (SELECT id FROM devices WHERE name='RDMmilan'),
    (SELECT id FROM devices WHERE name='RDMrome'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmilan') AND name='2008' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMrome') AND name='2002' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMmilan->RDMrome_3',
    (SELECT id FROM devices WHERE name='RDMmilan'),
    (SELECT id FROM devices WHERE name='RDMrome'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmilan') AND name='2009' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMrome') AND name='2003' LIMIT 1),
    NOW(), NOW());

--- ROME-ATHENS (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMrome->RDMathens_1',
    (SELECT id FROM devices WHERE name='RDMrome'),
    (SELECT id FROM devices WHERE name='RDMathens'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMrome') AND name='2004' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMathens') AND name='2001' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMrome->RDMathens_2',
    (SELECT id FROM devices WHERE name='RDMrome'),
    (SELECT id FROM devices WHERE name='RDMathens'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMrome') AND name='2005' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMathens') AND name='2002' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMrome->RDMathens_3',
    (SELECT id FROM devices WHERE name='RDMrome'),
    (SELECT id FROM devices WHERE name='RDMathens'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMrome') AND name='2006' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMathens') AND name='2003' LIMIT 1),
    NOW(), NOW());

--- ATHENS-BELGRADE (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMathens->RDMbelgrade_1',
    (SELECT id FROM devices WHERE name='RDMathens'),
    (SELECT id FROM devices WHERE name='RDMbelgrade'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMathens') AND name='2004' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbelgrade') AND name='2004' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMathens->RDMbelgrade_2',
    (SELECT id FROM devices WHERE name='RDMathens'),
    (SELECT id FROM devices WHERE name='RDMbelgrade'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMathens') AND name='2005' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbelgrade') AND name='2005' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMathens->RDMbelgrade_3',
    (SELECT id FROM devices WHERE name='RDMathens'),
    (SELECT id FROM devices WHERE name='RDMbelgrade'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMathens') AND name='2006' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbelgrade') AND name='2006' LIMIT 1),
    NOW(), NOW());

--- BORDEAUX-MADRID (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMbordeaux->RDMmadrid_1',
    (SELECT id FROM devices WHERE name='RDMbordeaux'),
    (SELECT id FROM devices WHERE name='RDMmadrid'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbordeaux') AND name='2004' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmadrid') AND name='2001' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMbordeaux->RDMmadrid_2',
    (SELECT id FROM devices WHERE name='RDMbordeaux'),
    (SELECT id FROM devices WHERE name='RDMmadrid'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbordeaux') AND name='2005' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmadrid') AND name='2002' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMbordeaux->RDMmadrid_3',
    (SELECT id FROM devices WHERE name='RDMbordeaux'),
    (SELECT id FROM devices WHERE name='RDMmadrid'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbordeaux') AND name='2006' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmadrid') AND name='2003' LIMIT 1),
    NOW(), NOW());

--- BARCELONA-MADRID (3 parallel links)
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMbarcelona->RDMmadrid_1',
    (SELECT id FROM devices WHERE name='RDMbarcelona'),
    (SELECT id FROM devices WHERE name='RDMmadrid'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbarcelona') AND name='2004' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmadrid') AND name='2004' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMbarcelona->RDMmadrid_2',
    (SELECT id FROM devices WHERE name='RDMbarcelona'),
    (SELECT id FROM devices WHERE name='RDMmadrid'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbarcelona') AND name='2005' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmadrid') AND name='2005' LIMIT 1),
    NOW(), NOW());
INSERT INTO optical_links (id, name, src_device_id, dst_device_id, src_endpoint_id, dst_endpoint_id, created_at, updated_at) VALUES
  (gen_random_uuid(), 'RDMbarcelona->RDMmadrid_3',
    (SELECT id FROM devices WHERE name='RDMbarcelona'),
    (SELECT id FROM devices WHERE name='RDMmadrid'),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMbarcelona') AND name='2006' LIMIT 1),
    (SELECT id FROM endpoints WHERE device_id=(SELECT id FROM devices WHERE name='RDMmadrid') AND name='2006' LIMIT 1),
    NOW(), NOW());

