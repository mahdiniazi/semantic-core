-- v57 — خودروهای آمریکایی
.mode column
.headers on

BEGIN;

INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract) VALUES
('ChevroletCruze', 'شورولت کروز',     0),
('ChevroletMalibu','شورولت مالیبو',   0),
('FordFocus',      'فورد فوکوس',      0),
('FordMustang',    'فورد موستانگ',    0),
('FordF150',       'فورد F-150',      0);

UPDATE e01_200_01_tb 
SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='PassengerCar')
WHERE type_uid IN ('ChevroletCruze','ChevroletMalibu','FordFocus','FordMustang','FordF150');

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('concept:chevrolet-cruze',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='ChevroletCruze'),'concept','شورولت کروز','Chevrolet Cruze',2),
('concept:chevrolet-malibu',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='ChevroletMalibu'),'concept','شورولت مالیبو','Chevrolet Malibu',2),
('concept:ford-focus',        (SELECT type_id FROM e01_200_01_tb WHERE type_uid='FordFocus'),'concept','فورد فوکوس','Ford Focus',2),
('concept:ford-mustang',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='FordMustang'),'concept','فورد موستانگ','Ford Mustang',2),
('concept:ford-f150',         (SELECT type_id FROM e01_200_01_tb WHERE type_uid='FordF150'),'concept','فورد F-150','Ford F-150 Truck',2);

-- is_a
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || REPLACE(p.sub_uid, ':', '-') || '-is-a',
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.sub_uid),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:passenger-car'),
  'asserted', 2
FROM (
  SELECT 'concept:chevrolet-cruze' AS sub_uid UNION ALL
  SELECT 'concept:chevrolet-malibu' UNION ALL
  SELECT 'concept:ford-focus' UNION ALL
  SELECT 'concept:ford-mustang' UNION ALL
  SELECT 'concept:ford-f150'
) p
WHERE NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.rel_uid = 'r:' || REPLACE(p.sub_uid, ':', '-') || '-is-a');

-- manufactured_by
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || REPLACE(p.product, ':', '-') || '-by-' || REPLACE(p.maker, ':', '-'),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='manufactured_by'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.product),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.maker),
  'asserted', 2
FROM (
  SELECT 'concept:chevrolet-cruze' AS product, 'concept:chevrolet' AS maker UNION ALL
  SELECT 'concept:chevrolet-malibu',           'concept:chevrolet' UNION ALL
  SELECT 'concept:ford-focus',                 'concept:ford' UNION ALL
  SELECT 'concept:ford-mustang',               'concept:ford' UNION ALL
  SELECT 'concept:ford-f150',                  'concept:ford'
) p
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.product)
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.maker)
  AND NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.rel_uid = 'r:' || REPLACE(p.product, ':', '-') || '-by-' || REPLACE(p.maker, ':', '-'));

INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v57_american_cars','American cars: Chevrolet (2), Ford (3)');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

SELECT 'entities' AS k, COUNT(*) AS n FROM e01_200_03_tb
UNION ALL SELECT 'relations', COUNT(*) FROM e01_222_01_tb;

SELECT '=== خودروهای آمریکایی ===' AS section;
SELECT 
  p.label AS model,
  m.label AS maker
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='manufactured_by'
JOIN e01_200_03_tb p ON p.ent_id = r.subj_ent_id
JOIN e01_200_03_tb m ON m.ent_id = r.obj_ent_id
WHERE m.ent_uid IN ('concept:chevrolet','concept:ford')
ORDER BY m.ent_uid, p.ent_uid;
