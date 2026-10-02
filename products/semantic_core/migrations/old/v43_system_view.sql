-- v43 — نمای جامع سیستم
.mode column
.headers on

-- =====================================================================
-- ۱. وضعیت کلی
-- =====================================================================
SELECT '=== ۱. وضعیت کلی ===' AS section;
SELECT 'موجودیت‌ها' AS metric, CAST(COUNT(*) AS TEXT) AS value FROM e01_200_03_tb
UNION ALL SELECT 'روابط', CAST(COUNT(*) AS TEXT) FROM e01_222_01_tb
UNION ALL SELECT 'انواع موجودیت', CAST(COUNT(*) AS TEXT) FROM e01_200_01_tb
UNION ALL SELECT 'انواع رابطه', CAST(COUNT(*) AS TEXT) FROM e01_202_01_tb
UNION ALL SELECT 'مقادیر', CAST(COUNT(*) AS TEXT) FROM e01_201_02_tb
UNION ALL SELECT 'مفهوم‌ها', CAST(COUNT(*) AS TEXT) FROM e01_200_03_tb WHERE ent_uid LIKE 'concept:%'
UNION ALL SELECT 'نمونه‌ها', CAST(COUNT(*) AS TEXT) FROM e01_200_03_tb WHERE ent_uid LIKE 'vehicle:%' OR ent_uid LIKE 'battery:%' OR ent_uid LIKE 'ecu:%'
UNION ALL SELECT 'چیز-شده‌ها', CAST(COUNT(*) AS TEXT) FROM e01_200_03_tb WHERE ent_uid LIKE 'reif:%';

-- =====================================================================
-- ۲. سلسله‌مراتب خودرو
-- =====================================================================
SELECT '' AS blank, '' AS a, '' AS b;
SELECT '=== ۲. سلسله‌مراتب مفهوم ===' AS section;
SELECT 
  '  ' || sub.ent_uid AS child,
  '→' AS arrow,
  obj.ent_uid AS parent
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid = 'is_a'
JOIN e01_200_03_tb sub ON sub.ent_id = r.subj_ent_id
JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
WHERE sub.ent_uid LIKE 'concept:%'
ORDER BY sub.ent_uid;

-- =====================================================================
-- ۳. قطعات هر مفهوم
-- =====================================================================
SELECT '' AS blank, '' AS a, '' AS b;
SELECT '=== ۳. قطعات هر مفهوم ===' AS section;
SELECT 
  '  ' || sub.ent_uid AS concept,
  '→ has_part →' AS arrow,
  obj.label AS part
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid = 'has_part'
JOIN e01_200_03_tb sub ON sub.ent_id = r.subj_ent_id
JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
ORDER BY sub.ent_uid, obj.ent_uid;

-- =====================================================================
-- ۴. زنجیره‌های تشخیصی کامل
-- =====================================================================
SELECT '' AS blank, '' AS a, '' AS b;
SELECT '=== ۴. زنجیره‌های تشخیصی ===' AS section;
SELECT 
  '  ' || se.ent_uid AS from_entity,
  rt.type_uid AS relation,
  oe.ent_uid AS to_entity
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id
JOIN e01_200_03_tb se ON se.ent_id = r.subj_ent_id
JOIN e01_200_03_tb oe ON oe.ent_id = r.obj_ent_id
WHERE rt.type_uid IN ('diagnosed_as','tested_by','resolved_by','applies_to')
ORDER BY se.ent_uid, rt.type_uid
LIMIT 30;

-- =====================================================================
-- ۵. خودروها و قطعات مستقیم
-- =====================================================================
SELECT '' AS blank, '' AS a, '' AS b;
SELECT '=== ۵. خودروها ===' AS section;
SELECT 
  '  ' || v.ent_uid AS vehicle,
  COUNT(r.rel_id) AS direct_parts,
  ' (بقیه از ارث‌بری)' AS note
FROM e01_200_03_tb v
LEFT JOIN e01_222_01_tb r ON r.subj_ent_id = v.ent_id
  AND r.reltype_id = (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='installed_on')
WHERE v.ent_uid LIKE 'vehicle:%'
GROUP BY v.ent_id
ORDER BY v.ent_uid;
