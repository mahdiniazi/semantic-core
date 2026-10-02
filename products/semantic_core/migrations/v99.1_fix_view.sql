.mode column
.headers on

DROP VIEW IF EXISTS v_full_hierarchy;

CREATE VIEW v_full_hierarchy AS
WITH RECURSIVE walk(level, obj_uid, path) AS (
  SELECT 0, 'concept:vehicle', 'concept:vehicle'
  
  UNION  -- ← dedup با UNION (نه UNION ALL)
  
  SELECT
    w.level + 1,
    obj.ent_uid,
    w.path || ' → ' || obj.label
  FROM walk w
  JOIN e01_200_03_tb sub ON sub.ent_uid = w.obj_uid
  JOIN e01_222_01_tb r ON r.subj_ent_id = sub.ent_id
    AND r.status='asserted' AND r.superseded_at IS NULL
  JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id
    AND rt.type_uid IN ('has_direct_part','inherent_to')
  JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
  WHERE w.level < 5
)
SELECT
  w.level,
  w.obj_uid,
  w.path,
  CASE 
    WHEN EXISTS (
      SELECT 1 FROM e01_222_01_tb r2
      JOIN e01_202_01_tb rt2 ON rt2.reltype_id = r2.reltype_id
      WHERE rt2.type_uid = 'inherent_to'
        AND r2.obj_ent_id = (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid = w.obj_uid)
        AND r2.status='asserted' AND r2.superseded_at IS NULL
    ) THEN 'inherent'
    ELSE 'design'
  END AS obligation
FROM walk w;

SELECT '=== شمارش هر سطح (بدون تکرار) ===' AS section;
SELECT level, COUNT(*) AS n
FROM v_full_hierarchy
GROUP BY level
ORDER BY level;

SELECT '=== سطح ۱ ===' AS section;
SELECT obj_uid, obligation FROM v_full_hierarchy WHERE level = 1 ORDER BY obj_uid;

SELECT '=== نمونه سطح ۳ (بدون تکرار) ===' AS section;
SELECT obj_uid, obligation 
FROM v_full_hierarchy 
WHERE level = 3 AND obj_uid LIKE 'concept:brake-%' 
ORDER BY obj_uid;
