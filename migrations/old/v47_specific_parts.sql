-- v47 — قطعات اختصاصی: 3 قطعه × 9 خودرو = 27 نمونه
.mode column
.headers on

BEGIN;

-- =====================================================================
-- ۱. ساخت ۲۷ نمونه قطعه (لنت، کمک‌فنر، کمپرسور کولر)
-- =====================================================================
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id)
SELECT
  'part:' || v.vshort || '-' || p.pshort,
  (SELECT type_id FROM e01_200_01_tb WHERE type_uid = p.type_uid),
  'instance',
  p.label || ' ' || v.label,
  'قطعه اختصاصی — ' || v.label,
  2
FROM (
  SELECT 'pride' AS vshort, 'پراید' AS label UNION ALL
  SELECT '206', 'پژو ۲۰۶' UNION ALL
  SELECT '405', 'پژو ۴۰۵' UNION ALL
  SELECT 'dena', 'دنا' UNION ALL
  SELECT 'tiba', 'تیبا' UNION ALL
  SELECT 'quick', 'کوییک' UNION ALL
  SELECT 'samand', 'سمند' UNION ALL
  SELECT 'shahin', 'شاهین' UNION ALL
  SELECT 'sample', 'نمونه'
) v
CROSS JOIN (
  SELECT 'brake-pad' AS pshort, 'BrakePad' AS type_uid, 'لنت جلو' AS label UNION ALL
  SELECT 'shock-absorber', 'ShockAbsorber', 'کمک‌فنر جلو' UNION ALL
  SELECT 'ac-compressor', 'ACCompressor', 'کمپرسور کولر'
) p;

-- =====================================================================
-- ۲. instance_of: هر قطعه به مفهومش
-- =====================================================================
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || v.vshort || '-' || p.pshort || '-inst',
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='instance_of'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid = 'part:' || v.vshort || '-' || p.pshort),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid = 'concept:' || p.pshort),
  'asserted', 2
FROM (
  SELECT 'pride' AS vshort UNION ALL SELECT '206' UNION ALL SELECT '405' UNION ALL
  SELECT 'dena' UNION ALL SELECT 'tiba' UNION ALL SELECT 'quick' UNION ALL
  SELECT 'samand' UNION ALL SELECT 'shahin' UNION ALL SELECT 'sample'
) v
CROSS JOIN (
  SELECT 'brake-pad' AS pshort UNION ALL
  SELECT 'shock-absorber' UNION ALL
  SELECT 'ac-compressor'
) p
WHERE NOT EXISTS (
  SELECT 1 FROM e01_222_01_tb r 
  WHERE r.rel_uid = 'r:' || v.vshort || '-' || p.pshort || '-inst'
);

-- =====================================================================
-- ۳. installed_on: هر قطعه روی خودروی مربوطه
-- =====================================================================
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || v.vshort || '-' || p.pshort || '-on-vehicle',
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='installed_on'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid = 'part:' || v.vshort || '-' || p.pshort),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid = v.vuid),
  'asserted', 2
FROM (
  SELECT 'pride' AS vshort,  'vehicle:pride-1' AS vuid UNION ALL
  SELECT '206',              'vehicle:206-1' UNION ALL
  SELECT '405',              'vehicle:405-1' UNION ALL
  SELECT 'dena',             'vehicle:dena-1' UNION ALL
  SELECT 'tiba',             'vehicle:tiba-1' UNION ALL
  SELECT 'quick',            'vehicle:quick-1' UNION ALL
  SELECT 'samand',           'vehicle:samand-1' UNION ALL
  SELECT 'shahin',           'vehicle:shahin-1' UNION ALL
  SELECT 'sample',           'vehicle:sample-1'
) v
CROSS JOIN (
  SELECT 'brake-pad' AS pshort UNION ALL
  SELECT 'shock-absorber' UNION ALL
  SELECT 'ac-compressor'
) p
WHERE NOT EXISTS (
  SELECT 1 FROM e01_222_01_tb r 
  WHERE r.rel_uid = 'r:' || v.vshort || '-' || p.pshort || '-on-vehicle'
);

-- =====================================================================
-- ۴. لاگ
-- =====================================================================
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v47_specific_parts','Specific parts: 3 parts × 9 vehicles = 27 instances');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- =====================================================================
-- گزارش
-- =====================================================================
SELECT 'entities' AS k, COUNT(*) AS n FROM e01_200_03_tb
UNION ALL SELECT 'relations', COUNT(*) FROM e01_222_01_tb
UNION ALL SELECT 'specific_parts', COUNT(*) FROM e01_200_03_tb WHERE ent_uid LIKE 'part:%';

SELECT '=== نمونه‌های پراید ===' AS section;
SELECT 
  e.ent_uid AS part,
  e.label,
  obj.ent_uid AS installed_on
FROM e01_200_03_tb e
JOIN e01_222_01_tb r ON r.subj_ent_id = e.ent_id
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='installed_on'
JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
WHERE e.ent_uid LIKE 'part:pride-%'
ORDER BY e.ent_uid;
