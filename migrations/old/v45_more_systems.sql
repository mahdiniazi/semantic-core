-- v45 — گسترش عمودی: ترمز، فرمان، تعلیق، تهویه
.mode column
.headers on

BEGIN;

-- =====================================================================
-- ۱. انواع سیستم‌های جدید
-- =====================================================================
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract) VALUES
('BrakingSystem',    'سیستم ترمز',     1),
('SteeringSystem',   'سیستم فرمان',    1),
('SuspensionSystem', 'سیستم تعلیق',    1),
('HVACSystem',       'سیستم تهویه',    1);

UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='EESystem')
  WHERE type_uid IN ('BrakingSystem','SteeringSystem','SuspensionSystem','HVACSystem');

-- =====================================================================
-- ۲. انواع قطعات — ترمز
-- =====================================================================
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract) VALUES
('BrakeMasterCylinder','پمپ ترمز',0),
('BrakeBooster','بوستر ترمز',0),
('BrakeDisc','دیسک ترمز',0),
('BrakePad','لنت ترمز',0),
('BrakeCaliper','کالیپر ترمز',0),
('BrakeFluid','روغن ترمز',0),
('BrakeLine','لوله ترمز',0);

-- فرمان
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract) VALUES
('SteeringWheel','فلکه فرمان',0),
('SteeringColumn','ستون فرمان',0),
('SteeringRack','جعبه فرمان',0),
('PowerSteeringPump','پمپ هیدرولیک فرمان',0),
('TieRod','میل موجی فرمان',0);

-- تعلیق
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract) VALUES
('CoilSpring','فنر لول',0),
('ShockAbsorber','کمک فنر',0),
('ControlArm','سیبک/طبق',0),
('BallJoint','سیبک چرخ',0),
('Bushing','بوش',0);

-- تهویه
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract) VALUES
('ACCompressor','کمپرسور کولر',0),
('ACCondenser','کندانسور کولر',0),
('ACExpansionValve','شیر انبساط کولر',0),
('ACRefrigerant','گاز کولر',0),
('BlowerMotor','فن بخاری',0),
('CabinAirFilter','فیلتر کابین',0),
('HeaterCore','رادیاتور بخاری',0);

-- اتصال زیرسیستم‌ها
UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='BrakingSystem')
  WHERE type_uid IN ('BrakeMasterCylinder','BrakeBooster','BrakeDisc','BrakePad','BrakeCaliper','BrakeFluid','BrakeLine');
UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='SteeringSystem')
  WHERE type_uid IN ('SteeringWheel','SteeringColumn','SteeringRack','PowerSteeringPump','TieRod');
UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='SuspensionSystem')
  WHERE type_uid IN ('CoilSpring','ShockAbsorber','ControlArm','BallJoint','Bushing');
UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='HVACSystem')
  WHERE type_uid IN ('ACCompressor','ACCondenser','ACExpansionValve','ACRefrigerant','BlowerMotor','CabinAirFilter','HeaterCore','ACCompressorClutch');

-- =====================================================================
-- ۳. مفهوم‌ها (concept) برای هر قطعه
-- =====================================================================
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('concept:brake-master',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='BrakeMasterCylinder'),'concept','پمپ ترمز','هر پمپ ترمز',2),
('concept:brake-booster',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='BrakeBooster'),'concept','بوستر ترمز','هر بوستر ترمز',2),
('concept:brake-disc',     (SELECT type_id FROM e01_200_01_tb WHERE type_uid='BrakeDisc'),'concept','دیسک ترمز','هر دیسک ترمز',2),
('concept:brake-pad',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='BrakePad'),'concept','لنت ترمز','هر لنت ترمز',2),
('concept:brake-caliper',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='BrakeCaliper'),'concept','کالیپر ترمز','هر کالیپر',2),
('concept:brake-fluid',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='BrakeFluid'),'concept','روغن ترمز','هر روغن ترمز',2),
('concept:brake-line',     (SELECT type_id FROM e01_200_01_tb WHERE type_uid='BrakeLine'),'concept','لوله ترمز','هر لوله ترمز',2),

('concept:steering-wheel', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='SteeringWheel'),'concept','فلکه فرمان','هر فلکه فرمان',2),
('concept:steering-column',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='SteeringColumn'),'concept','ستون فرمان','هر ستون فرمان',2),
('concept:steering-rack',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='SteeringRack'),'concept','جعبه فرمان','هر جعبه فرمان',2),
('concept:power-steering', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='PowerSteeringPump'),'concept','پمپ هیدرولیک فرمان','هر پمپ هیدرولیک',2),
('concept:tie-rod',        (SELECT type_id FROM e01_200_01_tb WHERE type_uid='TieRod'),'concept','میل موجی فرمان','هر میل موجی',2),

