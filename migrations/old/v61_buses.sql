-- v61 — اتوبوس‌ها، مینی‌بوس‌ها، خودروهای سنگین
.mode column
.headers on

BEGIN;

-- =====================================================================
-- ۱. شاخه اتوبوس (دسته M2/M3)
-- =====================================================================
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract) VALUES
('Bus',              'اتوبوس',          1),
('Minibus',          'مینی‌بوس',        0),
('CityBus',          'اتوبوس شهری',     0),
('IntercityBus',     'اتوبوس بین‌شهری', 0),
('TourBus',          'اتوبوس توریستی',  0),
('ArticulatedBus',   'اتوبوس مفصلی',    0),
('DoubleDeckerBus',  'اتوبوس دوطبقه',   0),
('SchoolBus',        'اتوبوس مدرسه',    0),
('Van',              'ون',              0),
('Ambulance',        'آمبولانس',        0),
('FireTruck',        'آتش‌نشانی',       0),
('SpecialVehicle',   'خودروی ویژه',     1);

UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Vehicle')
  WHERE type_uid IN ('Bus','SpecialVehicle');
UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Bus')
  WHERE type_uid IN ('Minibus','CityBus','IntercityBus','TourBus','ArticulatedBus','DoubleDeckerBus','SchoolBus');
UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='SpecialVehicle')
  WHERE type_uid IN ('Van','Ambulance','FireTruck');

-- =====================================================================
-- ۲. مفهوم اتوبوس
-- =====================================================================
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('concept:bus',       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Bus'),'concept','اتوبوس','هر اتوبوس',2),
('concept:minibus',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Minibus'),'concept','مینی‌بوس','هر مینی‌بوس',2),
('concept:van',       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Van'),'concept','ون','هر ون',2),
('concept:ambulance', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Ambulance'),'concept','آمبولانس','هر آمبولانس',2),
('concept:fire-truck',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='FireTruck'),'concept','آتش‌نشانی','هر خودروی آتش‌نشانی',2);

-- زیرگروه vehicle
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || REPLACE(p.sub_uid, ':', '-') || '-is-a',
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.sub_uid),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.obj_uid),
  'asserted', 2
FROM (
  SELECT 'concept:bus' AS sub_uid, 'concept:vehicle' AS obj_uid UNION ALL
  SELECT 'concept:minibus', 'concept:bus' UNION ALL
  SELECT 'concept:van', 'concept:vehicle' UNION ALL
  SELECT 'concept:ambulance', 'concept:van' UNION ALL
  SELECT 'concept:fire-truck', 'concept:vehicle'
) p
WHERE NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.rel_uid = 'r:' || REPLACE(p.sub_uid, ':', '-') || '-is-a');

-- =====================================================================
-- ۳. قطعات اتوبوس (سیستم ۲۴ ولت، ترمز بادی، ...)
-- =====================================================================
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:bus-has-' || REPLACE(p.obj_uid, 'concept:', ''),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_part'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:bus'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.obj_uid),
  'asserted', 2
FROM (
  SELECT 'concept:battery' AS obj_uid UNION ALL
  SELECT 'concept:alternator' UNION ALL
  SELECT 'concept:starter' UNION ALL
  SELECT 'concept:relay' UNION ALL
  SELECT 'concept:fuse' UNION ALL
  SELECT 'concept:engine-ecu' UNION ALL
  SELECT 'concept:can-bus' UNION ALL
  SELECT 'concept:brake-master' UNION ALL
  SELECT 'concept:brake-disc' UNION ALL
  SELECT 'concept:brake-fluid' UNION ALL
  SELECT 'concept:steering-wheel' UNION ALL
  SELECT 'concept:steering-rack' UNION ALL
  SELECT 'concept:power-steering' UNION ALL
  SELECT 'concept:shock-absorber' UNION ALL
  SELECT 'concept:coil-spring' UNION ALL
  SELECT 'concept:ac-compressor' UNION ALL
  SELECT 'concept:blower-motor' UNION ALL
  SELECT 'concept:cabin-filter'
) p
WHERE NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.rel_uid = 'r:bus-has-' || REPLACE(p.obj_uid, 'concept:', ''));

-- =====================================================================
-- ۴. سازندگان اتوبوس
-- =====================================================================
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract) VALUES
('BusManufacturer', 'سازنده اتوبوس', 1);

UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Manufacturer')
  WHERE type_uid = 'BusManufacturer';

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
-- جهانی
('concept:volvo-bus',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='BusManufacturer'),'concept','ولوو اتوبوس','Volvo Bus',2),
('concept:scania-bus',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='BusManufacturer'),'concept','اسکانیا اتوبوس','Scania Bus',2),
('concept:man-bus',     (SELECT type_id FROM e01_200_01_tb WHERE type_uid='BusManufacturer'),'concept','MAN اتوبوس','MAN Bus',2),
('concept:mercedes-bus',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='BusManufacturer'),'concept','مرسدس اتوبوس','Mercedes-Benz Bus',2),
('concept:iveco-bus',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='BusManufacturer'),'concept','ایوکو اتوبوس','Iveco Bus',2),
('concept:yutong',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='BusManufacturer'),'concept','یوتانگ','Yutong Bus',2),
('concept:king-long',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='BusManufacturer'),'concept','کینگ لانگ','King Long',2),
-- ایرانی
('concept:oghah-afshan',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='BusManufacturer'),'concept','عقاب افشان','Oghab Afshan',2),
('concept:iran-khodro-diesel',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='BusManufacturer'),'concept','ایران خودرو دیزل','Iran Khodro Diesel',2);

