-- v67 — خودروهای انگلیسی
.mode column
.headers on

BEGIN;

-- =====================================================================
-- ۱. انواع خودروی انگلیسی
-- =====================================================================
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract) VALUES
-- بنتلی
('BentleyContinental',  'بنتلی کانتیننتال', 0),
('BentleyFlyingSpur',   'بنتلی فلایینگ اسپر',0),
('BentleyBentayga',     'بنتلی بنتایگا',    0),
-- رولزرویس
('RollsRoycePhantom',   'رولزرویس فانتوم',  0),
('RollsRoyceGhost',     'رولزرویس گوست',    0),
('RollsRoyceCullinan',  'رولزرویس کولینان', 0),
-- استون مارتین
('AstonMartinDB11',     'استون مارتین DB11',0),
('AstonMartinVantage',  'استون مارتین ونتیج',0),
('AstonMartinDBX',      'استون مارتین DBX', 0),
-- جگوار
('JaguarXJ',            'جگوار XJ',          0),
('JaguarXF',            'جگوار XF',          0),
('JaguarFType',         'جگوار F-Type',      0),
('JaguarFPace',         'جگوار F-Pace',      0),
('JaguarIPace',         'جگوار I-Pace',      0),
-- لندروور
('RangeRover',          'رنجرور',            0),
('RangeRoverSport',     'رنجرور اسپرت',      0),
('RangeRoverEvoque',    'رنجرور ایووک',      0),
('LandRoverDiscovery',  'لندروور دیسکاوری',  0),
('LandRoverDefender',   'لندروور دیفندر',    0),
-- مینی
('MiniCooper',          'مینی کوپر',         0),
('MiniCountryman',      'مینی کانتری‌من',    0),
-- لوتوس
('LotusEmira',          'لوتوس امیرا',       0),
('LotusEvija',          'لوتوس اویجا',       0),
-- مکلارن
('McLaren720S',         'مکلارن ۷۲۰S',       0),
('McLarenArtura',       'مکلارن آرتورا',     0),
-- MG
('MGMG4',               'MG 4',              0),
('MGZS',                'MG ZS',             0),
('MGHS',                'MG HS',             0);

UPDATE e01_200_01_tb 
SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='PassengerCar')
WHERE type_uid IN (
  'BentleyContinental','BentleyFlyingSpur','BentleyBentayga',
  'RollsRoycePhantom','RollsRoyceGhost','RollsRoyceCullinan',
  'AstonMartinDB11','AstonMartinVantage','AstonMartinDBX',
  'JaguarXJ','JaguarXF','JaguarFType','JaguarFPace','JaguarIPace',
  'RangeRover','RangeRoverSport','RangeRoverEvoque',
  'LandRoverDiscovery','LandRoverDefender',
  'MiniCooper','MiniCountryman',
  'LotusEmira','LotusEvija',
  'McLaren720S','McLarenArtura',
  'MGMG4','MGZS','MGHS'
);

-- =====================================================================
-- ۲. سازندگان انگلیسی
-- =====================================================================
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract) VALUES
('BritishManufacturer', 'سازنده انگلیسی', 1);

UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Manufacturer')
  WHERE type_uid = 'BritishManufacturer';

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('concept:bentley',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='BritishManufacturer'),'concept','بنتلی','Bentley Motors',2),
('concept:rolls-royce',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='BritishManufacturer'),'concept','رولزرویس','Rolls-Royce Motor Cars',2),
('concept:aston-martin', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='BritishManufacturer'),'concept','استون مارتین','Aston Martin',2),
('concept:jaguar',       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='BritishManufacturer'),'concept','جگوار','Jaguar',2),
('concept:land-rover',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='BritishManufacturer'),'concept','لندروور','Land Rover',2),
('concept:mini',         (SELECT type_id FROM e01_200_01_tb WHERE type_uid='BritishManufacturer'),'concept','مینی','MINI',2),
('concept:lotus',        (SELECT type_id FROM e01_200_01_tb WHERE type_uid='BritishManufacturer'),'concept','لوتوس','Lotus Cars',2),
('concept:mclaren',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='BritishManufacturer'),'concept','مکلارن','McLaren Automotive',2),
('concept:mg',           (SELECT type_id FROM e01_200_01_tb WHERE type_uid='BritishManufacturer'),'concept','MG','MG Motor',2);

