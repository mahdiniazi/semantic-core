-- v37.1 — تکمیل گالری با چک تکراری
.mode column
.headers on

BEGIN;

-- ========== پراید ==========
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || e.ent_uid || '-installed',
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='installed_on'),
  e.ent_id,
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='vehicle:pride-1'),
  'asserted', 2
FROM e01_200_03_tb e
WHERE e.ent_uid IN (
  'starter:pride-1kw','sensor:pride-crank','sensor:pride-o2','sensor:pride-coolant',
  'sensor:pride-maf','injector:pride-1','relay:pride-main','fuse:pride-15a','bus:pride-can'
)
AND NOT EXISTS (
  SELECT 1 FROM e01_222_01_tb r
  WHERE r.subj_ent_id = e.ent_id
    AND r.reltype_id = (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='installed_on')
    AND r.status = 'asserted' AND r.superseded_at IS NULL
);

-- ========== ۲۰۶ ==========
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || e.ent_uid || '-installed',
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='installed_on'),
  e.ent_id,
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='vehicle:206-1'),
  'asserted', 2
FROM e01_200_03_tb e
WHERE e.ent_uid IN (
  'starter:206-1.4kw','sensor:206-crank','sensor:206-o2','sensor:206-coolant',
  'sensor:206-maf','injector:206-1','relay:206-main','fuse:206-15a','bus:206-can'
)
AND NOT EXISTS (
  SELECT 1 FROM e01_222_01_tb r
  WHERE r.subj_ent_id = e.ent_id
    AND r.reltype_id = (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='installed_on')
    AND r.status = 'asserted' AND r.superseded_at IS NULL
);

-- ========== دنا ==========
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || e.ent_uid || '-installed',
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='installed_on'),
  e.ent_id,
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='vehicle:dena-1'),
  'asserted', 2
FROM e01_200_03_tb e
WHERE e.ent_uid IN (
  'starter:dena-1.4kw','sensor:dena-crank','sensor:dena-o2','sensor:dena-coolant',
  'sensor:dena-maf','injector:dena-1','relay:dena-main','fuse:dena-15a','bus:dena-can'
)
AND NOT EXISTS (
  SELECT 1 FROM e01_222_01_tb r
  WHERE r.subj_ent_id = e.ent_id
    AND r.reltype_id = (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='installed_on')
    AND r.status = 'asserted' AND r.superseded_at IS NULL
);

-- ========== instance_of برای باتری‌ها ==========
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || e.ent_uid || '-inst-of',
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='instance_of'),
  e.ent_id,
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='battery:generic'),
  'asserted', 2
FROM e01_200_03_tb e
WHERE e.ent_uid IN ('battery:pride-66ah','battery:206-60ah','battery:dena-74ah')
AND NOT EXISTS (
  SELECT 1 FROM e01_222_01_tb r
  WHERE r.subj_ent_id = e.ent_id
    AND r.reltype_id = (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='instance_of')
    AND r.status = 'asserted' AND r.superseded_at IS NULL
);

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v37.1_fix_gallery','Fixed gallery with NOT EXISTS checks');

COMMIT;

-- ========== گزارش ==========
SELECT 'entities' AS k, COUNT(*) AS n FROM e01_200_03_tb
UNION ALL SELECT 'relations', COUNT(*) FROM e01_222_01_tb;

SELECT '=== گالری ===' AS section;
SELECT 
  v.ent_uid AS vehicle,
  v.label,
  COUNT(r.rel_id) AS n_components
FROM e01_200_03_tb v
LEFT JOIN e01_222_01_tb r ON r.obj_ent_id = v.ent_id
  AND r.reltype_id = (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='installed_on')
WHERE v.ent_uid LIKE 'vehicle:%'
GROUP BY v.ent_id
ORDER BY v.ent_uid;
