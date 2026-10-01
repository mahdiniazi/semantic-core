-- v52 — خودروسازها: ایرانی، کره‌ای، ژاپنی، آلمانی، فرانسوی، چینی
.mode column
.headers on

BEGIN;

-- =====================================================================
-- ۱. انواع سازنده (سلسله‌مراتب)
-- =====================================================================
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract) VALUES
('Manufacturer',         'سازنده خودرو',      1),
('IranianManufacturer',  'سازنده ایرانی',     1),
('KoreanManufacturer',   'سازنده کره‌ای',     1),
('JapaneseManufacturer', 'سازنده ژاپنی',      1),
('GermanManufacturer',   'سازنده آلمانی',     1),
('FrenchManufacturer',   'سازنده فرانسوی',    1),
('ChineseManufacturer',  'سازنده چینی',       1),
('AmericanManufacturer', 'سازنده آمریکایی',   1);

UPDATE e01_200_01_tb 
SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Manufacturer')
WHERE type_uid IN ('IranianManufacturer','KoreanManufacturer','JapaneseManufacturer',
                   'GermanManufacturer','FrenchManufacturer','ChineseManufacturer',
                   'AmericanManufacturer');

-- =====================================================================
-- ۲. انواع رابطه جدید
-- =====================================================================
INSERT OR IGNORE INTO e01_202_01_tb (type_uid, label, description, object_kind) VALUES
('manufactured_by', 'ساخته شده توسط', 'محصول → سازنده', 'entity'),
('manufacturer_of', 'سازنده‌ی',        'سازنده → محصول', 'entity');

UPDATE e01_202_01_tb SET inverse_uid = 'manufacturer_of' WHERE type_uid = 'manufactured_by';
UPDATE e01_202_01_tb SET inverse_uid = 'manufactured_by' WHERE type_uid = 'manufacturer_of';

-- قاعده چیزسازی
INSERT OR IGNORE INTO e01_202_02_tb (reltype_id, reify_rule, category, reason)
SELECT reltype_id, 'when_data', 'structural', 'ساختار سازنده — چیزسازی اگر داده دارد'
FROM e01_202_01_tb WHERE type_uid IN ('manufactured_by','manufacturer_of');

-- =====================================================================
-- ۳. مفهوم سازنده‌ها
-- =====================================================================
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES

-- ---- ایرانی ----
('concept:ikco',       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='IranianManufacturer'),'concept','ایران خودرو','Iran Khodro — بزرگ‌ترین خودروساز ایران',2),
('concept:saipa',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='IranianManufacturer'),'concept','سایپا','Saipa — دومین خودروساز ایران',2),
('concept:parskhodro', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='IranianManufacturer'),'concept','پارس خودرو','Pars Khodro',2),
('concept:kermanmotor',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='IranianManufacturer'),'concept','کرمان موتور','Kerman Motor',2),
('concept:bahman',     (SELECT type_id FROM e01_200_01_tb WHERE type_uid='IranianManufacturer'),'concept','بهمن','Bahman Group',2),

-- ---- کره‌ای ----
('concept:hyundai',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='KoreanManufacturer'),'concept','هیوندای','Hyundai Motor Company',2),
('concept:kia',       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='KoreanManufacturer'),'concept','کیا','Kia Corporation',2),
('concept:genesis',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='KoreanManufacturer'),'concept','جنسیس','Genesis Motor',2),
('concept:ssangyong', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='KoreanManufacturer'),'concept','سانگ‌یونگ','SsangYong / KG Mobility',2),
('concept:daewoo',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='KoreanManufacturer'),'concept','دوو','Daewoo — تاریخی',2),

-- ---- فرانسوی ----
('concept:peugeot', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='FrenchManufacturer'),'concept','پژو','Peugeot',2),
('concept:citroen', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='FrenchManufacturer'),'concept','سیتروئن','Citroën',2),
('concept:renault', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='FrenchManufacturer'),'concept','رنو','Renault',2),

-- ---- ژاپنی ----
('concept:toyota',     (SELECT type_id FROM e01_200_01_tb WHERE type_uid='JapaneseManufacturer'),'concept','تویوتا','Toyota',2),
('concept:honda',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='JapaneseManufacturer'),'concept','هوندا','Honda',2),
('concept:nissan',     (SELECT type_id FROM e01_200_01_tb WHERE type_uid='JapaneseManufacturer'),'concept','نیسان','Nissan',2),
('concept:mitsubishi', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='JapaneseManufacturer'),'concept','میتسوبیشی','Mitsubishi',2),
('concept:suzuki',     (SELECT type_id FROM e01_200_01_tb WHERE type_uid='JapaneseManufacturer'),'concept','سوزوکی','Suzuki',2),