-- =====================================================================
-- ۳. مفاهیم خودروها
-- =====================================================================
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
-- بنتلی
('concept:bentley-continental',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='BentleyContinental'),'concept','بنتلی کانتیننتال','Bentley Continental GT',2),
('concept:bentley-flying-spur',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='BentleyFlyingSpur'),'concept','بنتلی فلایینگ اسپر','Bentley Flying Spur',2),
('concept:bentley-bentayga',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='BentleyBentayga'),'concept','بنتلی بنتایگا','Bentley Bentayga SUV',2),
-- رولزرویس
('concept:rr-phantom',        (SELECT type_id FROM e01_200_01_tb WHERE type_uid='RollsRoycePhantom'),'concept','رولزرویس فانتوم','Rolls-Royce Phantom',2),
('concept:rr-ghost',          (SELECT type_id FROM e01_200_01_tb WHERE type_uid='RollsRoyceGhost'),'concept','رولزرویس گوست','Rolls-Royce Ghost',2),
('concept:rr-cullinan',       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='RollsRoyceCullinan'),'concept','رولزرویس کولینان','Rolls-Royce Cullinan SUV',2),
-- استون مارتین
('concept:aston-db11',        (SELECT type_id FROM e01_200_01_tb WHERE type_uid='AstonMartinDB11'),'concept','استون مارتین DB11','Aston Martin DB11',2),
('concept:aston-vantage',     (SELECT type_id FROM e01_200_01_tb WHERE type_uid='AstonMartinVantage'),'concept','استون مارتین ونتیج','Aston Martin Vantage',2),
('concept:aston-dbx',         (SELECT type_id FROM e01_200_01_tb WHERE type_uid='AstonMartinDBX'),'concept','استون مارتین DBX','Aston Martin DBX SUV',2),
-- جگوار
('concept:jaguar-xj',         (SELECT type_id FROM e01_200_01_tb WHERE type_uid='JaguarXJ'),'concept','جگوار XJ','Jaguar XJ',2),
('concept:jaguar-xf',         (SELECT type_id FROM e01_200_01_tb WHERE type_uid='JaguarXF'),'concept','جگوار XF','Jaguar XF',2),
('concept:jaguar-ftype',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='JaguarFType'),'concept','جگوار F-Type','Jaguar F-Type',2),
('concept:jaguar-fpace',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='JaguarFPace'),'concept','جگوار F-Pace','Jaguar F-Pace SUV',2),
('concept:jaguar-ipace',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='JaguarIPace'),'concept','جگوار I-Pace','Jaguar I-Pace EV',2),
-- لندروور
('concept:range-rover',       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='RangeRover'),'concept','رنجرور','Range Rover',2),
('concept:range-rover-sport', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='RangeRoverSport'),'concept','رنجرور اسپرت','Range Rover Sport',2),
('concept:range-rover-evoque',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='RangeRoverEvoque'),'concept','رنجرور ایووک','Range Rover Evoque',2),
('concept:discovery',         (SELECT type_id FROM e01_200_01_tb WHERE type_uid='LandRoverDiscovery'),'concept','لندروور دیسکاوری','Land Rover Discovery',2),
('concept:defender',          (SELECT type_id FROM e01_200_01_tb WHERE type_uid='LandRoverDefender'),'concept','لندروور دیفندر','Land Rover Defender',2),
-- مینی
('concept:mini-cooper',       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='MiniCooper'),'concept','مینی کوپر','MINI Cooper',2),
('concept:mini-countryman',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='MiniCountryman'),'concept','مینی کانتری‌من','MINI Countryman SUV',2),
-- لوتوس
('concept:lotus-emira',       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='LotusEmira'),'concept','لوتوس امیرا','Lotus Emira',2),
('concept:lotus-evija',       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='LotusEvija'),'concept','لوتوس اویجا','Lotus Evija EV',2),
-- مکلارن
('concept:mclaren-720s',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='McLaren720S'),'concept','مکلارن ۷۲۰S','McLaren 720S',2),
('concept:mclaren-artura',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='McLarenArtura'),'concept','مکلارن آرتورا','McLaren Artura Hybrid',2),
-- MG
('concept:mg-mg4',            (SELECT type_id FROM e01_200_01_tb WHERE type_uid='MGMG4'),'concept','MG 4','MG 4 EV',2),
('concept:mg-zs',             (SELECT type_id FROM e01_200_01_tb WHERE type_uid='MGZS'),'concept','MG ZS','MG ZS SUV',2),
('concept:mg-hs',             (SELECT type_id FROM e01_200_01_tb WHERE type_uid='MGHS'),'concept','MG HS','MG HS SUV',2);

