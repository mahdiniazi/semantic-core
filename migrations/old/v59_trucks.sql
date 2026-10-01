-- v59 — کامیون‌ها (دسته N)
.mode column
.headers on

BEGIN;

-- =====================================================================
-- ۱. شاخه کامیون
-- =====================================================================
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract) VALUES
('Truck',           'کامیون',        1),
('LightTruck',      'کامیونت',       0),
('HeavyTruck',      'کامیون سنگین',  0),
('PickupTruck',     'وانت',          0);

UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Vehicle')
  WHERE type_uid = 'Truck';
UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Truck')
  WHERE type_uid IN ('LightTruck','HeavyTruck','PickupTruck');

-- =====================================================================
-- ۲. مفهوم کامیون
-- =====================================================================
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('concept:truck',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Truck'),'concept','کامیون','هر کامیون',2),
('concept:pickup',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='PickupTruck'),'concept','وانت','هر وانت',2);

-- زیرگروه vehicle
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
VALUES
('r:truck-is-a-vehicle',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:truck'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:vehicle'),
 'asserted', 2),
('r:pickup-is-a-truck',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:pickup'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:truck'),
 'asserted', 2);

-- =====================================================================
-- ۳. قطعات مشترک کامیون (24V، ترمز بادی، ...)
-- =====================================================================
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:truck-has-' || REPLACE(p.obj_uid, 'concept:', ''),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_part'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:truck'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.obj_uid),
  'asserted', 2
FROM (
  SELECT 'concept:battery' AS obj_uid UNION ALL
  SELECT 'concept:alternator' UNION ALL
  SELECT 'concept:starter' UNION ALL
  SELECT 'concept:relay' UNION ALL
  SELECT 'concept:fuse' UNION ALL
  SELECT 'concept:engine-ecu' UNION ALL
  SELECT 'concept:injector' UNION ALL
  SELECT 'concept:can-bus' UNION ALL
  SELECT 'concept:brake-master' UNION ALL
  SELECT 'concept:brake-disc' UNION ALL
  SELECT 'concept:brake-caliper' UNION ALL
  SELECT 'concept:brake-fluid' UNION ALL
  SELECT 'concept:steering-wheel' UNION ALL
  SELECT 'concept:steering-column' UNION ALL
  SELECT 'concept:steering-rack' UNION ALL
  SELECT 'concept:power-steering' UNION ALL
  SELECT 'concept:shock-absorber' UNION ALL
  SELECT 'concept:coil-spring'
) p
WHERE NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.rel_uid = 'r:truck-has-' || REPLACE(p.obj_uid, 'concept:', ''));

-- =====================================================================
-- ۴. سازندگان کامیون
-- =====================================================================
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract) VALUES
('TruckManufacturer', 'سازنده کامیون', 1);

UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Manufacturer')
  WHERE type_uid = 'TruckManufacturer';

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
-- کره‌ای
('concept:hyundai-truck',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='TruckManufacturer'),'concept','هیوندای کامیون','Hyundai Trucks',2),
-- ژاپنی
('concept:isuzu',          (SELECT type_id FROM e01_200_01_tb WHERE type_uid='TruckManufacturer'),'concept','ایسوزو','Isuzu',2),
('concept:hino',           (SELECT type_id FROM e01_200_01_tb WHERE type_uid='TruckManufacturer'),'concept','هینو','Hino',2),
('concept:mitsubishi-fuso',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='TruckManufacturer'),'concept','میتسوبیشی فوسو','Mitsubishi Fuso',2),
-- آلمانی
('concept:man',            (SELECT type_id FROM e01_200_01_tb WHERE type_uid='TruckManufacturer'),'concept','MAN','MAN Truck & Bus',2),
('concept:mercedes-truck', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='TruckManufacturer'),'concept','مرسدس کامیون','Mercedes-Benz Trucks',2),
-- سوئدی
('concept:volvo-truck',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='TruckManufacturer'),'concept','ولوو کامیون','Volvo Trucks',2),
('concept:scania',         (SELECT type_id FROM e01_200_01_tb WHERE type_uid='TruckManufacturer'),'concept','اسکانیا','Scania',2),
-- آمریکایی
('concept:freightliner',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='TruckManufacturer'),'concept','فریت‌لاینر','Freightliner',2),
-- ایرانی
('concept:iran-khodro-truck',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='TruckManufacturer'),'concept','ایران خودرو دیزل','Iran Khodro Diesel',2),
('concept:saipa-diesel',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='TruckManufacturer'),'concept','سایپا دیزل','Saipa Diesel',2);

