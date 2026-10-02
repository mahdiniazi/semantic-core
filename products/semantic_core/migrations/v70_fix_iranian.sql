-- v70 — اصلاح و تکمیل خودروهای ایرانی
.mode column
.headers on

BEGIN;

-- =====================================================================
-- ۱. خودروهای جدید
-- =====================================================================
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract) VALUES
('KiaPride',    'کیا پراید',        0),
('IKCOTara',    'تارا',             0),
('IKCOReera',   'ری‌را',            0),
('IKCOArisun',  'آریسان',           0),
('IKCOSoren',   'سورن',             0),
('IKCOPaykan',  'پیکان',            0);

UPDATE e01_200_01_tb 
SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='PassengerCar')
WHERE type_uid IN ('KiaPride','IKCOTara','IKCOReera','IKCOSoren','IKCOPaykan');

UPDATE e01_200_01_tb 
SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='PickupTruck')
WHERE type_uid = 'IKCOArisun';

-- =====================================================================
-- ۲. مفاهیم جدید
-- =====================================================================
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('concept:kia-pride',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='KiaPride'),'concept','کیا پراید','Kia Pride (1986-2000)',2),
('concept:tara',        (SELECT type_id FROM e01_200_01_tb WHERE type_uid='IKCOTara'),'concept','تارا','IKCO Tara',2),
('concept:reera',       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='IKCOReera'),'concept','ری‌را','IKCO Reera Crossover',2),
('concept:arisun',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='IKCOArisun'),'concept','آریسان','IKCO Arisun Pickup',2),
('concept:soren',       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='IKCOSoren'),'concept','سورن','IKCO Soren',2),
('concept:paykan',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='IKCOPaykan'),'concept','پیکان','IKCO Paykan (1967-2005)',2);

-- is_a
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || REPLACE(p.sub_uid, ':', '-') || '-is-a',
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.sub_uid),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.obj_uid),
  'asserted', 2
FROM (
  SELECT 'concept:kia-pride' AS sub_uid, 'concept:passenger-car' AS obj_uid UNION ALL
  SELECT 'concept:tara', 'concept:passenger-car' UNION ALL
  SELECT 'concept:reera', 'concept:passenger-car' UNION ALL
  SELECT 'concept:soren', 'concept:passenger-car' UNION ALL
  SELECT 'concept:paykan', 'concept:passenger-car' UNION ALL
  SELECT 'concept:arisun', 'concept:pickup'
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
  SELECT 'concept:kia-pride' AS product, 'concept:kia' AS maker UNION ALL
  SELECT 'concept:tara',                 'concept:ikco' UNION ALL
  SELECT 'concept:reera',                'concept:ikco' UNION ALL
  SELECT 'concept:soren',                'concept:ikco' UNION ALL
  SELECT 'concept:paykan',               'concept:ikco' UNION ALL
  SELECT 'concept:arisun',               'concept:ikco'
) p
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.product)
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.maker)
  AND NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.rel_uid = 'r:' || REPLACE(p.product, ':', '-') || '-by-' || REPLACE(p.maker, ':', '-'));

-- =====================================================================
-- ۳. اصلاح: پراید به کیا پراید (نه ریو)
-- =====================================================================
UPDATE e01_222_01_tb
SET obj_ent_id = (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:kia-pride')
WHERE rel_uid = 'r:concept-pride-based-on-concept-kia-rio';

-- =====================================================================
-- ۴. اضافه کردن licensed_from برای پراید
-- =====================================================================
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
VALUES
('r:concept-pride-licensed-from-kia',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='licensed_from'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:pride'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:kia'),
 'asserted', 2);

-- =====================================================================
-- ۵. روابط پلتفرم برای خودروهای جدید
-- =====================================================================
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || REPLACE(p.sub_uid, ':', '-') || '-based-on-' || REPLACE(p.obj_uid, ':', '-'),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='based_on'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.sub_uid),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.obj_uid),
  'asserted', 2
FROM (
  -- تارا بر پایه پژو ۳۰۱
  SELECT 'concept:tara' AS sub_uid, 'concept:peugeot-301' AS obj_uid UNION ALL
  -- ری‌را بر پایه پژو ۲۰۰۸
  SELECT 'concept:reera', 'concept:peugeot-2008' UNION ALL
  -- آریسان بر پایه پژو ۴۰۵
  SELECT 'concept:arisun', 'concept:405' UNION ALL
  -- سورن بر پایه سمند
  SELECT 'concept:soren', 'concept:samand' UNION ALL
  -- پیکان بر پایه Hillman Hunter (نیست، پیکان خودش پایه است)
  -- تارا هم تحت لیسانس پژو است
  SELECT 'concept:tara', 'concept:peugeot'
) p
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.sub_uid)
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.obj_uid)
  AND NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.rel_uid = 'r:' || REPLACE(p.sub_uid, ':', '-') || '-based-on-' || REPLACE(p.obj_uid, ':', '-'));

-- =====================================================================
-- ۶. لاگ
-- =====================================================================
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v70_fix_iranian','Fixed Pride license + added Tara, Reera, Arisun, Soren, Paykan + Kia Pride');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- =====================================================================
-- گزارش
-- =====================================================================
SELECT 'entities' AS k, COUNT(*) AS n FROM e01_200_03_tb
UNION ALL SELECT 'relations', COUNT(*) FROM e01_222_01_tb;

SELECT '=== همه خودروهای ایرانی ===' AS section;
SELECT 
  p.label AS car,
  m.label AS maker,
  '  →' AS x
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='manufactured_by'
JOIN e01_200_03_tb p ON p.ent_id = r.subj_ent_id
JOIN e01_200_03_tb m ON m.ent_id = r.obj_ent_id
WHERE m.ent_uid IN ('concept:ikco','concept:saipa','concept:parskhodro','concept:kermanmotor','concept:bahman')
ORDER BY m.ent_uid, p.ent_uid;

SELECT '=== لیسانس‌ها و پلتفرم‌های خودروهای ایرانی ===' AS section;
SELECT 
  car.label AS car,
  rt.type_uid AS relation,
  target.label AS target
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id 
  AND rt.type_uid IN ('licensed_from','based_on')
JOIN e01_200_03_tb car ON car.ent_id = r.subj_ent_id
JOIN e01_200_03_tb target ON target.ent_id = r.obj_ent_id
WHERE car.ent_uid LIKE 'concept:%'
  AND car.ent_uid NOT IN ('concept:kia-pride')
ORDER BY car.label, rt.type_uid;
