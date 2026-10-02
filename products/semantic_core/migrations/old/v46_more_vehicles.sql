-- v46 — گسترش افقی: پژو ۴۰۵، سمند، تیبا، کوییک، شاهین
.mode column
.headers on

BEGIN;

-- =====================================================================
-- ۱. انواع جدید
-- =====================================================================
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract) VALUES
('Peugeot405','پژو ۴۰۵',0),
('Samand','سمند',0),
('Tiba','تیبا',0),
('Quick','کوییک',0),
('Shahin','شاهین',0);

UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='PassengerCar')
  WHERE type_uid IN ('Peugeot405','Samand','Tiba','Quick','Shahin');

-- =====================================================================
-- ۲. مفهوم‌های خودرویی
-- =====================================================================
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('concept:405',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Peugeot405'),'concept','پژو ۴۰۵','مفهوم پژو ۴۰۵',2),
('concept:samand', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Samand'),'concept','سمند','مفهوم سمند',2),
('concept:tiba',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Tiba'),'concept','تیبا','مفهوم تیبا',2),
('concept:quick',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Quick'),'concept','کوییک','مفهوم کوییک',2),
('concept:shahin', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Shahin'),'concept','شاهین','مفهوم شاهین',2);

-- =====================================================================
-- ۳. زنجیره is_a: هر مفهوم زیر concept:passenger-car
-- =====================================================================
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || REPLACE(p.sub_uid, ':', '-') || '-is-a',
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.sub_uid),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.obj_uid),
  'asserted', 2
FROM (
  SELECT 'concept:405' AS sub_uid, 'concept:passenger-car' AS obj_uid UNION ALL
  SELECT 'concept:samand', 'concept:passenger-car' UNION ALL
  SELECT 'concept:tiba', 'concept:passenger-car' UNION ALL
  SELECT 'concept:quick', 'concept:passenger-car' UNION ALL
  SELECT 'concept:shahin', 'concept:passenger-car'
) p
WHERE NOT EXISTS (
  SELECT 1 FROM e01_222_01_tb r
  WHERE r.rel_uid = 'r:' || REPLACE(p.sub_uid, ':', '-') || '-is-a'
);

-- =====================================================================
-- ۴. نمونه‌های خودرو (instance)
-- =====================================================================
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('vehicle:405-1',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Peugeot405'),'instance','پژو ۴۰۵ نمونه','پژو ۴۰۵ — موتور ۱.۸ لیتر',2),
('vehicle:samand-1', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Samand'),'instance','سمند نمونه','سمند — موتور ۱.۸ لیتر',2),
('vehicle:tiba-1',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Tiba'),'instance','تیبا نمونه','تیبا — موتور ۱.۵ لیتر',2),
('vehicle:quick-1',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Quick'),'instance','کوییک نمونه','کوییک — موتور ۱.۵ لیتر',2),
('vehicle:shahin-1', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Shahin'),'instance','شاهین نمونه','شاهین — موتور ۱.۵ توربو',2);

-- =====================================================================
-- ۵. اتصال نمونه به مفهوم (instance_of)
-- =====================================================================
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || REPLACE(v.ent_uid, ':', '-') || '-instance-of',
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='instance_of'),
  v.ent_id,
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid =
    CASE 
      WHEN v.ent_uid='vehicle:405-1'    THEN 'concept:405'
      WHEN v.ent_uid='vehicle:samand-1' THEN 'concept:samand'
      WHEN v.ent_uid='vehicle:tiba-1'   THEN 'concept:tiba'
      WHEN v.ent_uid='vehicle:quick-1'  THEN 'concept:quick'
      WHEN v.ent_uid='vehicle:shahin-1' THEN 'concept:shahin'
    END),
  'asserted', 2
FROM e01_200_03_tb v
WHERE v.ent_uid IN ('vehicle:405-1','vehicle:samand-1','vehicle:tiba-1','vehicle:quick-1','vehicle:shahin-1')
AND NOT EXISTS (
  SELECT 1 FROM e01_222_01_tb r 
  WHERE r.rel_uid = 'r:' || REPLACE(v.ent_uid, ':', '-') || '-instance-of'
);

-- =====================================================================
-- ۶. لاگ
-- =====================================================================
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v46_more_vehicles','Horizontal expansion: 405, Samand, Tiba, Quick, Shahin');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- =====================================================================
-- گزارش
-- =====================================================================
SELECT 'entities' AS k, COUNT(*) AS n FROM e01_200_03_tb
UNION ALL SELECT 'relations', COUNT(*) FROM e01_222_01_tb
UNION ALL SELECT 'vehicle_concepts', COUNT(*) FROM e01_200_03_tb WHERE ent_uid LIKE 'concept:%' AND ent_uid NOT LIKE 'concept:battery%' AND ent_uid NOT LIKE 'concept:ac%' AND ent_uid NOT LIKE 'concept:brake%' AND ent_uid NOT LIKE 'concept:steering%' AND ent_uid NOT LIKE 'concept:coil%' AND ent_uid NOT LIKE 'concept:shock%' AND ent_uid NOT LIKE 'concept:ball%' AND ent_uid NOT LIKE 'concept:bushing%' AND ent_uid NOT LIKE 'concept:control%' AND ent_uid NOT LIKE 'concept:power%' AND ent_uid NOT LIKE 'concept:tie%' AND ent_uid NOT LIKE 'concept:cabin%' AND ent_uid NOT LIKE 'concept:heater%' AND ent_uid NOT LIKE 'concept:blower%';

SELECT '=== ۹ خودروی ایرانی ===' AS section;
SELECT 
  v.ent_uid AS vehicle_instance,
  obj.ent_uid AS concept,
  obj.label AS concept_label
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='instance_of'
JOIN e01_200_03_tb v ON v.ent_id = r.subj_ent_id
JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
WHERE v.ent_uid LIKE 'vehicle:%'
ORDER BY v.ent_uid;
