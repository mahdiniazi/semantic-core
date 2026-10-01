-- v73 — رفع کامل سه خطای v72
.mode column
.headers on

BEGIN;

-- =====================================================================
-- ۱. ساخت MAPSensor type (گمشده)
-- =====================================================================
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract) VALUES
('MAPSensor','سنسور فشار منیفولد',0);

UPDATE e01_200_01_tb 
SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Sensor')
WHERE type_uid = 'MAPSensor';

-- =====================================================================
-- ۲. ساخت concept:refrigerated-truck
-- =====================================================================
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('concept:refrigerated-truck',
 (SELECT type_id FROM e01_200_01_tb WHERE type_uid='RefrigeratedTruck'),
 'concept','کامیون یخچال‌دار','Refrigerated Truck',2);

-- اتصال به truck
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
VALUES
('r:refrigerated-truck-is-a-truck',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:refrigerated-truck'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:truck'),
 'asserted', 2);

-- =====================================================================
-- ۳. اتصال reefer
-- =====================================================================
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
VALUES
('r:refrigerated-truck-has-reefer',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_part'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:refrigerated-truck'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:reefer'),
 'asserted', 2);

-- =====================================================================
-- ۴. اتصال battery-pack → module → cell
-- =====================================================================
INSERT OR IGNORE INTO e01_202_01_tb (type_uid, label, description, object_kind) VALUES
('composed_of','تشکیل شده از','کل از اجزا','entity');

INSERT OR IGNORE INTO e01_202_02_tb (reltype_id, reify_rule, category, reason)
SELECT reltype_id, 'never', 'structural', 'ترکیب ساختاری — بدون داده'
FROM e01_202_01_tb WHERE type_uid='composed_of';

INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
VALUES
('r:battery-pack-composed-of-module',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='composed_of'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:battery-pack'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:battery-module'),
 'asserted', 2),
('r:battery-module-composed-of-cell',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='composed_of'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:battery-module'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:battery-cell'),
 'asserted', 2);

-- =====================================================================
-- ۵. ساخت MAP concept
-- =====================================================================
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('concept:map-sensor',
 (SELECT type_id FROM e01_200_01_tb WHERE type_uid='MAPSensor'),
 'concept','سنسور فشار منیفولد','MAP sensor',2);

-- =====================================================================
-- ۶. تکمیل passenger-car با قطعات گمشده
-- =====================================================================
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('concept:fuel-pump',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='FuelPump'),'concept','پمپ بنزین','پمپ سوخت',2),
('concept:camshaft-sensor',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='CamshaftSensor'),'concept','سنسور میل‌سوپاپ','Camshaft',2),
('concept:spark-plug',     (SELECT type_id FROM e01_200_01_tb WHERE type_uid='SparkPlug'),'concept','شمع','Spark plug',2),
('concept:knock-sensor',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='KnockSensor'),'concept','سنسور ناک','Knock sensor',2),
('concept:tps',            (SELECT type_id FROM e01_200_01_tb WHERE type_uid='ThrottlePositionSensor'),'concept','سنسور موقعیت دریچه','TPS',2);

INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:passengercar-has-' || REPLACE(p.obj_uid, 'concept:', ''),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_part'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:passenger-car'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.obj_uid),
  'asserted', 2
FROM (
  SELECT 'concept:fuel-pump' AS obj_uid UNION ALL
  SELECT 'concept:map-sensor' UNION ALL
  SELECT 'concept:camshaft-sensor' UNION ALL
  SELECT 'concept:spark-plug' UNION ALL
  SELECT 'concept:knock-sensor' UNION ALL
  SELECT 'concept:tps'
) p
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.obj_uid)
  AND NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.rel_uid = 'r:passengercar-has-' || REPLACE(p.obj_uid, 'concept:', ''));

-- =====================================================================
-- ۷. تکمیل vehicle با قطعات گمشده
-- =====================================================================
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('concept:wiring',         (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Wiring'),'concept','سیم‌کشی','دسته سیم برق',2),
('concept:headlight-low',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='HeadlightLow'),'concept','چراغ پایین','چراغ پایین',2),
('concept:headlight-high', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='HeadlightHigh'),'concept','چراغ بالا','چراغ بالا',2),
('concept:tail-light',     (SELECT type_id FROM e01_200_01_tb WHERE type_uid='TailLight'),'concept','چراغ عقب','چراغ عقب',2),
('concept:brake-light',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='BrakeLight'),'concept','چراغ ترمز','چراغ ترمز',2),
('concept:turn-signal',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='TurnSignal'),'concept','راهنما','چراغ راهنما',2);

INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:vehicle-has-' || REPLACE(p.obj_uid, 'concept:', ''),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_part'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:vehicle'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.obj_uid),
  'asserted', 2
FROM (
  SELECT 'concept:wiring' AS obj_uid UNION ALL
  SELECT 'concept:headlight-low' UNION ALL
  SELECT 'concept:headlight-high' UNION ALL
  SELECT 'concept:tail-light' UNION ALL
  SELECT 'concept:brake-light' UNION ALL
  SELECT 'concept:turn-signal'
) p
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.obj_uid)
  AND NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.rel_uid = 'r:vehicle-has-' || REPLACE(p.obj_uid, 'concept:', ''));

-- =====================================================================
-- ۸. لاگ
-- =====================================================================
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v73_complete_fix','Complete fix: MAPSensor type + refrigerated-truck + all orphans resolved');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- =====================================================================
-- گزارش
-- =====================================================================
SELECT 'entities' AS k, COUNT(*) AS n FROM e01_200_03_tb
UNION ALL SELECT 'relations', COUNT(*) FROM e01_222_01_tb;

SELECT '=== شمارش نهایی هر کلاس ===' AS section;
SELECT 
  src.ent_uid AS class,
  COUNT(*) AS n
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='has_part'
JOIN e01_200_03_tb src ON src.ent_id = r.subj_ent_id
WHERE src.ent_uid IN ('concept:vehicle','concept:passenger-car','concept:ev',
                      'concept:motorcycle','concept:truck','concept:bus',
                      'concept:refrigerated-truck')
GROUP BY src.ent_uid
ORDER BY n DESC;

SELECT '=== یتیم‌های باقی‌مانده ===' AS section;
SELECT 
  e.ent_uid AS orphan,
  t.type_uid AS type
FROM e01_200_03_tb e
JOIN e01_200_01_tb t ON t.type_id = e.type_id
WHERE e.ent_uid IN ('concept:battery-cell','concept:battery-module','concept:reefer','concept:map-sensor')
  AND e.ent_id NOT IN (
    SELECT obj.ent_id FROM e01_222_01_tb r
    JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid IN ('has_part','composed_of')
    JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
  );
