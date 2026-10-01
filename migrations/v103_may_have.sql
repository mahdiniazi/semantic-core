-- v103 — تفکیک «دارد» از «می‌تواند داشته باشد»
.mode column
.headers on

BEGIN;

-- ═══════════════════════════════════════════════════════
-- ۱. ساخت reltype جدید
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_202_01_tb
  (type_uid, label, description, object_kind, is_symmetric, is_transitive, is_functional, inverse_uid)
VALUES
  ('may_have_direct_part','می‌تواند داشته باشد','امکان ساختاری — در سطح نوع','entity',0,0,0,NULL);

INSERT OR IGNORE INTO e01_202_02_tb (reltype_id, reify_rule, category, reason)
SELECT reltype_id, 'never', 'structural', 'امکان ساختاری — بدون داده'
FROM e01_202_01_tb WHERE type_uid='may_have_direct_part';

-- ═══════════════════════════════════════════════════════
-- ۲. تبدیل: has_direct_part (concept-level) → may_have_direct_part
-- ═══════════════════════════════════════════════════════
SELECT 'before' AS step, 
  (SELECT COUNT(*) FROM e01_222_01_tb r
   JOIN e01_202_01_tb rt ON rt.reltype_id=r.reltype_id AND rt.type_uid='has_direct_part'
   JOIN e01_200_03_tb sub ON sub.ent_id=r.subj_ent_id
   WHERE sub.nature='concept' AND r.status='asserted' AND r.superseded_at IS NULL) AS concept_level,
  (SELECT COUNT(*) FROM e01_222_01_tb r
   JOIN e01_202_01_tb rt ON rt.reltype_id=r.reltype_id AND rt.type_uid='has_direct_part'
   JOIN e01_200_03_tb sub ON sub.ent_id=r.subj_ent_id
   WHERE sub.nature='instance' AND r.status='asserted' AND r.superseded_at IS NULL) AS instance_level;

-- تبدیل concept-level ها
UPDATE e01_222_01_tb
SET reltype_id = (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='may_have_direct_part')
WHERE reltype_id = (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_direct_part')
  AND subj_ent_id IN (SELECT ent_id FROM e01_200_03_tb WHERE nature='concept')
  AND status='asserted' AND superseded_at IS NULL;

-- ═══════════════════════════════════════════════════════
-- ۳. گزارش
-- ═══════════════════════════════════════════════════════
SELECT 'after: may_have' AS metric, COUNT(*) AS n
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id=r.reltype_id AND rt.type_uid='may_have_direct_part'
WHERE r.status='asserted' AND r.superseded_at IS NULL;

SELECT 'after: has_direct' AS metric, COUNT(*) AS n
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id=r.reltype_id AND rt.type_uid='has_direct_part'
WHERE r.status='asserted' AND r.superseded_at IS NULL;

SELECT 'after: inherent' AS metric, COUNT(*) AS n
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id=r.reltype_id AND rt.type_uid='inherent_to'
WHERE r.status='asserted' AND r.superseded_at IS NULL;

INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v103_may_have','Split has_direct_part (concept-level) into may_have_direct_part');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- ═══════════════════════════════════════════════════════
-- ۴. view اصلاح‌شده — فقط لاجرم‌ها + انتخاب‌های instance
-- ═══════════════════════════════════════════════════════
DROP VIEW IF EXISTS v_instance_parts;
CREATE VIEW v_instance_parts AS
WITH RECURSIVE
  -- ancestors: مفهوم پراید + والدهایش
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
  -- لاجرم‌ها: inherent_to از اجداد
  mandatory(uid, level) AS (
    SELECT obj.ent_uid, d.level + 1
    FROM ancestors a
    JOIN e01_200_03_tb sub ON sub.ent_uid = a.uid
    JOIN e01_222_01_tb r ON r.subj_ent_id = sub.ent_id
      AND r.status='asserted' AND r.superseded_at IS NULL
    JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='inherent_to'
    JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
    JOIN (SELECT 0 AS level) d
    UNION
    -- زنجیره inherent ها
    SELECT obj.ent_uid, m.level + 1
    FROM mandatory m
    JOIN e01_200_03_tb sub ON sub.ent_uid = m.uid
    JOIN e01_222_01_tb r ON r.subj_ent_id = sub.ent_id
      AND r.status='asserted' AND r.superseded_at IS NULL
    JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='inherent_to'
    JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
    WHERE m.level < 6
  ),
  -- انتخاب‌های instance
  chosen(uid) AS (
    SELECT obj.ent_uid
    FROM e01_222_01_tb r
    JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='has_direct_part'
    JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
    WHERE r.subj_ent_id = (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='vehicle:pride-24IR12345')
      AND r.status='asserted' AND r.superseded_at IS NULL
  )
SELECT 
  m.uid,
  MIN(m.level) AS min_level,
  'inherent' AS obligation
FROM mandatory m
GROUP BY m.uid
UNION
SELECT uid, 99, 'chosen' FROM chosen;

-- ═══════════════════════════════════════════════════════
-- ۵. گزارش نهایی
-- ═══════════════════════════════════════════════════════
SELECT '=== پراید احمدی — چیزهایی که دارد ===' AS section;
SELECT obligation, COUNT(*) AS n
FROM v_instance_parts
GROUP BY obligation;

SELECT '=== نمونه لاجرم‌ها ===' AS section;
SELECT uid FROM v_instance_parts WHERE obligation='inherent' ORDER BY uid LIMIT 15;

SELECT '=== انتخاب‌های خاص ===' AS section;
SELECT uid FROM v_instance_parts WHERE obligation='chosen' ORDER BY uid;
