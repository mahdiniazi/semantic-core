-- v40 — ساختار سطح کلاس: یک بار تعریف، برای همه
.mode column
.headers on

BEGIN;

-- ========== ۱. ساخت مفهوم‌ها (concept) برای هر قطعه ==========
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('concept:battery',           (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Battery'),            'concept','باتری',              'هر باتری خودرویی',           2),
('concept:alternator',        (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Alternator'),         'concept','دینام',              'هر دینام خودرویی',           2),
('concept:starter',           (SELECT type_id FROM e01_200_01_tb WHERE type_uid='StarterMotor'),       'concept','استارت',             'هر استارت خودرویی',          2),
('concept:engine-ecu',        (SELECT type_id FROM e01_200_01_tb WHERE type_uid='EngineECU'),          'concept','ECU موتور',           'هر ECU موتور',               2),
('concept:ignition-coil',     (SELECT type_id FROM e01_200_01_tb WHERE type_uid='IgnitionCoil'),       'concept','کوئل',               'هر کوئل جرقه',               2),
('concept:injector',          (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Injector'),           'concept','انژکتور',            'هر انژکتور بنزینی',          2),
('concept:o2-sensor',         (SELECT type_id FROM e01_200_01_tb WHERE type_uid='O2Sensor'),           'concept','سنسور اکسیژن',       'هر سنسور O2',                2),
('concept:maf-sensor',        (SELECT type_id FROM e01_200_01_tb WHERE type_uid='MassAirFlowSensor'),  'concept','سنسور دبی هوا',      'هر سنسور MAF',               2),
('concept:crankshaft-sensor', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='CrankshaftSensor'),   'concept','سنسور دور موتور',    'هر سنسور میل‌لنگ',           2),
('concept:coolant-sensor',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='CoolantTempSensor'),  'concept','سنسور دمای آب',      'هر سنسور دمای خنک‌کننده',    2),
('concept:relay',             (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Relay'),              'concept','رله',               'هر رله برقی',                2),
('concept:fuse',              (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Fuse'),               'concept','فیوز',              'هر فیوز برقی',               2),
('concept:can-bus',           (SELECT type_id FROM e01_200_01_tb WHERE type_uid='CANBus'),             'concept','شبکه CAN',          'هر شبکه CAN',                2);

-- ========== ۲. نوع رابطه has_part ==========
INSERT OR IGNORE INTO e01_202_01_tb (type_uid, label, description, object_kind, is_symmetric, is_transitive, is_functional, inverse_uid)
VALUES ('has_part','شامل','دارد بخشی از خود', 'entity', 0, 0, 0, 'part_of');

-- ========== ۳. قاعده چیزسازی ==========
INSERT OR IGNORE INTO e01_202_02_tb (reltype_id, reify_rule, category, reason)
SELECT reltype_id, 'never', 'structural', 'ساختار کلاس — بدون داده'
FROM e01_202_01_tb WHERE type_uid = 'has_part';

-- ========== ۴. رابطه part_of قدیمی را inverse کن ==========
UPDATE e01_202_01_tb SET inverse_uid = 'has_part' WHERE type_uid = 'part_of' AND inverse_uid IS NULL;

-- ========== ۵. ساختار سطح کلاس ==========
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:vehicle-has-' || REPLACE(p.obj_uid, 'concept:', ''),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_part'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid = 'Vehicle'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid = p.obj_uid),
  'asserted', 2
FROM (
  SELECT 'concept:battery' AS obj_uid UNION ALL
  SELECT 'concept:alternator' UNION ALL
  SELECT 'concept:starter' UNION ALL
  SELECT 'concept:relay' UNION ALL
  SELECT 'concept:fuse'
) p
WHERE NOT EXISTS (
  SELECT 1 FROM e01_222_01_tb r
  WHERE r.rel_uid = 'r:vehicle-has-' || REPLACE(p.obj_uid, 'concept:', '')
);

INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:passengercar-has-' || REPLACE(p.obj_uid, 'concept:', ''),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_part'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid = 'PassengerCar'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid = p.obj_uid),
  'asserted', 2
FROM (
  SELECT 'concept:engine-ecu' AS obj_uid UNION ALL
  SELECT 'concept:ignition-coil' UNION ALL
  SELECT 'concept:injector' UNION ALL
  SELECT 'concept:o2-sensor' UNION ALL
  SELECT 'concept:maf-sensor' UNION ALL
  SELECT 'concept:crankshaft-sensor' UNION ALL
  SELECT 'concept:coolant-sensor' UNION ALL
  SELECT 'concept:can-bus'
) p
WHERE NOT EXISTS (
  SELECT 1 FROM e01_222_01_tb r
  WHERE r.rel_uid = 'r:passengercar-has-' || REPLACE(p.obj_uid, 'concept:', '')
);

-- ========== ۶. خودروهای ایرانی زیر PassengerCar ==========
UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='PassengerCar')
  WHERE type_uid IN ('Pride','Peugeot206','Dena');

-- ========== لاگ ==========
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v40_class_template','Class-level structure: 13 concepts, 13 has_part relations');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- ========== گزارش ==========
SELECT 'entities' AS k, COUNT(*) AS n FROM e01_200_03_tb
UNION ALL SELECT 'concepts', COUNT(*) FROM e01_200_03_tb WHERE ent_uid LIKE 'concept:%'
UNION ALL SELECT 'relations', COUNT(*) FROM e01_222_01_tb
UNION ALL SELECT 'relation_types', COUNT(*) FROM e01_202_01_tb;

SELECT '=== ساختار کلاس ===' AS section;
SELECT 
  sub.ent_uid AS class,
  obj.ent_uid AS has_part,
  obj.label
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid = 'has_part'
JOIN e01_200_03_tb sub ON sub.ent_id = r.subj_ent_id
JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
ORDER BY sub.ent_uid, obj.ent_uid;
