-- v66 — خودروهای ایتالیایی
.mode column
.headers on

BEGIN;

-- =====================================================================
-- ۱. انواع خودروی ایتالیایی
-- =====================================================================
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract) VALUES
-- فیات
('Fiat500',        'فیات ۵۰۰',       0),
('FiatPanda',      'فیات پاندا',     0),
('FiatTipo',       'فیات تیپو',      0),
('FiatDucato2',    'فیات دوکاتو (ون)',0),
('Fiat124Spider',  'فیات ۱۲۴',       0),
-- آلفارومئو
('AlfaGiulietta',  'آلفارومئو جولیتا',0),
('AlfaGiulia',     'آلفارومئو جولیا', 0),
('AlfaStelvio',    'آلفارومئو استلویو',0),
('AlfaTonale',     'آلفارومئو توناله',0),
-- فراری
('Ferrari488',     'فراری ۴۸۸',       0),
('FerrariF8',      'فراری F8',        0),
('FerrariRoma',    'فراری روما',      0),
('FerrariPortofino','فراری پورتوفینو',0),
-- لامبورگینی
('LamborghiniHuracan','لامبورگینی هوراکان',0),
('LamborghiniUrus',   'لامبورگینی اوروس',   0),
('LamborghiniRevuelto','لامبورگینی روولتو', 0),
-- مازراتی
('MaseratiGhibli',  'مازراتی گیبلی',   0),
('MaseratiLevante', 'مازراتی لوانته',  0),
('MaseratiGrecale', 'مازراتی گرکاله',  0),
('MaseratiQuattroporte','مازراتی کواتروپورته',0),
-- لانچیا
('LanciaYpsilon',   'لانچیا ایپسیلون', 0),
('LanciaDelta',     'لانچیا دلتا',     0);

UPDATE e01_200_01_tb 
SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='PassengerCar')
WHERE type_uid IN (
  'Fiat500','FiatPanda','FiatTipo','Fiat124Spider',
  'AlfaGiulietta','AlfaGiulia','AlfaStelvio','AlfaTonale',
  'Ferrari488','FerrariF8','FerrariRoma','FerrariPortofino',
  'LamborghiniHuracan','LamborghiniUrus','LamborghiniRevuelto',
  'MaseratiGhibli','MaseratiLevante','MaseratiGrecale','MaseratiQuattroporte',
  'LanciaYpsilon','LanciaDelta'
);

UPDATE e01_200_01_tb 
SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='DeliveryVan')
WHERE type_uid = 'FiatDucato2';

-- =====================================================================
-- ۲. سازندگان ایتالیایی
-- =====================================================================
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract) VALUES
('ItalianManufacturer', 'سازنده ایتالیایی', 1);

UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Manufacturer')
  WHERE type_uid = 'ItalianManufacturer';

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('concept:fiat',        (SELECT type_id FROM e01_200_01_tb WHERE type_uid='ItalianManufacturer'),'concept','فیات','Fiat',2),
('concept:alfa-romeo',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='ItalianManufacturer'),'concept','آلفارومئو','Alfa Romeo',2),
('concept:ferrari',     (SELECT type_id FROM e01_200_01_tb WHERE type_uid='ItalianManufacturer'),'concept','فراری','Ferrari',2),
('concept:lamborghini', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='ItalianManufacturer'),'concept','لامبورگینی','Lamborghini',2),
('concept:maserati',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='ItalianManufacturer'),'concept','مازراتی','Maserati',2),
('concept:lancia',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='ItalianManufacturer'),'concept','لانچیا','Lancia',2),
('concept:abarth',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='ItalianManufacturer'),'concept','آبارث','Abarth',2),
('concept:pagani',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='ItalianManufacturer'),'concept','پاگانی','Pagani',2);

