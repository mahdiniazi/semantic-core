-- v40.1 — رفع: ساخت concept برای Vehicle و PassengerCar
.mode column
.headers on

BEGIN;

-- ========== ۱. ساخت concept های کلاس ==========
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('concept:vehicle',       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Vehicle'),       'concept','وسیله نقلیه',  'هر وسیله نقلیه',          2),
('concept:passenger-car', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='PassengerCar'),  'concept','خودرو سواری', 'هر خودرو سواری',          2),
('concept:pride',         (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Pride'),         'concept','پراید',       'مفهوم پراید',              2),
('concept:206',           (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Peugeot206'),    'concept','پژو ۲۰۶',     'مفهوم پژو ۲۰۶',           2),
('concept:dena',          (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Dena'),          'concept','دنا',         'مفهوم دنا',                2);

-- ========== ۲. ساختار سطح کلاس — Vehicle ==========
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:vehicle-has-' || REPLACE(p.obj_uid, 'concept:', ''),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_part'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:vehicle'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.obj_uid),
  'asserted', 2
FROM (
  SELECT 'concept:battery' AS obj_uid UNION ALL
  SELECT 'concept:alternator' UNION ALL
  SELECT 'concept:starter' UNION ALL
  SELECT 'concept:relay' UNION ALL
  SELECT 'concept:fuse'
) p
WHERE NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.rel_uid = 'r:vehicle-has-' || REPLACE(p.obj_uid, 'concept:', ''));

-- ========== ۳. ساختار سطح کلاس — PassengerCar ==========
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:passengercar-has-' || REPLACE(p.obj_uid, 'concept:', ''),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_part'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:passenger-car'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.obj_uid),
  'asserted', 2
FROM (
  SELECT 'concept:engine-ecu' AS obj_uid UNION ALL
  SELECT 'concept:ignition-coil' UNION ALL
  SELECT 'concept:injector' UNION ALL
  SELECT 'concept:o2-sensor' UNION ALL
  SELECT 'concept:maf-sensor' UNION ALL
  SELECT 'concept:crankshaft-sensor' UNION ALL
  SELECT 'concept:coolant-sensor' UNION ALL
  SELECT 'concept:can-bus'
) p
WHERE NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.rel_uid = 'r:passengercar-has-' || REPLACE(p.obj_uid, 'concept:', ''));

-- ========== ۴. خودروهای نمونه به مفهوم خودشان وصل شوند ==========
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || REPLACE(v.ent_uid, ':', '-') || '-instance-of',
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='instance_of'),
  v.ent_id,
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid =
    CASE 
      WHEN v.ent_uid='vehicle:pride-1' THEN 'concept:pride'
      WHEN v.ent_uid='vehicle:206-1' THEN 'concept:206'
      WHEN v.ent_uid='vehicle:dena-1' THEN 'concept:dena'
      WHEN v.ent_uid='vehicle:sample-1' THEN 'concept:passenger-car'
    END),
  'asserted', 2
FROM e01_200_03_tb v
WHERE v.ent_uid IN ('vehicle:pride-1','vehicle:206-1','vehicle:dena-1','vehicle:sample-1')
AND NOT EXISTS (
  SELECT 1 FROM e01_222_01_tb r 
  WHERE r.rel_uid = 'r:' || REPLACE(v.ent_uid, ':', '-') || '-instance-of'
);

-- ========== ۵. لاگ ==========
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v40.1_fix_class_template','Fixed class template: created concept entities for classes');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- ========== گزارش ==========
SELECT 'entities' AS k, COUNT(*) AS n FROM e01_200_03_tb
UNION ALL SELECT 'relations', COUNT(*) FROM e01_222_01_tb;

SELECT '=== ساختار کلاس ===' AS section;
SELECT 
  sub.ent_uid AS class,
  obj.ent_uid AS has_part,
  obj.label
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid = 'has_part'
JOIN e01_200_03_tb sub ON sub.ent_id = r.subj_ent_id
JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
ORDER BY sub.ent_uid, obj.ent_uid;