-- =====================================================================
-- ۴. is_a
-- =====================================================================
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || REPLACE(p.sub_uid, ':', '-') || '-is-a',
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.sub_uid),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:passenger-car'),
  'asserted', 2
FROM (
  SELECT 'concept:bentley-continental' AS sub_uid UNION ALL
  SELECT 'concept:bentley-flying-spur' UNION ALL
  SELECT 'concept:bentley-bentayga' UNION ALL
  SELECT 'concept:rr-phantom' UNION ALL
  SELECT 'concept:rr-ghost' UNION ALL
  SELECT 'concept:rr-cullinan' UNION ALL
  SELECT 'concept:aston-db11' UNION ALL
  SELECT 'concept:aston-vantage' UNION ALL
  SELECT 'concept:aston-dbx' UNION ALL
  SELECT 'concept:jaguar-xj' UNION ALL
  SELECT 'concept:jaguar-xf' UNION ALL
  SELECT 'concept:jaguar-ftype' UNION ALL
  SELECT 'concept:jaguar-fpace' UNION ALL
  SELECT 'concept:jaguar-ipace' UNION ALL
  SELECT 'concept:range-rover' UNION ALL
  SELECT 'concept:range-rover-sport' UNION ALL
  SELECT 'concept:range-rover-evoque' UNION ALL
  SELECT 'concept:discovery' UNION ALL
  SELECT 'concept:defender' UNION ALL
  SELECT 'concept:mini-cooper' UNION ALL
  SELECT 'concept:mini-countryman' UNION ALL
  SELECT 'concept:lotus-emira' UNION ALL
  SELECT 'concept:lotus-evija' UNION ALL
  SELECT 'concept:mclaren-720s' UNION ALL
  SELECT 'concept:mclaren-artura' UNION ALL
  SELECT 'concept:mg-mg4' UNION ALL
  SELECT 'concept:mg-zs' UNION ALL
  SELECT 'concept:mg-hs'
) p
WHERE NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.rel_uid = 'r:' || REPLACE(p.sub_uid, ':', '-') || '-is-a');

-- =====================================================================
-- ۵. manufactured_by
-- =====================================================================
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || REPLACE(p.product, ':', '-') || '-by-' || REPLACE(p.maker, ':', '-'),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='manufactured_by'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.product),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.maker),
  'asserted', 2