-- =====================================================================
-- ۳. مفاهیم خودروها
-- =====================================================================
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
-- فیات
('concept:fiat-500',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Fiat500'),'concept','فیات ۵۰۰','Fiat 500',2),
('concept:fiat-panda',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='FiatPanda'),'concept','فیات پاندا','Fiat Panda',2),
('concept:fiat-tipo',     (SELECT type_id FROM e01_200_01_tb WHERE type_uid='FiatTipo'),'concept','فیات تیپو','Fiat Tipo',2),
('concept:fiat-124',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Fiat124Spider'),'concept','فیات ۱۲۴','Fiat 124 Spider',2),
-- آلفارومئو
('concept:alfa-giulietta',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='AlfaGiulietta'),'concept','آلفارومئو جولیتا','Alfa Romeo Giulietta',2),
('concept:alfa-giulia',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='AlfaGiulia'),'concept','آلفارومئو جولیا','Alfa Romeo Giulia',2),
('concept:alfa-stelvio',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='AlfaStelvio'),'concept','آلفارومئو استلویو','Alfa Romeo Stelvio SUV',2),
('concept:alfa-tonale',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='AlfaTonale'),'concept','آلفارومئو توناله','Alfa Romeo Tonale SUV',2),
-- فراری
('concept:ferrari-488',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Ferrari488'),'concept','فراری ۴۸۸','Ferrari 488',2),
('concept:ferrari-f8',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='FerrariF8'),'concept','فراری F8','Ferrari F8 Tributo',2),
('concept:ferrari-roma',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='FerrariRoma'),'concept','فراری روما','Ferrari Roma',2),
('concept:ferrari-portofino',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='FerrariPortofino'),'concept','فراری پورتوفینو','Ferrari Portofino',2),
-- لامبورگینی
('concept:lambo-huracan', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='LamborghiniHuracan'),'concept','لامبورگینی هوراکان','Lamborghini Huracán',2),
('concept:lambo-urus',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='LamborghiniUrus'),'concept','لامبورگینی اوروس','Lamborghini Urus SUV',2),
('concept:lambo-revuelto',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='LamborghiniRevuelto'),'concept','لامبورگینی روولتو','Lamborghini Revuelto',2),
-- مازراتی
('concept:maserati-ghibli',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='MaseratiGhibli'),'concept','مازراتی گیبلی','Maserati Ghibli',2),
('concept:maserati-levante',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='MaseratiLevante'),'concept','مازراتی لوانته','Maserati Levante SUV',2),
('concept:maserati-grecale',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='MaseratiGrecale'),'concept','مازراتی گرکاله','Maserati Grecale SUV',2),
('concept:maserati-qp',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='MaseratiQuattroporte'),'concept','مازراتی کواتروپورته','Maserati Quattroporte',2),
-- لانچیا
('concept:lancia-ypsilon',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='LanciaYpsilon'),'concept','لانچیا ایپسیلون','Lancia Ypsilon',2),
('concept:lancia-delta',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='LanciaDelta'),'concept','لانچیا دلتا','Lancia Delta',2);

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
  SELECT 'concept:fiat-500' AS sub_uid UNION ALL
  SELECT 'concept:fiat-panda' UNION ALL
  SELECT 'concept:fiat-tipo' UNION ALL
  SELECT 'concept:fiat-124' UNION ALL
  SELECT 'concept:alfa-giulietta' UNION ALL
  SELECT 'concept:alfa-giulia' UNION ALL
  SELECT 'concept:alfa-stelvio' UNION ALL
  SELECT 'concept:alfa-tonale' UNION ALL
  SELECT 'concept:ferrari-488' UNION ALL
  SELECT 'concept:ferrari-f8' UNION ALL
  SELECT 'concept:ferrari-roma' UNION ALL
  SELECT 'concept:ferrari-portofino' UNION ALL
  SELECT 'concept:lambo-huracan' UNION ALL
  SELECT 'concept:lambo-urus' UNION ALL
  SELECT 'concept:lambo-revuelto' UNION ALL
  SELECT 'concept:maserati-ghibli' UNION ALL
  SELECT 'concept:maserati-levante' UNION ALL
  SELECT 'concept:maserati-grecale' UNION ALL
  SELECT 'concept:maserati-qp' UNION ALL
  SELECT 'concept:lancia-ypsilon' UNION ALL
  SELECT 'concept:lancia-delta'
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
  SELECT 'concept:fiat-500' AS product, 'concept:fiat' AS maker UNION ALL
  SELECT 'concept:fiat-panda',              'concept:fiat' UNION ALL
  SELECT 'concept:fiat-tipo',               'concept:fiat' UNION ALL
  SELECT 'concept:fiat-124',                'concept:fiat' UNION ALL
  SELECT 'concept:alfa-giulietta',          'concept:alfa-romeo' UNION ALL
  SELECT 'concept:alfa-giulia',             'concept:alfa-romeo' UNION ALL
  SELECT 'concept:alfa-stelvio',            'concept:alfa-romeo' UNION ALL
  SELECT 'concept:alfa-tonale',             'concept:alfa-romeo' UNION ALL
  SELECT 'concept:ferrari-488',             'concept:ferrari' UNION ALL
  SELECT 'concept:ferrari-f8',              'concept:ferrari' UNION ALL
  SELECT 'concept:ferrari-roma',            'concept:ferrari' UNION ALL
  SELECT 'concept:ferrari-portofino',       'concept:ferrari' UNION ALL
  SELECT 'concept:lambo-huracan',           'concept:lamborghini' UNION ALL
  SELECT 'concept:lambo-urus',              'concept:lamborghini' UNION ALL
  SELECT 'concept:lambo-revuelto',          'concept:lamborghini' UNION ALL
  SELECT 'concept:maserati-ghibli',         'concept:maserati' UNION ALL
  SELECT 'concept:maserati-levante',        'concept:maserati' UNION ALL
  SELECT 'concept:maserati-grecale',        'concept:maserati' UNION ALL
  SELECT 'concept:maserati-qp',             'concept:maserati' UNION ALL
  SELECT 'concept:lancia-ypsilon',          'concept:lancia' UNION ALL
  SELECT 'concept:lancia-delta',            'concept:lancia'
) p
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.product)
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.maker)
  AND NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.rel_uid = 'r:' || REPLACE(p.product, ':', '-') || '-by-' || REPLACE(p.maker, ':', '-'));

