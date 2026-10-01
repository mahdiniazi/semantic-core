-- v41 — ارث‌بری: زنجیره concept ها
.mode column
.headers on

BEGIN;

-- ========== ۱. زنجیره concept ها ==========
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || REPLACE(p.sub_uid, ':', '-') || '-is-a',
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.sub_uid),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.obj_uid),
  'asserted', 2
FROM (
  SELECT 'concept:passenger-car' AS sub_uid, 'concept:vehicle' AS obj_uid
  UNION ALL SELECT 'concept:pride', 'concept:passenger-car'
  UNION ALL SELECT 'concept:206', 'concept:passenger-car'
  UNION ALL SELECT 'concept:dena', 'concept:passenger-car'
) p
WHERE NOT EXISTS (
  SELECT 1 FROM e01_222_01_tb r
  WHERE r.rel_uid = 'r:' || REPLACE(p.sub_uid, ':', '-') || '-is-a'
);

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v41_inheritance','Inheritance chain: concept:pride is_a concept:passenger-car is_a concept:vehicle');

COMMIT;

-- ========== گزارش ==========
SELECT 'relations' AS k, COUNT(*) AS n FROM e01_222_01_tb;

SELECT '=== زنجیره concept ===' AS section;
SELECT 
  sub.ent_uid AS child_concept,
  obj.ent_uid AS parent_concept
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid = 'is_a'
JOIN e01_200_03_tb sub ON sub.ent_id = r.subj_ent_id
JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
WHERE sub.ent_uid LIKE 'concept:%'
ORDER BY sub.ent_uid;
