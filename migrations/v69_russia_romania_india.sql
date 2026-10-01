-- v69 — لادا (روسیه)، داچیا (رومانی)، تاتا و ماهیندرا (هند)
.mode column
.headers on

BEGIN;

-- =====================================================================
-- ۱. انواع خودروی جدید
-- =====================================================================
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract) VALUES
-- لادا
('LadaNiva',      'لادا نیوا',       0),
('LadaVesta',     'لادا وستا',       0),
('LadaGranta',    'لادا گرانتا',     0),
('LadaKalina',    'لادا کالینا',     0),
('LadaLargus',    'لادا لارگوس',     0),
('LadaXRAY',      'لادا ایکس‌ری',    0),
-- داچیا
('DaciaDuster',   'داچیا داستر',     0),
('DaciaSandero',  'داچیا ساندرو',    0),
('DaciaLogan',    'داچیا لوگان',     0),
('DaciaJogger',   'داچیا جاگر',      0),
('DaciaSpring',   'داچیا اسپرینگ',   0),
-- تاتا
('TataNano',      'تاتا نانو',       0),
('TataIndica',    'تاتا ایندیکا',    0),
('TataSafari',    'تاتا سافاری',     0),
('TataNexon',     'تاتا نکسون',      0),
('TataHarrier',   'تاتا هریِر',      0),
-- ماهیندرا
('MahindraThar',  'ماهیندرا تار',    0),
('MahindraScorpio','ماهیندرا اسکورپیو',0),
('MahindraXUV700','ماهیندرا XUV700',0);

UPDATE e01_200_01_tb 
SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='PassengerCar')
WHERE type_uid IN (
  'LadaNiva','LadaVesta','LadaGranta','LadaKalina','LadaXRAY',
  'DaciaDuster','DaciaSandero','DaciaLogan','DaciaJogger','DaciaSpring',
  'TataNano','TataIndica','TataSafari','TataNexon','TataHarrier',
  'MahindraThar','MahindraScorpio','MahindraXUV700'
);

UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='DeliveryVan')
  WHERE type_uid = 'LadaLargus';

-- =====================================================================
-- ۲. سازندگان
-- =====================================================================
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract) VALUES
('RussianManufacturer', 'سازنده روسی', 1),
('RomanianManufacturer','سازنده رومانیایی',1),
('IndianManufacturer',  'سازنده هندی', 1);

UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Manufacturer')
  WHERE type_uid IN ('RussianManufacturer','RomanianManufacturer','IndianManufacturer');

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('concept:lada',     (SELECT type_id FROM e01_200_01_tb WHERE type_uid='RussianManufacturer'),'concept','لادا','Lada (AvtoVAZ)',2),
('concept:dacia',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='RomanianManufacturer'),'concept','داچیا','Dacia',2),
('concept:tata',     (SELECT type_id FROM e01_200_01_tb WHERE type_uid='IndianManufacturer'),'concept','تاتا','Tata Motors',2),
('concept:mahindra', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='IndianManufacturer'),'concept','ماهیندرا','Mahindra & Mahindra',2);