-- =====================================================================
-- ۵. مدل‌های کامیون
-- =====================================================================
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract) VALUES
-- وانت‌ها
('ToyotaHilux',    'تویوتا هایلوکس',  0),
('MitsubishiL200', 'میتسوبیشی L200',  0),
('NissanNavara',   'نیسان ناوارا',    0),
-- کامیونت
('IsuzuNPR',       'ایسوزو NPR',      0),
('HyundaiMighty',  'هیوندای مایتی',   0),
-- کامیون سنگین
('VolvoFH',        'ولوو FH',         0),
('ScaniaR',        'اسکانیا R',       0),
('MAN_TGX',        'MAN TGX',         0);

UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='PickupTruck')
  WHERE type_uid IN ('ToyotaHilux','MitsubishiL200','NissanNavara');
UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='LightTruck')
  WHERE type_uid IN ('IsuzuNPR','HyundaiMighty');
UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='HeavyTruck')
  WHERE type_uid IN ('VolvoFH','ScaniaR','MAN_TGX');

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('concept:toyota-hilux',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='ToyotaHilux'),'concept','تویوتا هایلوکس','Toyota Hilux',2),
('concept:mitsubishi-l200', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='MitsubishiL200'),'concept','میتسوبیشی L200','Mitsubishi L200',2),
('concept:nissan-navara',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='NissanNavara'),'concept','نیسان ناوارا','Nissan Navara',2),
('concept:isuzu-npr',       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='IsuzuNPR'),'concept','ایسوزو NPR','Isuzu NPR',2),
('concept:hyundai-mighty',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='HyundaiMighty'),'concept','هیوندای مایتی','Hyundai Mighty',2),
('concept:volvo-fh',        (SELECT type_id FROM e01_200_01_tb WHERE type_uid='VolvoFH'),'concept','ولوو FH','Volvo FH',2),
('concept:scania-r',        (SELECT type_id FROM e01_200_01_tb WHERE type_uid='ScaniaR'),'concept','اسکانیا R','Scania R',2),
('concept:man-tgx',         (SELECT type_id FROM e01_200_01_tb WHERE type_uid='MAN_TGX'),'concept','MAN TGX','MAN TGX',2);

-- is_a
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || REPLACE(p.sub_uid, ':', '-') || '-is-a',
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.sub_uid),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.obj_uid),
  'asserted', 2
FROM (
  SELECT 'concept:toyota-hilux' AS sub_uid, 'concept:pickup' AS obj_uid UNION ALL
  SELECT 'concept:mitsubishi-l200', 'concept:pickup' UNION ALL
  SELECT 'concept:nissan-navara', 'concept:pickup' UNION ALL
  SELECT 'concept:isuzu-npr', 'concept:truck' UNION ALL
  SELECT 'concept:hyundai-mighty', 'concept:truck' UNION ALL
  SELECT 'concept:volvo-fh', 'concept:truck' UNION ALL
  SELECT 'concept:scania-r', 'concept:truck' UNION ALL
  SELECT 'concept:man-tgx', 'concept:truck'
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
  SELECT 'concept:toyota-hilux' AS product, 'concept:toyota' AS maker UNION ALL
  SELECT 'concept:mitsubishi-l200',              'concept:mitsubishi' UNION ALL
  SELECT 'concept:nissan-navara',                'concept:nissan' UNION ALL
  SELECT 'concept:isuzu-npr',                    'concept:isuzu' UNION ALL
  SELECT 'concept:hyundai-mighty',               'concept:hyundai-truck' UNION ALL
  SELECT 'concept:volvo-fh',                     'concept:volvo-truck' UNION ALL
  SELECT 'concept:scania-r',                     'concept:scania' UNION ALL
  SELECT 'concept:man-tgx',                      'concept:man'
) p
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.product)
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.maker)
  AND NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.rel_uid = 'r:' || REPLACE(p.product, ':', '-') || '-by-' || REPLACE(p.maker, ':', '-'));

INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v59_trucks','Trucks: 11 manufacturers, 8 models, shared parts');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

SELECT 'entities' AS k, COUNT(*) AS n FROM e01_200_03_tb
UNION ALL SELECT 'relations', COUNT(*) FROM e01_222_01_tb;

SELECT '=== کامیون‌ها ===' AS section;
SELECT 
  p.label AS model,
  m.label AS maker
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='manufactured_by'
JOIN e01_200_03_tb p ON p.ent_id = r.subj_ent_id
JOIN e01_200_03_tb m ON m.ent_id = r.obj_ent_id
WHERE m.type_id IN (SELECT type_id FROM e01_200_01_tb WHERE type_uid='TruckManufacturer')
ORDER BY m.ent_uid, p.ent_uid;
