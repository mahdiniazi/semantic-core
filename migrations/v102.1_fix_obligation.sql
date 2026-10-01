-- v102.1 — رفع تشخیص inherent_to در view
.mode column
.headers on

DROP VIEW IF EXISTS v_instance_parts;

CREATE VIEW v_instance_parts AS
WITH RECURSIVE
  ancestors(uid, level) AS (
    SELECT 'concept:pride', 0
    UNION
    SELECT obj.ent_uid, a.level + 1
    FROM ancestors a
    JOIN e01_200_03_tb sub ON sub.ent_uid = a.uid
    JOIN e01_222_01_tb r ON r.subj_ent_id = sub.ent_id
      AND r.status='asserted' AND r.superseded_at IS NULL
    JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='is_a'
    JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
    WHERE a.level < 10
  ),
  descendants(uid, obl, level) AS (
    SELECT a.uid, NULL, 0 FROM ancestors a
    UNION
    SELECT obj.ent_uid, rt.type_uid, d.level + 1
    FROM descendants d
    JOIN e01_200_03_tb sub ON sub.ent_uid = d.uid
    JOIN e01_222_01_tb r ON r.subj_ent_id = sub.ent_id
      AND r.status='asserted' AND r.superseded_at IS NULL
    JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id
      AND rt.type_uid IN ('has_direct_part','inherent_to')
    JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
    WHERE d.level < 6
  )
SELECT 
  uid, 
  MIN(level) AS min_level,
  CASE 
    WHEN SUM(CASE WHEN obl='inherent_to' THEN 1 ELSE 0 END) > 0 
      THEN 'inherent'
    WHEN SUM(CASE WHEN obl='has_direct_part' THEN 1 ELSE 0 END) > 0 
      THEN 'design'
    ELSE 'self'
  END AS obligation
FROM descendants
WHERE obl IS NOT NULL
GROUP BY uid;

-- ═══ گزارش ═══
SELECT '=== تعداد کل ===' AS section;
SELECT COUNT(*) AS n FROM v_instance_parts;

SELECT '=== تفکیک obligation ===' AS section;
SELECT obligation, COUNT(*) AS n
FROM v_instance_parts
GROUP BY obligation;

SELECT '=== نمونه: لاجرم‌ها (inherent) ===' AS section;
SELECT uid, min_level 
FROM v_instance_parts 
WHERE obligation='inherent'
ORDER BY uid
LIMIT 20;

SELECT '=== نمونه: طراحی (design) ===' AS section;
SELECT uid, min_level 
FROM v_instance_parts 
WHERE obligation='design'
ORDER BY uid
LIMIT 15;
