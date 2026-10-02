-- v99 — نمای کامل چهارلایه با علامت لاجرم/طراحی
.mode column
.headers on

BEGIN;

-- ═══════════════════════════════════════════════════════
-- حذف و ساخت view
-- ═══════════════════════════════════════════════════════
DROP VIEW IF EXISTS v_full_hierarchy;
CREATE VIEW v_full_hierarchy AS
WITH RECURSIVE walk(
  level, root_uid, sub_uid, obj_uid, relation_kind, obligation, path, min_depth
) AS (
  -- سطح ۰: self
  SELECT 
    0, 
    e.ent_uid, 
    e.ent_uid, 
    e.ent_uid, 
    'self',
    'inherent',
    e.ent_uid,
    0
  FROM e01_200_03_tb e
  WHERE e.ent_uid = 'concept:vehicle'
  
  UNION ALL
  
  -- سطوح بعدی
  SELECT
    w.level + 1,
    w.root_uid,
    w.obj_uid,
    obj.ent_uid,
    rt.type_uid,
    CASE 
      WHEN rt.type_uid = 'inherent_to' THEN 'inherent'
      ELSE 'design'
    END,
    w.path || ' → ' || obj.label,
    w.level + 1
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
  level,
  root_uid,
  sub_uid,
  obj_uid,
  relation_kind,
  obligation,
  path
FROM walk;

COMMIT;

-- ═══════════════════════════════════════════════════════
-- گزارش
-- ═══════════════════════════════════════════════════════
SELECT '=== سطح ۱: دامنه‌ها ===' AS section;
SELECT obj_uid, obligation
FROM v_full_hierarchy
WHERE level = 1
ORDER BY obj_uid;

SELECT '=== سطح ۲: زیرسیستم‌ها (نمونه) ===' AS section;
SELECT obj_uid, obligation
FROM v_full_hierarchy
WHERE level = 2
ORDER BY obj_uid
LIMIT 20;

SELECT '=== شمارش هر سطح ===' AS section;
SELECT level, COUNT(*) AS n
FROM v_full_hierarchy
GROUP BY level
ORDER BY level;

SELECT '=== مسیرهای کامل تا قطعه (نمونه) ===' AS section;
SELECT path
FROM v_full_hierarchy
WHERE level = 3 AND obj_uid LIKE 'concept:brake-%'
ORDER BY obj_uid
LIMIT 5;

SELECT '=== قطعات لاجرم شاسی ===' AS section;
SELECT obj_uid, obligation
FROM v_full_hierarchy
WHERE level = 3 
  AND obligation = 'inherent'
  AND path LIKE '%شاسی%'
ORDER BY obj_uid
LIMIT 15;
