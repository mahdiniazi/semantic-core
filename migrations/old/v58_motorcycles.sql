-- v58 — موتورسیکلت‌ها
.mode column
.headers on

BEGIN;

-- =====================================================================
-- ۱. شاخه موتورسیکلت
-- =====================================================================
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract) VALUES
('Motorcycle',           'موتورسیکلت',      1),
('Moped',                'موتور گازی',       0),
('Scooter',              'اسکوتر',           0),
('SportBike',            'موتور اسپرت',      0),
('CruiserBike',          'موتور کروزر',      0),
('OffRoadBike',          'موتور آفرود',      0),
('TouringBike',          'موتور توریستی',    0);

UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Vehicle')
  WHERE type_uid = 'Motorcycle';
UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Motorcycle')
  WHERE type_uid IN ('Moped','Scooter','SportBike','CruiserBike','OffRoadBike','TouringBike');

-- =====================================================================
-- ۲. مفهوم موتورسیکلت (کلاس مشترک)
-- =====================================================================
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('concept:motorcycle', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Motorcycle'),'concept','موتورسیکلت','هر موتورسیکلت',2);

-- اتصال concept:motorcycle به concept:vehicle (زیرگروه)
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
VALUES
('r:motorcycle-is-a-vehicle',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:motorcycle'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:vehicle'),
 'asserted', 2);

-- =====================================================================
-- ۳. قطعات مشترک موتورسیکلت (has_part از concept:motorcycle)
-- =====================================================================
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:motorcycle-has-' || REPLACE(p.obj_uid, 'concept:', ''),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_part'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:motorcycle'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.obj_uid),
  'asserted', 2
FROM (
  SELECT 'concept:battery' AS obj_uid UNION ALL
  SELECT 'concept:alternator' UNION ALL
  SELECT 'concept:relay' UNION ALL
  SELECT 'concept:fuse' UNION ALL
  SELECT 'concept:brake-master' UNION ALL
  SELECT 'concept:brake-pad' UNION ALL
  SELECT 'concept:brake-fluid' UNION ALL
  SELECT 'concept:brake-line' UNION ALL
  SELECT 'concept:shock-absorber' UNION ALL
  SELECT 'concept:coil-spring' UNION ALL
  SELECT 'concept:ball-joint' UNION ALL
  SELECT 'concept:bushing'
) p
WHERE NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.rel_uid = 'r:motorcycle-has-' || REPLACE(p.obj_uid, 'concept:', ''));

-- =====================================================================
-- ۴. سازندگان موتورسیکلت
-- =====================================================================
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract) VALUES
('MotorcycleManufacturer', 'سازنده موتورسیکلت', 1);

UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Manufacturer')
  WHERE type_uid = 'MotorcycleManufacturer';

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('concept:honda-moto',     (SELECT type_id FROM e01_200_01_tb WHERE type_uid='MotorcycleManufacturer'),'concept','هوندا موتور','Honda Motorcycles',2),
('concept:yamaha',         (SELECT type_id FROM e01_200_01_tb WHERE type_uid='MotorcycleManufacturer'),'concept','یاماها','Yamaha Motor',2),
('concept:suzuki-moto',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='MotorcycleManufacturer'),'concept','سوزوکی موتور','Suzuki Motorcycle',2),
('concept:kawasaki',       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='MotorcycleManufacturer'),'concept','کاوازاکی','Kawasaki',2),
('concept:bmw-moto',       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='MotorcycleManufacturer'),'concept','بی‌ام‌و موتور','BMW Motorrad',2),
('concept:harley',         (SELECT type_id FROM e01_200_01_tb WHERE type_uid='MotorcycleManufacturer'),'concept','هارلی دیویدسون','Harley-Davidson',2),
('concept:ktm',            (SELECT type_id FROM e01_200_01_tb WHERE type_uid='MotorcycleManufacturer'),'concept','KTM','KTM',2),
('concept:ducati',         (SELECT type_id FROM e01_200_01_tb WHERE type_uid='MotorcycleManufacturer'),'concept','دوکاتی','Ducati',2),
('concept:piaggio',        (SELECT type_id FROM e01_200_01_tb WHERE type_uid='MotorcycleManufacturer'),'concept','پیاجیو','Piaggio / Vespa',2);

-- =====================================================================
-- ۵. خودروهای نمونه
-- =====================================================================
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('concept:honda-cb125',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='SportBike'),'concept','هوندا CB۱۲۵','Honda CB125',2),
('concept:yamaha-ybr',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='SportBike'),'concept','یاماها YBR','Yamaha YBR',2),
('concept:vespa-primavera',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='Scooter'),'concept','وسپا پریماورا','Vespa Primavera',2),
('concept:harley-sportster',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='CruiserBike'),'concept','هارلی اسپورتستر','Harley Sportster',2),
('concept:ktm-duke',     (SELECT type_id FROM e01_200_01_tb WHERE type_uid='SportBike'),'concept','KTM Duke','KTM Duke',2);

-- is_a
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || REPLACE(p.sub_uid, ':', '-') || '-is-a',
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.sub_uid),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:motorcycle'),
  'asserted', 2
FROM (
  SELECT 'concept:honda-cb125' AS sub_uid UNION ALL
  SELECT 'concept:yamaha-ybr' UNION ALL
  SELECT 'concept:vespa-primavera' UNION ALL
  SELECT 'concept:harley-sportster' UNION ALL
  SELECT 'concept:ktm-duke'
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
  SELECT 'concept:honda-cb125' AS product, 'concept:honda-moto' AS maker UNION ALL
  SELECT 'concept:yamaha-ybr',              'concept:yamaha' UNION ALL
  SELECT 'concept:vespa-primavera',         'concept:piaggio' UNION ALL
  SELECT 'concept:harley-sportster',        'concept:harley' UNION ALL
  SELECT 'concept:ktm-duke',                'concept:ktm'
) p
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.product)
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.maker)
  AND NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.rel_uid = 'r:' || REPLACE(p.product, ':', '-') || '-by-' || REPLACE(p.maker, ':', '-'));

INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v58_motorcycles','Motorcycles: 9 makers + 5 models + 12 shared parts');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

SELECT 'entities' AS k, COUNT(*) AS n FROM e01_200_03_tb
UNION ALL SELECT 'relations', COUNT(*) FROM e01_222_01_tb;

SELECT '=== موتورسیکلت‌ها ===' AS section;
SELECT 
  p.label AS model,
  m.label AS maker
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='manufactured_by'
JOIN e01_200_03_tb p ON p.ent_id = r.subj_ent_id
JOIN e01_200_03_tb m ON m.ent_id = r.obj_ent_id
WHERE m.type_id IN (SELECT type_id FROM e01_200_01_tb WHERE type_uid='MotorcycleManufacturer')
ORDER BY m.ent_uid, p.ent_uid;