FROM (
  SELECT 'concept:bentley-continental' AS product, 'concept:bentley' AS maker UNION ALL
  SELECT 'concept:bentley-flying-spur',           'concept:bentley' UNION ALL
  SELECT 'concept:bentley-bentayga',              'concept:bentley' UNION ALL
  SELECT 'concept:rr-phantom',                    'concept:rolls-royce' UNION ALL
  SELECT 'concept:rr-ghost',                      'concept:rolls-royce' UNION ALL
  SELECT 'concept:rr-cullinan',                   'concept:rolls-royce' UNION ALL
  SELECT 'concept:aston-db11',                    'concept:aston-martin' UNION ALL
  SELECT 'concept:aston-vantage',                 'concept:aston-martin' UNION ALL
  SELECT 'concept:aston-dbx',                     'concept:aston-martin' UNION ALL
  SELECT 'concept:jaguar-xj',                     'concept:jaguar' UNION ALL
  SELECT 'concept:jaguar-xf',                     'concept:jaguar' UNION ALL
  SELECT 'concept:jaguar-ftype',                  'concept:jaguar' UNION ALL
  SELECT 'concept:jaguar-fpace',                  'concept:jaguar' UNION ALL
  SELECT 'concept:jaguar-ipace',                  'concept:jaguar' UNION ALL
  SELECT 'concept:range-rover',                   'concept:land-rover' UNION ALL
  SELECT 'concept:range-rover-sport',             'concept:land-rover' UNION ALL
  SELECT 'concept:range-rover-evoque',            'concept:land-rover' UNION ALL
  SELECT 'concept:discovery',                     'concept:land-rover' UNION ALL
  SELECT 'concept:defender',                      'concept:land-rover' UNION ALL
  SELECT 'concept:mini-cooper',                   'concept:mini' UNION ALL
  SELECT 'concept:mini-countryman',               'concept:mini' UNION ALL
  SELECT 'concept:lotus-emira',                   'concept:lotus' UNION ALL
  SELECT 'concept:lotus-evija',                   'concept:lotus' UNION ALL
  SELECT 'concept:mclaren-720s',                  'concept:mclaren' UNION ALL
  SELECT 'concept:mclaren-artura',                'concept:mclaren' UNION ALL
  SELECT 'concept:mg-mg4',                        'concept:mg' UNION ALL
  SELECT 'concept:mg-zs',                         'concept:mg' UNION ALL
  SELECT 'concept:mg-hs',                         'concept:mg'
) p
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.product)
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.maker)
  AND NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.rel_uid = 'r:' || REPLACE(p.product, ':', '-') || '-by-' || REPLACE(p.maker, ':', '-'));

-- =====================================================================
-- ۶. هلدینگ‌ها (JLR و Tata)
-- =====================================================================
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || REPLACE(p.sub_uid, ':', '-') || '-part-of-' || REPLACE(p.obj_uid, ':', '-'),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='part_of'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.sub_uid),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.obj_uid),
  'asserted', 2
FROM (
  SELECT 'concept:jaguar' AS sub_uid, 'concept:land-rover' AS obj_uid UNION ALL
  SELECT 'concept:mg', 'concept:saipa' /* فقط برای نمونه */
) p
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.sub_uid)
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.obj_uid)
  AND NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.rel_uid = 'r:' || REPLACE(p.sub_uid, ':', '-') || '-part-of-' || REPLACE(p.obj_uid, ':', '-'));

-- =====================================================================
-- ۷. لاگ
-- =====================================================================
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v67_british_cars','British cars: Bentley, Rolls-Royce, Aston Martin, Jaguar, Land Rover, MINI, Lotus, McLaren, MG');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- =====================================================================
-- گزارش
-- =====================================================================
SELECT 'entities' AS k, COUNT(*) AS n FROM e01_200_03_tb
UNION ALL SELECT 'relations', COUNT(*) FROM e01_222_01_tb;

SELECT '=== خودروهای انگلیسی ===' AS section;
SELECT 
  p.label AS model,
  m.label AS maker
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='manufactured_by'
JOIN e01_200_03_tb p ON p.ent_id = r.subj_ent_id
JOIN e01_200_03_tb m ON m.ent_id = r.obj_ent_id
WHERE m.ent_uid IN ('concept:bentley','concept:rolls-royce','concept:aston-martin',
                    'concept:jaguar','concept:land-rover','concept:mini',
                    'concept:lotus','concept:mclaren','concept:mg')
ORDER BY m.ent_uid, p.ent_uid;