-- ---- آلمانی ----
('concept:bmw',        (SELECT type_id FROM e01_200_01_tb WHERE type_uid='GermanManufacturer'),'concept','بی‌ام‌و','BMW',2),
('concept:mercedes',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='GermanManufacturer'),'concept','مرسدس بنز','Mercedes-Benz',2),
('concept:volkswagen', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='GermanManufacturer'),'concept','فولکس‌واگن','Volkswagen',2),
('concept:audi',       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='GermanManufacturer'),'concept','آئودی','Audi',2),
('concept:porsche',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='GermanManufacturer'),'concept','پورشه','Porsche',2),

-- ---- چینی ----
('concept:chery',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='ChineseManufacturer'),'concept','چری','Chery',2),
('concept:jac',        (SELECT type_id FROM e01_200_01_tb WHERE type_uid='ChineseManufacturer'),'concept','جک','JAC Motors',2),
('concept:brilliance', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='ChineseManufacturer'),'concept','برلیانس','Brilliance Auto',2),
('concept:lifan',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='ChineseManufacturer'),'concept','لیفان','Lifan',2),
('concept:haval',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='ChineseManufacturer'),'concept','هاوال','Haval',2),
('concept:geely',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='ChineseManufacturer'),'concept','جیلی','Geely',2),
('concept:byd',        (SELECT type_id FROM e01_200_01_tb WHERE type_uid='ChineseManufacturer'),'concept','بی‌وای‌دی','BYD',2),

-- ---- آمریکایی ----
('concept:chevrolet', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='AmericanManufacturer'),'concept','شورولت','Chevrolet',2),
('concept:ford',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='AmericanManufacturer'),'concept','فورد','Ford',2);

-- =====================================================================
-- ۴. اتصال خودروهای موجود به سازنده
-- =====================================================================
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || REPLACE(p.product, ':', '-') || '-by-' || REPLACE(p.maker, ':', '-'),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='manufactured_by'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.product),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.maker),
  'asserted', 2
FROM (
  SELECT 'concept:pride'  AS product, 'concept:saipa' AS maker UNION ALL
  SELECT 'concept:tiba',              'concept:saipa' UNION ALL
  SELECT 'concept:quick',             'concept:saipa' UNION ALL
  SELECT 'concept:shahin',            'concept:saipa' UNION ALL
  SELECT 'concept:samand',            'concept:ikco'  UNION ALL
  SELECT 'concept:dena',              'concept:ikco'  UNION ALL
  SELECT 'concept:405',               'concept:ikco'  UNION ALL
  SELECT 'concept:206',               'concept:ikco'
) p
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.product)
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.maker)
  AND NOT EXISTS (
    SELECT 1 FROM e01_222_01_tb r
    WHERE r.rel_uid = 'r:' || REPLACE(p.product, ':', '-') || '-by-' || REPLACE(p.maker, ':', '-')
  );

-- =====================================================================
-- ۵. لاگ
-- =====================================================================
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v52_manufacturers','Manufacturers: 30 companies across 7 countries');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- =====================================================================
-- گزارش
-- =====================================================================
SELECT 'entities' AS k, COUNT(*) AS n FROM e01_200_03_tb
UNION ALL SELECT 'relations', COUNT(*) FROM e01_222_01_tb
UNION ALL SELECT 'manufacturers', COUNT(*) FROM e01_200_03_tb
UNION ALL SELECT 'manufactured_by_relations', COUNT(*) FROM e01_222_01_tb
  WHERE reltype_id = (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='manufactured_by');

SELECT '=== سازنده‌ها بر اساس کشور ===' AS section;
SELECT 
  t.type_uid AS country,
  COUNT(e.ent_id) AS n
FROM e01_200_01_tb t
LEFT JOIN e01_200_03_tb e ON e.type_id = t.type_id
WHERE t.type_uid IN ('IranianManufacturer','KoreanManufacturer','JapaneseManufacturer',
                     'GermanManufacturer','FrenchManufacturer','ChineseManufacturer','AmericanManufacturer')
GROUP BY t.type_uid
ORDER BY n DESC;

SELECT '=== خودروها و سازنده ===' AS section;
SELECT 
  p.ent_uid AS product,
  p.label AS product_label,
  m.ent_uid AS maker,
  m.label AS maker_label
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='manufactured_by'
JOIN e01_200_03_tb p ON p.ent_id = r.subj_ent_id
JOIN e01_200_03_tb m ON m.ent_id = r.obj_ent_id
ORDER BY m.ent_uid, p.ent_uid;
