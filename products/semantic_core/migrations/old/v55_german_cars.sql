-- v55 — خودروهای آلمانی
.mode column
.headers on

BEGIN;

INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract) VALUES
-- BMW
('BMW3Series',   'بی‌ام‌و سری ۳',  0),
('BMW5Series',   'بی‌ام‌و سری ۵',  0),
('BMWX5',        'بی‌ام‌و X5',      0),
-- مرسدس
('MercedesCClass','مرسدس C-Class', 0),
('MercedesEClass','مرسدس E-Class', 0),
('MercedesSClass','مرسدس S-Class', 0),
-- فولکس‌واگن
('VWGolf',       'فولکس‌واگن گلف', 0),
('VWPassat',     'فولکس‌واگن پاسات',0),
('VWTiguan',     'فولکس‌واگن تیگوان',0),
-- آئودی
('AudiA4',       'آئودی A4',       0),
('AudiA6',       'آئودی A6',       0),
-- پورشه
('Porsche911',   'پورشه ۹۱۱',      0);

UPDATE e01_200_01_tb 
SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='PassengerCar')
WHERE type_uid IN (
  'BMW3Series','BMW5Series','BMWX5',
  'MercedesCClass','MercedesEClass','MercedesSClass',
  'VWGolf','VWPassat','VWTiguan',
  'AudiA4','AudiA6','Porsche911'
);

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('concept:bmw-3',        (SELECT type_id FROM e01_200_01_tb WHERE type_uid='BMW3Series'),'concept','BMW سری ۳','BMW 3 Series',2),
('concept:bmw-5',        (SELECT type_id FROM e01_200_01_tb WHERE type_uid='BMW5Series'),'concept','BMW سری ۵','BMW 5 Series',2),
('concept:bmw-x5',       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='BMWX5'),'concept','BMW X5','BMW X5 SUV',2),

('concept:mercedes-c',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='MercedesCClass'),'concept','مرسدس C','Mercedes C-Class',2),
('concept:mercedes-e',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='MercedesEClass'),'concept','مرسدس E','Mercedes E-Class',2),
('concept:mercedes-s',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='MercedesSClass'),'concept','مرسدس S','Mercedes S-Class',2),

('concept:vw-golf',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='VWGolf'),'concept','فولکس گلف','VW Golf',2),
('concept:vw-passat',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='VWPassat'),'concept','فولکس پاسات','VW Passat',2),
('concept:vw-tiguan',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='VWTiguan'),'concept','فولکس تیگوان','VW Tiguan SUV',2),

('concept:audi-a4',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='AudiA4'),'concept','آئودی A4','Audi A4',2),
('concept:audi-a6',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='AudiA6'),'concept','آئودی A6','Audi A6',2),

('concept:porsche-911',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Porsche911'),'concept','پورشه ۹۱۱','Porsche 911',2);

-- is_a
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || REPLACE(p.sub_uid, ':', '-') || '-is-a',
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.sub_uid),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:passenger-car'),
  'asserted', 2
FROM (
  SELECT 'concept:bmw-3' AS sub_uid UNION ALL SELECT 'concept:bmw-5' UNION ALL
  SELECT 'concept:bmw-x5' UNION ALL SELECT 'concept:mercedes-c' UNION ALL
  SELECT 'concept:mercedes-e' UNION ALL SELECT 'concept:mercedes-s' UNION ALL
  SELECT 'concept:vw-golf' UNION ALL SELECT 'concept:vw-passat' UNION ALL
  SELECT 'concept:vw-tiguan' UNION ALL SELECT 'concept:audi-a4' UNION ALL
  SELECT 'concept:audi-a6' UNION ALL SELECT 'concept:porsche-911'
) p
WHERE NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.rel_uid = 'r:' || REPLACE(p.sub_uid, ':', '-') || '-is-a');

-- manufactured_by
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || REPLACE(p.product, ':', '-') || '-by-' || REPLACE(p.maker, ':', '-'),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='manufactured_by'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.product),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.maker),
  'asserted', 2
FROM (
  SELECT 'concept:bmw-3' AS product, 'concept:bmw' AS maker UNION ALL
  SELECT 'concept:bmw-5',              'concept:bmw' UNION ALL
  SELECT 'concept:bmw-x5',             'concept:bmw' UNION ALL
  SELECT 'concept:mercedes-c',         'concept:mercedes' UNION ALL
  SELECT 'concept:mercedes-e',         'concept:mercedes' UNION ALL
  SELECT 'concept:mercedes-s',         'concept:mercedes' UNION ALL
  SELECT 'concept:vw-golf',            'concept:volkswagen' UNION ALL
  SELECT 'concept:vw-passat',          'concept:volkswagen' UNION ALL
  SELECT 'concept:vw-tiguan',          'concept:volkswagen' UNION ALL
  SELECT 'concept:audi-a4',            'concept:audi' UNION ALL
  SELECT 'concept:audi-a6',            'concept:audi' UNION ALL
  SELECT 'concept:porsche-911',        'concept:porsche'
) p
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.product)
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.maker)
  AND NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.rel_uid = 'r:' || REPLACE(p.product, ':', '-') || '-by-' || REPLACE(p.maker, ':', '-'));

INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v55_german_cars','German cars: BMW (3), Mercedes (3), VW (3), Audi (2), Porsche (1)');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

SELECT 'entities' AS k, COUNT(*) AS n FROM e01_200_03_tb
UNION ALL SELECT 'relations', COUNT(*) FROM e01_222_01_tb;

SELECT '=== خودروهای آلمانی ===' AS section;
SELECT 
  p.label AS model,
  m.label AS maker
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='manufactured_by'
JOIN e01_200_03_tb p ON p.ent_id = r.subj_ent_id
JOIN e01_200_03_tb m ON m.ent_id = r.obj_ent_id
WHERE m.ent_uid IN ('concept:bmw','concept:mercedes','concept:volkswagen','concept:audi','concept:porsche')
ORDER BY m.ent_uid, p.ent_uid;
