-- =====================================================================
-- v32.0 — سناریوی تشخیصی P0301
-- =====================================================================
-- این فایل:
--   ۱. موجودیت‌های تشخیصی را می‌سازد (nature=instance)
--   ۲. آن‌ها را به نوع خودشان وصل می‌کند (instance_of)
--   ۳. زنجیره تشخیصی می‌سازد (diagnosed_as, tested_by, resolved_by, applies_to)
-- =====================================================================

.mode column
.headers on

BEGIN;

-- =====================================================================
-- بخش ۱ — موجودیت‌های تشخیصی (nature=instance)
-- =====================================================================

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES

-- تشخیص
('diagnosis:p0301-coil',
 (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Diagnosis'),
 'instance', 'تشخیص: کوئل سیلندر ۱ معیوب',
 'احتمال معیوب بودن کوئل سیلندر ۱ در این خودرو', 2),

-- تست‌ها
('test:coil-resistance',
 (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Test'),
 'instance', 'تست مقاومت کوئل',
 'اندازه‌گیری مقاومت سیم‌پیچ اولیه و ثانویه کوئل', 2),

('test:coil-spark',
 (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Test'),
 'instance', 'تست جرقه کوئل',
 'بررسی وجود جرقه در شمع سیلندر ۱', 2),

-- رویه
('procedure:replace-coil',
 (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Procedure'),
 'instance', 'رویه: تعویض کوئل',
 'مراحل تعویض کوئل سیلندر ۱', 2),

-- تعمیر انجام‌شده
('repair:coil-replaced',
 (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Repair'),
 'instance', 'تعمیر: کوئل تعویض شد',
 'رکورد تعمیر انجام‌شده — کوئل سیلندر ۱ تعویض شد', 2);

-- =====================================================================
-- بخش ۲ — اتصال به نوع (instance_of)
-- =====================================================================
-- هر instance به نوع خودش وصل می‌شود
-- (این کار را DB خودکار انجام نمی‌دهد، پس صریح می‌سازیم)

INSERT OR IGNORE INTO e01_222_01_tb
  (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
VALUES
('r:diag-p0301-instance-of-Diagnosis',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='instance_of'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:p0301-coil'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:coil-open'),
 'asserted', 2);

-- =====================================================================
-- بخش ۳ — زنجیره تشخیصی
-- =====================================================================

INSERT OR IGNORE INTO e01_222_01_tb
  (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
VALUES

-- ۱. شکست تشخیص داده می‌شود
('r:fm-coil-open-diagnosed-as-p0301',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='diagnosed_as'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:coil-open'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:p0301-coil'),
 'asserted', 2),

-- ۲. تشخیص با تست تأیید می‌شود
('r:diag-tested-by-resistance',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='tested_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:p0301-coil'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='test:coil-resistance'),
 'asserted', 2),

('r:diag-tested-by-spark',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='tested_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:p0301-coil'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='test:coil-spark'),
 'asserted', 2),

-- ۳. تشخیص با رویه حل می‌شود
('r:diag-resolved-by-procedure',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='resolved_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:p0301-coil'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='procedure:replace-coil'),
 'asserted', 2),

-- ۴. رویه به تعمیر منجر می‌شود
('r:procedure-resolved-by-repair',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='resolved_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='procedure:replace-coil'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='repair:coil-replaced'),
 'asserted', 2),

-- ۵. تعمیر روی خودرو انجام شد
('r:repair-applies-to-vehicle',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='applies_to'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='repair:coil-replaced'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='vehicle:sample-1'),
 'asserted', 2);

-- =====================================================================
-- لاگ
-- =====================================================================
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v32.0_diagnostic_scenario',
        'Full P0301 diagnostic scenario: 5 diagnostic entities + 7 diagnostic relations');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1, last_scan_at = datetime('now') WHERE id = 1;

COMMIT;

-- =====================================================================
-- گزارش
-- =====================================================================
SELECT '=== موجودیت‌ها ===' AS section;
SELECT COUNT(*) AS total_entities FROM e01_200_03_tb;

SELECT '=== روابط ===' AS section;
SELECT COUNT(*) AS total_relations FROM e01_222_01_tb;

SELECT '=== موجودیت‌های تشخیصی ===' AS section;
SELECT ent_uid, nature, label
FROM e01_200_03_tb
WHERE ent_uid LIKE 'diagnosis:%'
   OR ent_uid LIKE 'test:%'
   OR ent_uid LIKE 'procedure:%'
   OR ent_uid LIKE 'repair:%'
ORDER BY ent_uid;

SELECT '=== زنجیره تشخیصی ===' AS section;
SELECT 
  rt.type_uid AS step,
  se.ent_uid AS from_entity,
  oe.ent_uid AS to_entity
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id
JOIN e01_200_03_tb se ON se.ent_id = r.subj_ent_id
JOIN e01_200_03_tb oe ON oe.ent_id = r.obj_ent_id
WHERE se.ent_uid LIKE 'diagnosis:%'
   OR se.ent_uid LIKE 'procedure:%'
   OR se.ent_uid LIKE 'repair:%'
   OR se.ent_uid LIKE 'fm:coil%'
   OR oe.ent_uid LIKE 'diagnosis:%'
   OR oe.ent_uid LIKE 'test:%'
   OR oe.ent_uid LIKE 'procedure:%'
   OR oe.ent_uid LIKE 'repair:%'
ORDER BY step, from_entity;
