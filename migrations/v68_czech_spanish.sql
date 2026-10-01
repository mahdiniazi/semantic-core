-- v68 — اسکودا (چک)، سئات و کوپرا (اسپانیا)
.mode column
.headers on

BEGIN;

-- =====================================================================
-- ۱. انواع خودروی چک و اسپانیایی
-- =====================================================================
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract) VALUES
-- اسکودا
('SkodaOctavia',    'اسکودا اکتاویا',    0),
('SkodaSuperb',     'اسکودا سوپرب',      0),
('SkodaFabia',      'اسکودا فابیا',      0),
('SkodaKodiaq',     'اسکودا کادیاک',     0),
('SkodaKaroq',      'اسکودا کاروک',      0),
('SkodaScala',      'اسکودا اسکالا',     0),
('SkodaKamiq',      'اسکودا کامیاک',     0),
('SkodaEnyaq',      'اسکودا انیاک',      0),
-- سئات
('SeatIbiza',       'سئات ایبیزا',       0),
('SeatLeon',        'سئات لئون',         0),
('SeatAteca',       'سئات آتکا',         0),
('SeatArona',       'سئات آرونا',        0),
('SeatTarraco',     'سئات تاراکو',       0),
('SeatAlhambra',    'سئات آلهامبرا',     0),
-- کوپرا (زیرمجموعه سئات)
('CupraFormentor',  'کوپرا فورمنتور',    0),
('CupraBorn',       'کوپرا بورن',        0),
('CupraLeon',       'کوپرا لئون',        0);

UPDATE e01_200_01_tb 
SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='PassengerCar')
WHERE type_uid IN (
  'SkodaOctavia','SkodaSuperb','SkodaFabia','SkodaKodiaq','SkodaKaroq',
  'SkodaScala','SkodaKamiq','SkodaEnyaq',
  'SeatIbiza','SeatLeon','SeatAteca','SeatArona','SeatTarraco','SeatAlhambra',
  'CupraFormentor','CupraBorn','CupraLeon'
);

-- =====================================================================
-- ۲. سازندگان
-- =====================================================================
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract) VALUES
('CzechManufacturer',   'سازنده چک',      1),
('SpanishManufacturer', 'سازنده اسپانیایی',1);

UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Manufacturer')
  WHERE type_uid IN ('CzechManufacturer','SpanishManufacturer');

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('concept:skoda', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='CzechManufacturer'),'concept','اسکودا','Škoda Auto',2),
('concept:seat',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='SpanishManufacturer'),'concept','سئات','SEAT S.A.',2),
('concept:cupra', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='SpanishManufacturer'),'concept','کوپرا','CUPRA',2);

-- =====================================================================
-- ۳. مفاهیم خودروها
-- =====================================================================
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
-- اسکودا
('concept:skoda-octavia',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='SkodaOctavia'),'concept','اسکودا اکتاویا','Škoda Octavia',2),
('concept:skoda-superb', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='SkodaSuperb'),'concept','اسکودا سوپرب','Škoda Superb',2),
('concept:skoda-fabia',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='SkodaFabia'),'concept','اسکودا فابیا','Škoda Fabia',2),
('concept:skoda-kodiaq', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='SkodaKodiaq'),'concept','اسکودا کادیاک','Škoda Kodiaq SUV',2),
('concept:skoda-karoq',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='SkodaKaroq'),'concept','اسکودا کاروک','Škoda Karoq SUV',2),
('concept:skoda-scala',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='SkodaScala'),'concept','اسکودا اسکالا','Škoda Scala',2),
('concept:skoda-kamiq',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='SkodaKamiq'),'concept','اسکودا کامیاک','Škoda Kamiq SUV',2),
('concept:skoda-enyaq',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='SkodaEnyaq'),'concept','اسکودا انیاک','Škoda Enyaq EV',2),
-- سئات
('concept:seat-ibiza',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='SeatIbiza'),'concept','سئات ایبیزا','SEAT Ibiza',2),
('concept:seat-leon',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='SeatLeon'),'concept','سئات لئون','SEAT Leon',2),
('concept:seat-ateca',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='SeatAteca'),'concept','سئات آتکا','SEAT Ateca SUV',2),
('concept:seat-arona',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='SeatArona'),'concept','سئات آرونا','SEAT Arona SUV',2),
('concept:seat-tarraco', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='SeatTarraco'),'concept','سئات تاراکو','SEAT Tarraco SUV',2),
('concept:seat-alhambra',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='SeatAlhambra'),'concept','سئات آلهامبرا','SEAT Alhambra MPV',2),
-- کوپرا
('concept:cupra-formentor',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='CupraFormentor'),'concept','کوپرا فورمنتور','CUPRA Formentor',2),
('concept:cupra-born',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='CupraBorn'),'concept','کوپرا بورن','CUPRA Born EV',2),
('concept:cupra-leon',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='CupraLeon'),'concept','کوپرا لئون','CUPRA Leon',2);

-- =====================================================================
-- ۴. is_a
-- =====================================================================
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || REPLACE(p.sub_uid, ':', '-') || '-is-a',
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.sub_uid),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:passenger-car'),
  'asserted', 2