-- =====================================================================
-- ۶. گروه FIAT (Stellantis) — برندهای زیرمجموعه
-- =====================================================================
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || REPLACE(p.sub_uid, ':', '-') || '-part-of-' || REPLACE(p.obj_uid, ':', '-'),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='part_of'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.sub_uid),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.obj_uid),
  'asserted', 2
FROM (
  SELECT 'concept:ferrari' AS sub_uid, 'concept:fiat' AS obj_uid UNION ALL
  SELECT 'concept:maserati', 'concept:fiat' UNION ALL
  SELECT 'concept:alfa-romeo', 'concept:fiat' UNION ALL
  SELECT 'concept:lancia', 'concept:fiat'
) p
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.sub_uid)
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.obj_uid)
  AND NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.rel_uid = 'r:' || REPLACE(p.sub_uid, ':', '-') || '-part-of-' || REPLACE(p.obj_uid, ':', '-'));

-- =====================================================================
-- ۷. لاگ
-- =====================================================================
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v66_italian_cars','Italian cars: Fiat, Alfa Romeo, Ferrari, Lamborghini, Maserati, Lancia');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- =====================================================================
-- گزارش
-- =====================================================================
SELECT 'entities' AS k, COUNT(*) AS n FROM e01_200_03_tb
UNION ALL SELECT 'relations', COUNT(*) FROM e01_222_01_tb;

SELECT '=== خودروهای ایتالیایی ===' AS section;
SELECT 
  p.label AS model,
  m.label AS maker
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='manufactured_by'
JOIN e01_200_03_tb p ON p.ent_id = r.subj_ent_id
JOIN e01_200_03_tb m ON m.ent_id = r.obj_ent_id
WHERE m.ent_uid IN ('concept:fiat','concept:alfa-romeo','concept:ferrari',
                    'concept:lamborghini','concept:maserati','concept:lancia')
ORDER BY m.ent_uid, p.ent_uid;
