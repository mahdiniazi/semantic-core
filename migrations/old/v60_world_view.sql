-- v60 — نمای جامع دنیای خودرو
.mode column
.headers on

SELECT '════════════════════════════════════════════' AS divider;
SELECT '      نمای جامع دنیای خودرو' AS title;
SELECT '════════════════════════════════════════════' AS divider;

SELECT '=== ۱. آمار کلی ===' AS section;
SELECT 'موجودیت‌ها' AS metric, CAST(COUNT(*) AS TEXT) AS n FROM e01_200_03_tb
UNION ALL SELECT 'روابط', CAST(COUNT(*) AS TEXT) FROM e01_222_01_tb
UNION ALL SELECT 'انواع موجودیت', CAST(COUNT(*) AS TEXT) FROM e01_200_01_tb
UNION ALL SELECT 'انواع رابطه', CAST(COUNT(*) AS TEXT) FROM e01_202_01_tb;

SELECT '=== ۲. سازندگان بر اساس کشور ===' AS section;
SELECT 
  t.label AS country,
  COUNT(e.ent_id) AS makers
FROM e01_200_01_tb t
JOIN e01_200_03_tb e ON e.type_id = t.type_id
WHERE t.type_uid IN (
  'IranianManufacturer','KoreanManufacturer','JapaneseManufacturer',
  'GermanManufacturer','FrenchManufacturer','ChineseManufacturer',
  'AmericanManufacturer','MotorcycleManufacturer','TruckManufacturer'
)
GROUP BY t.type_uid
ORDER BY makers DESC;

SELECT '=== ۳. دسته‌بندی خودروها ===' AS section;
SELECT 
  'خودرو سواری' AS category,
  COUNT(DISTINCT r.obj_ent_id) AS n
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='manufactured_by'
JOIN e01_200_03_tb p ON p.ent_id = r.subj_ent_id
WHERE p.type_id IN (SELECT type_id FROM e01_200_01_tb WHERE type_uid='PassengerCar')
UNION ALL
SELECT 
  'موتورسیکلت',
  COUNT(DISTINCT r.obj_ent_id)
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='manufactured_by'
JOIN e01_200_03_tb p ON p.ent_id = r.subj_ent_id
WHERE p.type_id IN (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Motorcycle')
UNION ALL
SELECT 
  'کامیون',
  COUNT(DISTINCT r.obj_ent_id)
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='manufactured_by'
JOIN e01_200_03_tb p ON p.ent_id = r.subj_ent_id
WHERE p.type_id IN (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Truck');

SELECT '=== ۴. سیستم‌های اصلی ===' AS section;
SELECT 
  e.ent_uid AS system,
  e.label,
  (SELECT COUNT(*) FROM e01_222_01_tb r 
     WHERE r.subj_ent_id = e.ent_id 
       AND r.reltype_id = (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_part')
  ) AS n_parts
FROM e01_200_03_tb e
WHERE e.ent_uid IN ('concept:vehicle','concept:passenger-car','concept:motorcycle','concept:truck')
ORDER BY n_parts DESC;

SELECT '=== ۵. زنجیره‌های تشخیصی ===' AS section;
SELECT 
  COUNT(DISTINCT ent_uid) AS n_diagnoses
FROM e01_200_03_tb
WHERE ent_uid LIKE 'diagnosis:%';

SELECT '=== ۶. لیست تمام خودروها ===' AS section;
SELECT 
  p.label AS model,
  m.label AS maker,
  t.label AS maker_country
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='manufactured_by'
JOIN e01_200_03_tb p ON p.ent_id = r.subj_ent_id
JOIN e01_200_03_tb m ON m.ent_id = r.obj_ent_id
JOIN e01_200_01_tb t ON t.type_id = m.type_id
WHERE t.type_uid LIKE '%Manufacturer'
ORDER BY t.type_uid, m.label, p.label;