('concept:coil-spring',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='CoilSpring'),'concept','فنر لول','هر فنر لول',2),
('concept:shock-absorber', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='ShockAbsorber'),'concept','کمک فنر','هر کمک فنر',2),
('concept:control-arm',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='ControlArm'),'concept','طبق','هر طبق',2),
('concept:ball-joint',     (SELECT type_id FROM e01_200_01_tb WHERE type_uid='BallJoint'),'concept','سیبک چرخ','هر سیبک چرخ',2),
('concept:bushing',        (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Bushing'),'concept','بوش','هر بوش',2),

('concept:ac-compressor',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='ACCompressor'),'concept','کمپرسور کولر','هر کمپرسور کولر',2),
('concept:ac-condenser',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='ACCondenser'),'concept','کندانسور کولر','هر کندانسور کولر',2),
('concept:ac-expansion',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='ACExpansionValve'),'concept','شیر انبساط کولر','هر شیر انبساط',2),
('concept:ac-refrigerant', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='ACRefrigerant'),'concept','گاز کولر','هر گاز کولر',2),
('concept:blower-motor',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='BlowerMotor'),'concept','فن بخاری','هر فن بخاری',2),
('concept:cabin-filter',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='CabinAirFilter'),'concept','فیلتر کابین','هر فیلتر کابین',2),
('concept:heater-core',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='HeaterCore'),'concept','رادیاتور بخاری','هر رادیاتور بخاری',2);

-- =====================================================================
-- ۴. اضافه کردن به ساختار کلاس (has_part)
-- =====================================================================

-- ترمز، فرمان، تعلیق → روی concept:vehicle (همه وسایل نقلیه دارند)
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:vehicle-has-' || REPLACE(p.obj_uid, 'concept:', ''),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_part'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:vehicle'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.obj_uid),
  'asserted', 2
FROM (
  SELECT 'concept:brake-master' AS obj_uid UNION ALL
  SELECT 'concept:brake-booster' UNION ALL
  SELECT 'concept:brake-disc' UNION ALL
  SELECT 'concept:brake-pad' UNION ALL
  SELECT 'concept:brake-caliper' UNION ALL
  SELECT 'concept:brake-fluid' UNION ALL
  SELECT 'concept:brake-line' UNION ALL
  SELECT 'concept:steering-wheel' UNION ALL
  SELECT 'concept:steering-column' UNION ALL
  SELECT 'concept:steering-rack' UNION ALL
  SELECT 'concept:power-steering' UNION ALL
  SELECT 'concept:tie-rod' UNION ALL
  SELECT 'concept:coil-spring' UNION ALL
  SELECT 'concept:shock-absorber' UNION ALL
  SELECT 'concept:control-arm' UNION ALL
  SELECT 'concept:ball-joint' UNION ALL
  SELECT 'concept:bushing'
) p
WHERE NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.rel_uid = 'r:vehicle-has-' || REPLACE(p.obj_uid, 'concept:', ''));

-- تهویه → روی concept:passenger-car (خودروهای سواری)
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:passengercar-has-' || REPLACE(p.obj_uid, 'concept:', ''),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_part'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:passenger-car'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.obj_uid),
  'asserted', 2
FROM (
  SELECT 'concept:ac-compressor' AS obj_uid UNION ALL
  SELECT 'concept:ac-condenser' UNION ALL
  SELECT 'concept:ac-expansion' UNION ALL
  SELECT 'concept:ac-refrigerant' UNION ALL
  SELECT 'concept:blower-motor' UNION ALL
  SELECT 'concept:cabin-filter' UNION ALL
  SELECT 'concept:heater-core'
) p
WHERE NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.rel_uid = 'r:passengercar-has-' || REPLACE(p.obj_uid, 'concept:', ''));

-- =====================================================================
-- ۵. لاگ
-- =====================================================================
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v45_more_systems','Vertical expansion: braking, steering, suspension, HVAC');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- =====================================================================
-- گزارش
-- =====================================================================
SELECT 'entities' AS k, COUNT(*) AS n FROM e01_200_03_tb
UNION ALL SELECT 'relations', COUNT(*) FROM e01_222_01_tb
UNION ALL SELECT 'concepts', COUNT(*) FROM e01_200_03_tb WHERE ent_uid LIKE 'concept:%'
UNION ALL SELECT 'has_part_relations', COUNT(*) FROM e01_222_01_tb 
  WHERE reltype_id = (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_part');

SELECT '=== ساختار کلاس کامل ===' AS section;
SELECT 
  sub.ent_uid AS class,
  COUNT(*) AS n_parts
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid = 'has_part'
JOIN e01_200_03_tb sub ON sub.ent_id = r.subj_ent_id
GROUP BY sub.ent_uid
ORDER BY sub.ent_uid;
