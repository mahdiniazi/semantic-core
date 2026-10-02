-- v64 — خودروهای فرانسوی: پژو، سیتروئن، رنو
.mode column
.headers on

BEGIN;

-- =====================================================================
-- ۱. انواع خودروی فرانسوی
-- =====================================================================
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract) VALUES
-- پژو
('Peugeot208',   'پژو ۲۰۸',      0),
('Peugeot301',   'پژو ۳۰۱',      0),
('Peugeot2008',  'پژو ۲۰۰۸',     0),
('Peugeot3008',  'پژو ۳۰۰۸',     0),
('Peugeot508',   'پژو ۵۰۸',      0),
-- سیتروئن
('CitroenC3',    'سیتروئن C3',   0),
('CitroenC4',    'سیتروئن C4',   0),
('CitroenC5',    'سیتروئن C5',   0),
('CitroenBerlingo','سیتروئن برلینگو',0),
-- رنو
('RenaultClio',  'رنو کلیو',      0),
('RenaultMegane','رنو مگان',      0),
('RenaultDuster','رنو داستر',     0),
('RenaultTalisman','رنو تالیسمان',0),
('RenaultCaptur','رنو کپچر',      0),
('RenaultSandero','رنو ساندرو',   0),
('RenaultKoleos','رنو کولیوس',    0);

UPDATE e01_200_01_tb 
SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='PassengerCar')
WHERE type_uid IN (
  'Peugeot208','Peugeot301','Peugeot2008','Peugeot3008','Peugeot508',
  'CitroenC3','CitroenC4','CitroenC5',
  'RenaultClio','RenaultMegane','RenaultDuster','RenaultTalisman','RenaultCaptur','RenaultSandero','RenaultKoleos'
);

UPDATE e01_200_01_tb 
SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='DeliveryVan')
WHERE type_uid = 'CitroenBerlingo';

-- =====================================================================
-- ۲. مفاهیم خودروهای فرانسوی
-- =====================================================================
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
-- پژو
('concept:peugeot-208',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Peugeot208'),'concept','پژو ۲۰۸','Peugeot 208',2),
('concept:peugeot-301',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Peugeot301'),'concept','پژو ۳۰۱','Peugeot 301',2),
('concept:peugeot-2008', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Peugeot2008'),'concept','پژو ۲۰۰۸','Peugeot 2008 SUV',2),
('concept:peugeot-3008', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Peugeot3008'),'concept','پژو ۳۰۰۸','Peugeot 3008 SUV',2),
('concept:peugeot-508',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Peugeot508'),'concept','پژو ۵۰۸','Peugeot 508',2),
-- سیتروئن
('concept:citroen-c3',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='CitroenC3'),'concept','سیتروئن C3','Citroën C3',2),
('concept:citroen-c4',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='CitroenC4'),'concept','سیتروئن C4','Citroën C4',2),
('concept:citroen-c5',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='CitroenC5'),'concept','سیتروئن C5','Citroën C5',2),
('concept:citroen-berlingo',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='CitroenBerlingo'),'concept','سیتروئن برلینگو','Citroën Berlingo Van',2),
-- رنو
('concept:renault-clio',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='RenaultClio'),'concept','رنو کلیو','Renault Clio',2),
('concept:renault-megane', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='RenaultMegane'),'concept','رنو مگان','Renault Megane',2),
('concept:renault-duster', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='RenaultDuster'),'concept','رنو داستر','Renault Duster SUV',2),
('concept:renault-talisman',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='RenaultTalisman'),'concept','رنو تالیسمان','Renault Talisman',2),
('concept:renault-captur', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='RenaultCaptur'),'concept','رنو کپچر','Renault Captur SUV',2),
('concept:renault-sandero',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='RenaultSandero'),'concept','رنو ساندرو','Renault Sandero',2),
('concept:renault-koleos', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='RenaultKoleos'),'concept','رنو کولیوس','Renault Koleos SUV',2);

-- =====================================================================
-- ۳. is_a
-- =====================================================================
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || REPLACE(p.sub_uid, ':', '-') || '-is-a',
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.sub_uid),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.obj_uid),
  'asserted', 2
