-- v102 — استخراج کامل قطعات ارث‌بری برای instance
.mode column
.headers on

BEGIN;

-- ═══════════════════════════════════════════════════════
-- ۱. اصلاح: حذف ee-architecture → ev-subsystem
-- ═══════════════════════════════════════════════════════
UPDATE e01_222_01_tb
SET status = 'retracted', superseded_at = datetime('now')
WHERE rel_uid = 'r:ee-architecture-has-ev-subsystem';

-- ═══════════════════════════════════════════════════════
-- ۲. ساخت view v_instance_parts
-- ═══════════════════════════════════════════════════════
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
    SELECT a.uid, 'self', 0 FROM ancestors a
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
  MIN(obl) AS obligation_priority
FROM descendants
WHERE obl != 'self'
GROUP BY uid;

INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v102_inheritance','Fixed ev-subsystem + created v_instance_parts view');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- ═══════════════════════════════════════════════════════
-- گزارش
-- ═══════════════════════════════════════════════════════
SELECT '=== تعداد کل قطعات ارث‌بری concept:pride ===' AS section;
SELECT COUNT(*) AS n FROM v_instance_parts;

SELECT '=== تفکیک بر اساس لایه ===' AS section;
SELECT 
  CASE
    WHEN ent_uid LIKE 'concept:%-domain' OR ent_uid = 'concept:ee-architecture' THEN 'L1-دامنه'
    WHEN ent_uid LIKE 'concept:%-subsystem' THEN 'L2-زیرسیستم'
    WHEN ent_uid LIKE 'concept:%-dcu' THEN 'L2-DCU'
    ELSE 'L3-قطعه'
  END AS layer,
  COUNT(*) AS n
FROM v_instance_parts v
JOIN e01_200_03_tb e ON e.ent_uid = v.uid
GROUP BY layer;

SELECT '=== تفکیک بر اساس obligation ===' AS section;
SELECT obligation_priority, COUNT(*) AS n
FROM v_instance_parts
GROUP BY obligation_priority
ORDER BY obligation_priority;

SELECT '=== نمونه قطعات ===' AS section;
SELECT uid, min_level, obligation_priority 
FROM v_instance_parts 
ORDER BY min_level DESC, uid 
LIMIT 15;
