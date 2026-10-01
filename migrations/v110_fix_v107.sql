-- v110 — تبدیل رکوردهای v107 (may_have) به v108 (designed_with)
.mode column
.headers on

BEGIN;

-- ═══════════════════════════════════════════════════════
-- ۱. قبل از تبدیل
-- ═══════════════════════════════════════════════════════
SELECT 'before' AS step,
  (SELECT COUNT(*) FROM e01_222_01_tb r
   JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id
   WHERE rt.type_uid='may_have_direct_part' AND r.rel_uid LIKE 'r:design-%'
     AND r.status='asserted' AND r.superseded_at IS NULL) AS design_may_have,
  (SELECT COUNT(*) FROM e01_222_01_tb r
   JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id
   WHERE rt.type_uid='designed_with'
     AND r.status='asserted' AND r.superseded_at IS NULL) AS designed_with;

-- ═══════════════════════════════════════════════════════
-- ۲. تبدیل
-- ═══════════════════════════════════════════════════════
UPDATE e01_222_01_tb
SET reltype_id = (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='designed_with')
WHERE rel_uid LIKE 'r:design-%'
  AND reltype_id = (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='may_have_direct_part')
  AND status='asserted' AND superseded_at IS NULL;

-- ═══════════════════════════════════════════════════════
-- ۳. بعد از تبدیل
-- ═══════════════════════════════════════════════════════
SELECT 'after' AS step,
  (SELECT COUNT(*) FROM e01_222_01_tb r
   JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id
   WHERE rt.type_uid='may_have_direct_part' AND r.rel_uid LIKE 'r:design-%'
     AND r.status='asserted' AND r.superseded_at IS NULL) AS design_may_have,
  (SELECT COUNT(*) FROM e01_222_01_tb r
   JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id
   WHERE rt.type_uid='designed_with'
     AND r.status='asserted' AND r.superseded_at IS NULL) AS designed_with;

INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v110_fix_v107','Converted v107 may_have design entries to designed_with');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- ═══ گزارش نهایی طراحی هر مدل ═══
SELECT '' AS x;
SELECT '═══ طراحی خاص هر مدل (اصلاح‌شده) ═══' AS section;
SELECT 
  sub.label AS model,
  COUNT(*) AS n_design_features
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='designed_with'
JOIN e01_200_03_tb sub ON sub.ent_id = r.subj_ent_id
WHERE r.status='asserted' AND r.superseded_at IS NULL
GROUP BY sub.ent_uid
ORDER BY n_design_features DESC;