FROM (
  SELECT 'concept:peugeot-208' AS sub_uid, 'concept:passenger-car' AS obj_uid UNION ALL
  SELECT 'concept:peugeot-301', 'concept:passenger-car' UNION ALL
  SELECT 'concept:peugeot-2008', 'concept:passenger-car' UNION ALL
  SELECT 'concept:peugeot-3008', 'concept:passenger-car' UNION ALL
  SELECT 'concept:peugeot-508', 'concept:passenger-car' UNION ALL
  SELECT 'concept:citroen-c3', 'concept:passenger-car' UNION ALL
  SELECT 'concept:citroen-c4', 'concept:passenger-car' UNION ALL
  SELECT 'concept:citroen-c5', 'concept:passenger-car' UNION ALL
  SELECT 'concept:citroen-berlingo', 'concept:delivery-van' UNION ALL
  SELECT 'concept:renault-clio', 'concept:passenger-car' UNION ALL
  SELECT 'concept:renault-megane', 'concept:passenger-car' UNION ALL
  SELECT 'concept:renault-duster', 'concept:passenger-car' UNION ALL
  SELECT 'concept:renault-talisman', 'concept:passenger-car' UNION ALL
  SELECT 'concept:renault-captur', 'concept:passenger-car' UNION ALL
  SELECT 'concept:renault-sandero', 'concept:passenger-car' UNION ALL
  SELECT 'concept:renault-koleos', 'concept:passenger-car'
) p
WHERE NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.rel_uid = 'r:' || REPLACE(p.sub_uid, ':', '-') || '-is-a');

-- =====================================================================
-- ۴. manufactured_by
-- =====================================================================
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || REPLACE(p.product, ':', '-') || '-by-' || REPLACE(p.maker, ':', '-'),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='manufactured_by'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.product),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.maker),
  'asserted', 2
FROM (
  SELECT 'concept:peugeot-208' AS product, 'concept:peugeot' AS maker UNION ALL
  SELECT 'concept:peugeot-301',              'concept:peugeot' UNION ALL
  SELECT 'concept:peugeot-2008',             'concept:peugeot' UNION ALL
  SELECT 'concept:peugeot-3008',             'concept:peugeot' UNION ALL
  SELECT 'concept:peugeot-508',              'concept:peugeot' UNION ALL
  SELECT 'concept:citroen-c3',               'concept:citroen' UNION ALL
  SELECT 'concept:citroen-c4',               'concept:citroen' UNION ALL
  SELECT 'concept:citroen-c5',               'concept:citroen' UNION ALL
  SELECT 'concept:citroen-berlingo',         'concept:citroen' UNION ALL
  SELECT 'concept:renault-clio',             'concept:renault' UNION ALL
  SELECT 'concept:renault-megane',           'concept:renault' UNION ALL
  SELECT 'concept:renault-duster',           'concept:renault' UNION ALL
  SELECT 'concept:renault-talisman',         'concept:renault' UNION ALL
  SELECT 'concept:renault-captur',           'concept:renault' UNION ALL
  SELECT 'concept:renault-sandero',          'concept:renault' UNION ALL
  SELECT 'concept:renault-koleos',           'concept:renault'
) p
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.product)
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.maker)
  AND NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.rel_uid = 'r:' || REPLACE(p.product, ':', '-') || '-by-' || REPLACE(p.maker, ':', '-'));

-- =====================================================================
-- ۵. لاگ
-- =====================================================================
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v64_french_cars','French cars: Peugeot (5 more), Citroën (4), Renault (7)');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- =====================================================================
-- گزارش
-- =====================================================================
SELECT 'entities' AS k, COUNT(*) AS n FROM e01_200_03_tb
UNION ALL SELECT 'relations', COUNT(*) FROM e01_222_01_tb;

SELECT '=== خودروهای فرانسوی ===' AS section;
SELECT 
  p.label AS model,
  m.label AS maker
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='manufactured_by'
JOIN e01_200_03_tb p ON p.ent_id = r.subj_ent_id
JOIN e01_200_03_tb m ON m.ent_id = r.obj_ent_id
WHERE m.ent_uid IN ('concept:peugeot','concept:citroen','concept:renault')
ORDER BY m.ent_uid, p.ent_uid;