-- =====================================================================
-- ۳. مفاهیم خودروها
-- =====================================================================
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
-- لادا
('concept:lada-niva',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='LadaNiva'),'concept','لادا نیوا','Lada Niva SUV',2),
('concept:lada-vesta',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='LadaVesta'),'concept','لادا وستا','Lada Vesta',2),
('concept:lada-granta',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='LadaGranta'),'concept','لادا گرانتا','Lada Granta',2),
('concept:lada-kalina',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='LadaKalina'),'concept','لادا کالینا','Lada Kalina',2),
('concept:lada-largus',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='LadaLargus'),'concept','لادا لارگوس','Lada Largus Van',2),
('concept:lada-xray',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='LadaXRAY'),'concept','لادا ایکس‌ری','Lada XRAY SUV',2),
-- داچیا
('concept:dacia-duster', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='DaciaDuster'),'concept','داچیا داستر','Dacia Duster SUV',2),
('concept:dacia-sandero',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='DaciaSandero'),'concept','داچیا ساندرو','Dacia Sandero',2),
('concept:dacia-logan',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='DaciaLogan'),'concept','داچیا لوگان','Dacia Logan',2),
('concept:dacia-jogger', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='DaciaJogger'),'concept','داچیا جاگر','Dacia Jogger',2),
('concept:dacia-spring', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='DaciaSpring'),'concept','داچیا اسپرینگ','Dacia Spring EV',2),
-- تاتا
('concept:tata-nano',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='TataNano'),'concept','تاتا نانو','Tata Nano',2),
('concept:tata-indica',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='TataIndica'),'concept','تاتا ایندیکا','Tata Indica',2),
('concept:tata-safari',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='TataSafari'),'concept','تاتا سافاری','Tata Safari SUV',2),
('concept:tata-nexon',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='TataNexon'),'concept','تاتا نکسون','Tata Nexon SUV',2),
('concept:tata-harrier', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='TataHarrier'),'concept','تاتا هریِر','Tata Harrier SUV',2),
-- ماهیندرا
('concept:mahindra-thar',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='MahindraThar'),'concept','ماهیندرا تار','Mahindra Thar SUV',2),
('concept:mahindra-scorpio',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='MahindraScorpio'),'concept','ماهیندرا اسکورپیو','Mahindra Scorpio SUV',2),
('concept:mahindra-xuv700', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='MahindraXUV700'),'concept','ماهیندرا XUV700','Mahindra XUV700 SUV',2);

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
  SELECT 'concept:lada-niva' AS sub_uid UNION ALL
  SELECT 'concept:lada-vesta' UNION ALL
  SELECT 'concept:lada-granta' UNION ALL
  SELECT 'concept:lada-kalina' UNION ALL
  SELECT 'concept:lada-xray' UNION ALL
  SELECT 'concept:dacia-duster' UNION ALL
  SELECT 'concept:dacia-sandero' UNION ALL
  SELECT 'concept:dacia-logan' UNION ALL
  SELECT 'concept:dacia-jogger' UNION ALL
  SELECT 'concept:dacia-spring' UNION ALL
  SELECT 'concept:tata-nano' UNION ALL
  SELECT 'concept:tata-indica' UNION ALL
  SELECT 'concept:tata-safari' UNION ALL
  SELECT 'concept:tata-nexon' UNION ALL
  SELECT 'concept:tata-harrier' UNION ALL
  SELECT 'concept:mahindra-thar' UNION ALL
  SELECT 'concept:mahindra-scorpio' UNION ALL
  SELECT 'concept:mahindra-xuv700'
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
  SELECT 'concept:lada-niva' AS product, 'concept:lada' AS maker UNION ALL
  SELECT 'concept:lada-vesta',              'concept:lada' UNION ALL
  SELECT 'concept:lada-granta',             'concept:lada' UNION ALL
  SELECT 'concept:lada-kalina',             'concept:lada' UNION ALL
  SELECT 'concept:lada-largus',             'concept:lada' UNION ALL
  SELECT 'concept:lada-xray',               'concept:lada' UNION ALL
  SELECT 'concept:dacia-duster',            'concept:dacia' UNION ALL
  SELECT 'concept:dacia-sandero',           'concept:dacia' UNION ALL
  SELECT 'concept:dacia-logan',             'concept:dacia' UNION ALL
  SELECT 'concept:dacia-jogger',            'concept:dacia' UNION ALL
  SELECT 'concept:dacia-spring',            'concept:dacia' UNION ALL
  SELECT 'concept:tata-nano',               'concept:tata' UNION ALL
  SELECT 'concept:tata-indica',             'concept:tata' UNION ALL
  SELECT 'concept:tata-safari',             'concept:tata' UNION ALL
  SELECT 'concept:tata-nexon',              'concept:tata' UNION ALL
  SELECT 'concept:tata-harrier',            'concept:tata' UNION ALL
  SELECT 'concept:mahindra-thar',           'concept:mahindra' UNION ALL
  SELECT 'concept:mahindra-scorpio',        'concept:mahindra' UNION ALL
  SELECT 'concept:mahindra-xuv700',         'concept:mahindra'
) p
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.product)
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.maker)
  AND NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.rel_uid = 'r:' || REPLACE(p.product, ':', '-') || '-by-' || REPLACE(p.maker, ':', '-'));

-- =====================================================================
-- ۶. هلدینگ‌ها (رنو-نیسان-داچیا، تاتا-جگوار-لندروور)
-- =====================================================================
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || REPLACE(p.sub_uid, ':', '-') || '-part-of-' || REPLACE(p.obj_uid, ':', '-'),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='part_of'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.sub_uid),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.obj_uid),
  'asserted', 2
FROM (
  -- داچیا زیر رنو (Renault Group)
  SELECT 'concept:dacia' AS sub_uid, 'concept:renault' AS obj_uid UNION ALL
  -- جگوار و لندروور زیر تاتا (JLR)
  SELECT 'concept:jaguar', 'concept:tata' UNION ALL
  SELECT 'concept:land-rover', 'concept:tata'
) p
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.sub_uid)
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.obj_uid)
  AND NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.rel_uid = 'r:' || REPLACE(p.sub_uid, ':', '-') || '-part-of-' || REPLACE(p.obj_uid, ':', '-'));

-- =====================================================================
-- ۷. لاگ
-- =====================================================================
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v69_russia_romania_india','Lada (6), Dacia (5), Tata (5), Mahindra (3) + Renault/Tata holdings');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- =====================================================================
-- گزارش
-- =====================================================================
SELECT 'entities' AS k, COUNT(*) AS n FROM e01_200_03_tb
UNION ALL SELECT 'relations', COUNT(*) FROM e01_222_01_tb;

SELECT '=== خودروهای روسی، رومانیایی، هندی ===' AS section;
SELECT 
  p.label AS model,
  m.label AS maker
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='manufactured_by'
JOIN e01_200_03_tb p ON p.ent_id = r.subj_ent_id
JOIN e01_200_03_tb m ON m.ent_id = r.obj_ent_id
WHERE m.ent_uid IN ('concept:lada','concept:dacia','concept:tata','concept:mahindra')
ORDER BY m.ent_uid, p.ent_uid;

SELECT '=== هلدینگ‌های جهانی ===' AS section;
SELECT 
  sub.label AS brand,
  obj.label AS parent_group
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='part_of'
JOIN e01_200_03_tb sub ON sub.ent_id = r.subj_ent_id
JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
ORDER BY obj.ent_uid, sub.ent_uid;