FROM (
  SELECT 'concept:skoda-octavia' AS sub_uid UNION ALL
  SELECT 'concept:skoda-superb' UNION ALL
  SELECT 'concept:skoda-fabia' UNION ALL
  SELECT 'concept:skoda-kodiaq' UNION ALL
  SELECT 'concept:skoda-karoq' UNION ALL
  SELECT 'concept:skoda-scala' UNION ALL
  SELECT 'concept:skoda-kamiq' UNION ALL
  SELECT 'concept:skoda-enyaq' UNION ALL
  SELECT 'concept:seat-ibiza' UNION ALL
  SELECT 'concept:seat-leon' UNION ALL
  SELECT 'concept:seat-ateca' UNION ALL
  SELECT 'concept:seat-arona' UNION ALL
  SELECT 'concept:seat-tarraco' UNION ALL
  SELECT 'concept:seat-alhambra' UNION ALL
  SELECT 'concept:cupra-formentor' UNION ALL
  SELECT 'concept:cupra-born' UNION ALL
  SELECT 'concept:cupra-leon'
) p
WHERE NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.rel_uid = 'r:' || REPLACE(p.sub_uid, ':', '-') || '-is-a');

-- =====================================================================
-- ۵. manufactured_by
-- =====================================================================
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || REPLACE(p.product, ':', '-') || '-by-' || REPLACE(p.maker, ':', '-'),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='manufactured_by'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.product),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.maker),
  'asserted', 2
FROM (
  SELECT 'concept:skoda-octavia' AS product, 'concept:skoda' AS maker UNION ALL
  SELECT 'concept:skoda-superb',           'concept:skoda' UNION ALL
  SELECT 'concept:skoda-fabia',            'concept:skoda' UNION ALL
  SELECT 'concept:skoda-kodiaq',           'concept:skoda' UNION ALL
  SELECT 'concept:skoda-karoq',            'concept:skoda' UNION ALL
  SELECT 'concept:skoda-scala',            'concept:skoda' UNION ALL
  SELECT 'concept:skoda-kamiq',            'concept:skoda' UNION ALL
  SELECT 'concept:skoda-enyaq',            'concept:skoda' UNION ALL
  SELECT 'concept:seat-ibiza',             'concept:seat' UNION ALL
  SELECT 'concept:seat-leon',              'concept:seat' UNION ALL
  SELECT 'concept:seat-ateca',             'concept:seat' UNION ALL
  SELECT 'concept:seat-arona',             'concept:seat' UNION ALL
  SELECT 'concept:seat-tarraco',           'concept:seat' UNION ALL
  SELECT 'concept:seat-alhambra',          'concept:seat' UNION ALL
  SELECT 'concept:cupra-formentor',        'concept:cupra' UNION ALL
  SELECT 'concept:cupra-born',             'concept:cupra' UNION ALL
  SELECT 'concept:cupra-leon',             'concept:cupra'
) p
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.product)
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.maker)
  AND NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.rel_uid = 'r:' || REPLACE(p.product, ':', '-') || '-by-' || REPLACE(p.maker, ':', '-'));

-- =====================================================================
-- ۶. گروه فولکس‌واگن (VW Group)
-- =====================================================================
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || REPLACE(p.sub_uid, ':', '-') || '-part-of-' || REPLACE(p.obj_uid, ':', '-'),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='part_of'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.sub_uid),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.obj_uid),
  'asserted', 2
FROM (
  SELECT 'concept:skoda' AS sub_uid, 'concept:volkswagen' AS obj_uid UNION ALL
  SELECT 'concept:seat', 'concept:volkswagen' UNION ALL
  SELECT 'concept:cupra', 'concept:seat' UNION ALL
  SELECT 'concept:audi', 'concept:volkswagen' UNION ALL
  SELECT 'concept:porsche', 'concept:volkswagen' UNION ALL
  SELECT 'concept:lamborghini', 'concept:volkswagen' UNION ALL
  SELECT 'concept:bentley', 'concept:volkswagen'
) p
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.sub_uid)
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.obj_uid)
  AND NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.rel_uid = 'r:' || REPLACE(p.sub_uid, ':', '-') || '-part-of-' || REPLACE(p.obj_uid, ':', '-'));

-- =====================================================================
-- ۷. لاگ
-- =====================================================================
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v68_czech_spanish','Škoda (8), SEAT (6), CUPRA (3) + VW Group holding');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- =====================================================================
-- گزارش
-- =====================================================================
SELECT 'entities' AS k, COUNT(*) AS n FROM e01_200_03_tb
UNION ALL SELECT 'relations', COUNT(*) FROM e01_222_01_tb;

SELECT '=== اسکودا و سئات و کوپرا ===' AS section;
SELECT 
  p.label AS model,
  m.label AS maker
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='manufactured_by'
JOIN e01_200_03_tb p ON p.ent_id = r.subj_ent_id
JOIN e01_200_03_tb m ON m.ent_id = r.obj_ent_id
WHERE m.ent_uid IN ('concept:skoda','concept:seat','concept:cupra')
ORDER BY m.ent_uid, p.ent_uid;
