-- v44 — تمیزکاری: بازنشستگی روابط تکراری
.mode column
.headers on

BEGIN;

-- =====================================================================
-- ۱. بازنشستگی همه installed_on های مربوط به sample-1
-- =====================================================================
-- این‌ها حالا از ارث‌بری (concept:passenger-car → has_part) می‌آیند
UPDATE e01_222_01_tb 
SET status = 'retracted', 
    superseded_at = datetime('now')
WHERE reltype_id = (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='installed_on')
  AND obj_ent_id = (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='vehicle:sample-1')
  AND status = 'asserted'
  AND superseded_at IS NULL;

-- =====================================================================
-- ۲. بازنشستگی روابط انتقال/کنترل/تأمین نمونه‌های نمونه‌ای
-- =====================================================================
-- این‌ها همان اطلاعاتی هستند که در سطح کلاس تعریف شده‌اند
UPDATE e01_222_01_tb 
SET status = 'retracted', 
    superseded_at = datetime('now')
WHERE obj_ent_id = (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='vehicle:sample-1')
  AND reltype_id IN (
    SELECT reltype_id FROM e01_202_01_tb 
    WHERE type_uid IN ('installed_on', 'part_of')
  )
  AND status = 'asserted'
  AND superseded_at IS NULL;

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v44_cleanup_generic','Retracted redundant installed_on relations (now via inheritance)');

COMMIT;

-- =====================================================================
-- گزارش
-- =====================================================================
SELECT '=== وضعیت ===' AS section;
SELECT 
  CASE WHEN status='asserted' AND superseded_at IS NULL THEN 'active' ELSE 'inactive' END AS state,
  COUNT(*) AS n
FROM e01_222_01_tb
GROUP BY state;

SELECT '=== گالری (فعال) ===' AS section;
SELECT 
  v.ent_uid AS vehicle,
  v.label,
  COUNT(r.rel_id) AS direct_parts
FROM e01_200_03_tb v
LEFT JOIN e01_222_01_tb r ON r.obj_ent_id = v.ent_id
  AND r.reltype_id = (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='installed_on')
  AND r.status = 'asserted'
  AND r.superseded_at IS NULL
WHERE v.ent_uid LIKE 'vehicle:%'
GROUP BY v.ent_id
ORDER BY v.ent_uid;
