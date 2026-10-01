-- v95 — تبدیل has_part به has_direct_part + ساخت inference گذرا
.mode column
.headers on

BEGIN;

-- ═══════════════════════════════════════════════════════
-- ۱. شمارش قبل از تبدیل
-- ═══════════════════════════════════════════════════════
SELECT 'before: has_part' AS metric, COUNT(*) AS n
FROM e01_222_01_tb
WHERE reltype_id = (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_part')
  AND status='asserted' AND superseded_at IS NULL;

-- ═══════════════════════════════════════════════════════
-- ۲. تبدیل has_part → has_direct_part
-- ═══════════════════════════════════════════════════════
UPDATE e01_222_01_tb
SET reltype_id = (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_direct_part')
WHERE reltype_id = (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_part');

-- ═══════════════════════════════════════════════════════
-- ۳. تبدیل part_of → part_of_directly
-- ═══════════════════════════════════════════════════════
UPDATE e01_222_01_tb
SET reltype_id = (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='part_of_directly')
WHERE reltype_id = (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='part_of');

-- ═══════════════════════════════════════════════════════
-- ۴. شمارش بعد
-- ═══════════════════════════════════════════════════════
SELECT 'after: has_direct_part' AS metric, COUNT(*) AS n
FROM e01_222_01_tb
WHERE reltype_id = (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_direct_part')
  AND status='asserted' AND superseded_at IS NULL;

SELECT 'after: has_part (residual)' AS metric, COUNT(*) AS n
FROM e01_222_01_tb
WHERE reltype_id = (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_part')
  AND status='asserted' AND superseded_at IS NULL;

INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v95_direct_part','Convert has_part → has_direct_part + part_of → part_of_directly');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- ═══════════════════════════════════════════════════════
-- ۵. ساخت view برای inference گذرا
-- ═══════════════════════════════════════════════════════
DROP VIEW IF EXISTS v_has_part_transitive;
CREATE VIEW v_has_part_transitive AS
WITH RECURSIVE transitive(subj, obj, depth) AS (
  SELECT r.subj_ent_id, r.obj_ent_id, 1
  FROM e01_222_01_tb r
  JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id
  WHERE rt.type_uid = 'has_direct_part'
    AND r.status='asserted' AND r.superseded_at IS NULL
  
  UNION
  
  SELECT t.subj, r.obj_ent_id, t.depth + 1
  FROM transitive t
  JOIN e01_222_01_tb r ON r.subj_ent_id = t.obj
  JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id
  WHERE rt.type_uid = 'has_direct_part'
    AND r.status='asserted' AND r.superseded_at IS NULL
    AND t.depth < 10
)
SELECT subj AS subj_ent_id, obj AS obj_ent_id, MIN(depth) AS min_depth
FROM transitive
GROUP BY subj, obj;

-- ═══════════════════════════════════════════════════════
-- ۶. گزارش
-- ═══════════════════════════════════════════════════════
SELECT 'entities' AS k, COUNT(*) AS n FROM e01_200_03_tb
UNION ALL SELECT 'relations', COUNT(*) FROM e01_222_01_tb;

SELECT '=== reltypes فعال ===' AS section;
SELECT rt.type_uid, rt.label, COUNT(*) AS n
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id
WHERE r.status='asserted' AND r.superseded_at IS NULL
  AND rt.type_uid IN ('has_part','has_direct_part','part_of','part_of_directly','composed_of')
GROUP BY rt.type_uid;

SELECT '=== نمونه: از خودرو تا قطعه ترمز (گذرا) ===' AS section;
SELECT 
  sub.ent_uid AS from_entity,
  obj.ent_uid AS to_entity,
  t.min_depth
FROM v_has_part_transitive t
JOIN e01_200_03_tb sub ON sub.ent_id = t.subj_ent_id
JOIN e01_200_03_tb obj ON obj.ent_id = t.obj_ent_id
WHERE sub.ent_uid = 'concept:vehicle'
  AND obj.ent_uid LIKE 'concept:brake-%'
ORDER BY t.min_depth, obj.ent_uid
LIMIT 10;