-- =====================================================================
-- ۵. مدل‌های اتوبوس
-- =====================================================================
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract) VALUES
('Volvo7900',      'ولوو ۷۹۰۰',      0),
('VolvoB11R',      'ولوو B11R',       0),
('ScaniaTouring',  'اسکانیا تورینگ',  0),
('MANLionsCoach',  'MAN Lions Coach', 0),
('MercedesTourismo','مرسدس توریسمو',   0),
('YutongZK',       'یوتانگ ZK',       0),
('IvecoCrossway',  'ایوکو کراس‌وی',   0),
('IKD_TJ',         'ایران خودرو دیزل TJ',0),
('OghabCity',      'عقاب شهری',       0);

UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='IntercityBus')
  WHERE type_uid IN ('Volvo7900','VolvoB11R','ScaniaTouring','MANLionsCoach','MercedesTourismo','IvecoCrossway');
UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='CityBus')
  WHERE type_uid IN ('YutongZK','IKD_TJ','OghabCity');

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('concept:volvo-7900',       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Volvo7900'),'concept','ولوو ۷۹۰۰','Volvo 7900 Bus',2),
('concept:volvo-b11r',       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='VolvoB11R'),'concept','ولوو B11R','Volvo B11R',2),
('concept:scania-touring',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='ScaniaTouring'),'concept','اسکانیا تورینگ','Scania Touring',2),
('concept:man-lions-coach',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='MANLionsCoach'),'concept','MAN Lions Coach','MAN Lions Coach',2),
('concept:mercedes-tourismo',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='MercedesTourismo'),'concept','مرسدس توریسمو','Mercedes Tourismo',2),
('concept:yutong-zk',        (SELECT type_id FROM e01_200_01_tb WHERE type_uid='YutongZK'),'concept','یوتانگ ZK','Yutong ZK',2),
('concept:iveco-crossway',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='IvecoCrossway'),'concept','ایوکو کراس‌وی','Iveco Crossway',2),
('concept:ikd-tj',           (SELECT type_id FROM e01_200_01_tb WHERE type_uid='IKD_TJ'),'concept','ایران خودرو دیزل TJ','IKD TJ Bus',2),
('concept:oghab-city',       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='OghabCity'),'concept','عقاب شهری','Oghab City Bus',2);

-- is_a
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || REPLACE(p.sub_uid, ':', '-') || '-is-a',
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.sub_uid),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.obj_uid),
  'asserted', 2
FROM (
  SELECT 'concept:volvo-7900' AS sub_uid, 'concept:bus' AS obj_uid UNION ALL
  SELECT 'concept:volvo-b11r', 'concept:bus' UNION ALL
  SELECT 'concept:scania-touring', 'concept:bus' UNION ALL
  SELECT 'concept:man-lions-coach', 'concept:bus' UNION ALL
  SELECT 'concept:mercedes-tourismo', 'concept:bus' UNION ALL
  SELECT 'concept:yutong-zk', 'concept:bus' UNION ALL
  SELECT 'concept:iveco-crossway', 'concept:bus' UNION ALL
  SELECT 'concept:ikd-tj', 'concept:bus' UNION ALL
  SELECT 'concept:oghab-city', 'concept:bus'
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
  SELECT 'concept:volvo-7900' AS product, 'concept:volvo-bus' AS maker UNION ALL
  SELECT 'concept:volvo-b11r', 'concept:volvo-bus' UNION ALL
  SELECT 'concept:scania-touring', 'concept:scania-bus' UNION ALL
  SELECT 'concept:man-lions-coach', 'concept:man-bus' UNION ALL
  SELECT 'concept:mercedes-tourismo', 'concept:mercedes-bus' UNION ALL
  SELECT 'concept:yutong-zk', 'concept:yutong' UNION ALL
  SELECT 'concept:iveco-crossway', 'concept:iveco-bus' UNION ALL
  SELECT 'concept:ikd-tj', 'concept:iran-khodro-diesel' UNION ALL
  SELECT 'concept:oghab-city', 'concept:oghah-afshan'
) p
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.product)
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.maker)
  AND NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.rel_uid = 'r:' || REPLACE(p.product, ':', '-') || '-by-' || REPLACE(p.maker, ':', '-'));

INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v61_buses','Buses: 9 makers, 9 models + vans + special vehicles');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

SELECT 'entities' AS k, COUNT(*) AS n FROM e01_200_03_tb
UNION ALL SELECT 'relations', COUNT(*) FROM e01_222_01_tb;

SELECT '=== اتوبوس‌ها ===' AS section;
SELECT 
  p.label AS model,
  m.label AS maker
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='manufactured_by'
JOIN e01_200_03_tb p ON p.ent_id = r.subj_ent_id
JOIN e01_200_03_tb m ON m.ent_id = r.obj_ent_id
WHERE m.type_id IN (SELECT type_id FROM e01_200_01_tb WHERE type_uid='BusManufacturer')
ORDER BY m.ent_uid, p.ent_uid;
