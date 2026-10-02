-- v78 — ساختار چهارسطحی: vehicle → system → subsystem → part
.mode column
.headers on

BEGIN;

-- ═══════════════════════════════════════════════════════
-- ۱. انواع جدید
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract) VALUES
('VehicleSystem',    'سیستم خودرو',    1),
('VehicleSubsystem', 'زیرسیستم خودرو', 1);

-- ═══════════════════════════════════════════════════════
-- ۲. پنج سیستم اصلی
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('concept:powertrain-system', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='VehicleSystem'), 'concept', 'سیستم پیشرانه',    'Powertrain System',  2),
('concept:chassis-system',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='VehicleSystem'), 'concept', 'سیستم شاسی',       'Chassis System',     2),
('concept:body-system',       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='VehicleSystem'), 'concept', 'سیستم بدنه',       'Body System',        2),
('concept:ee-system',         (SELECT type_id FROM e01_200_01_tb WHERE type_uid='VehicleSystem'), 'concept', 'سیستم برق و الکترونیک','E/E System',       2),
('concept:safety-system',     (SELECT type_id FROM e01_200_01_tb WHERE type_uid='VehicleSystem'), 'concept', 'سیستم ایمنی',      'Safety System',      2);

-- ═══════════════════════════════════════════════════════
-- ۳. بیست زیرسیستم
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
-- پیشرانه
('concept:ignition-subsystem',     (SELECT type_id FROM e01_200_01_tb WHERE type_uid='VehicleSubsystem'),'concept','جرقه‌زنی',      'Ignition',     2),
('concept:fuel-subsystem',         (SELECT type_id FROM e01_200_01_tb WHERE type_uid='VehicleSubsystem'),'concept','سوخت‌رسانی',    'Fuel',         2),
('concept:cooling-subsystem',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='VehicleSubsystem'),'concept','خنک‌کننده',     'Cooling',      2),
('concept:exhaust-subsystem',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='VehicleSubsystem'),'concept','اگزوز',        'Exhaust',      2),
('concept:transmission-subsystem', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='VehicleSubsystem'),'concept','انتقال قدرت',   'Transmission', 2),
-- شاسی
('concept:braking-subsystem',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='VehicleSubsystem'),'concept','ترمز',         'Braking',      2),
('concept:steering-subsystem',     (SELECT type_id FROM e01_200_01_tb WHERE type_uid='VehicleSubsystem'),'concept','فرمان',        'Steering',     2),
('concept:suspension-subsystem',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='VehicleSubsystem'),'concept','تعلیق',        'Suspension',   2),
('concept:wheel-subsystem',        (SELECT type_id FROM e01_200_01_tb WHERE type_uid='VehicleSubsystem'),'concept','چرخ',          'Wheel',        2),
-- بدنه
('concept:lighting-subsystem',     (SELECT type_id FROM e01_200_01_tb WHERE type_uid='VehicleSubsystem'),'concept','روشنایی',      'Lighting',     2),
('concept:comfort-subsystem',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='VehicleSubsystem'),'concept','راحتی',        'Comfort',      2),
('concept:hvac-subsystem',         (SELECT type_id FROM e01_200_01_tb WHERE type_uid='VehicleSubsystem'),'concept','تهویه',        'HVAC',         2),
-- برق
('concept:power-supply-subsystem', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='VehicleSubsystem'),'concept','تأمین برق',    'Power Supply', 2),
('concept:starting-subsystem',     (SELECT type_id FROM e01_200_01_tb WHERE type_uid='VehicleSubsystem'),'concept','راه‌اندازی',    'Starting',     2),
('concept:ecu-subsystem',          (SELECT type_id FROM e01_200_01_tb WHERE type_uid='VehicleSubsystem'),'concept','ECU',          'ECU',          2),
('concept:sensor-subsystem',       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='VehicleSubsystem'),'concept','سنسور',        'Sensor',       2),
('concept:bus-subsystem',          (SELECT type_id FROM e01_200_01_tb WHERE type_uid='VehicleSubsystem'),'concept','شبکه',         'Bus',          2),
('concept:ev-subsystem',           (SELECT type_id FROM e01_200_01_tb WHERE type_uid='VehicleSubsystem'),'concept','برقی EV',      'EV',           2),
('concept:audio-subsystem',        (SELECT type_id FROM e01_200_01_tb WHERE type_uid='VehicleSubsystem'),'concept','صوتی',         'Audio',        2),
-- ایمنی
('concept:airbag-subsystem',       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='VehicleSubsystem'),'concept','ایربگ',        'Airbag',       2),
('concept:abs-subsystem',          (SELECT type_id FROM e01_200_01_tb WHERE type_uid='VehicleSubsystem'),'concept','ABS',          'ABS',          2),
('concept:adas-subsystem',         (SELECT type_id FROM e01_200_01_tb WHERE type_uid='VehicleSubsystem'),'concept','ADAS',         'ADAS',         2),
('concept:dashboard-subsystem',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='VehicleSubsystem'),'concept','داشبورد',      'Dashboard',    2);

-- ═══════════════════════════════════════════════════════
-- ۴. vehicle → systems
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT 'r:vehicle-has-' || REPLACE(s.uid, 'concept:', ''),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_part'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:vehicle'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=s.uid),
  'asserted', 2
FROM (
  SELECT 'concept:powertrain-system' AS uid UNION ALL
  SELECT 'concept:chassis-system' UNION ALL
  SELECT 'concept:body-system' UNION ALL
  SELECT 'concept:ee-system' UNION ALL
  SELECT 'concept:safety-system'
) s
WHERE NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.rel_uid = 'r:vehicle-has-' || REPLACE(s.uid, 'concept:', ''));

-- ═══════════════════════════════════════════════════════
-- ۵. system → subsystem
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT 'r:' || REPLACE(s.sys, 'concept:', '') || '-has-' || REPLACE(s.sub, 'concept:', ''),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_part'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=s.sys),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=s.sub),
  'asserted', 2
FROM (
  SELECT 'concept:powertrain-system' AS sys, 'concept:ignition-subsystem' AS sub UNION ALL
  SELECT 'concept:powertrain-system', 'concept:fuel-subsystem' UNION ALL
  SELECT 'concept:powertrain-system', 'concept:cooling-subsystem' UNION ALL
  SELECT 'concept:powertrain-system', 'concept:exhaust-subsystem' UNION ALL
  SELECT 'concept:powertrain-system', 'concept:transmission-subsystem' UNION ALL
  SELECT 'concept:chassis-system', 'concept:braking-subsystem' UNION ALL
  SELECT 'concept:chassis-system', 'concept:steering-subsystem' UNION ALL
  SELECT 'concept:chassis-system', 'concept:suspension-subsystem' UNION ALL
  SELECT 'concept:chassis-system', 'concept:wheel-subsystem' UNION ALL
  SELECT 'concept:body-system', 'concept:lighting-subsystem' UNION ALL
  SELECT 'concept:body-system', 'concept:comfort-subsystem' UNION ALL
  SELECT 'concept:body-system', 'concept:hvac-subsystem' UNION ALL
  SELECT 'concept:ee-system', 'concept:power-supply-subsystem' UNION ALL
  SELECT 'concept:ee-system', 'concept:starting-subsystem' UNION ALL
  SELECT 'concept:ee-system', 'concept:ecu-subsystem' UNION ALL
  SELECT 'concept:ee-system', 'concept:sensor-subsystem' UNION ALL
  SELECT 'concept:ee-system', 'concept:bus-subsystem' UNION ALL
  SELECT 'concept:ee-system', 'concept:ev-subsystem' UNION ALL
  SELECT 'concept:ee-system', 'concept:audio-subsystem' UNION ALL
  SELECT 'concept:safety-system', 'concept:airbag-subsystem' UNION ALL
  SELECT 'concept:safety-system', 'concept:abs-subsystem' UNION ALL
  SELECT 'concept:safety-system', 'concept:adas-subsystem' UNION ALL
  SELECT 'concept:safety-system', 'concept:dashboard-subsystem'
) s
WHERE NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.rel_uid = 'r:' || REPLACE(s.sys, 'concept:', '') || '-has-' || REPLACE(s.sub, 'concept:', ''));

-- ═══════════════════════════════════════════════════════
-- ۶. subsystem → part
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT 'r:' || REPLACE(p.sub, 'concept:', '') || '-has-' || REPLACE(p.part, 'concept:', ''),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_part'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.sub),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.part),
  'asserted', 2
FROM (
  -- پیشرانه
  SELECT 'concept:ignition-subsystem' AS sub, 'concept:ignition-coil' AS part UNION ALL
  SELECT 'concept:ignition-subsystem', 'concept:spark-plug' UNION ALL
  SELECT 'concept:fuel-subsystem', 'concept:fuel-pump' UNION ALL
  SELECT 'concept:fuel-subsystem', 'concept:injector' UNION ALL
  SELECT 'concept:fuel-subsystem', 'concept:fuel-tank' UNION ALL
  SELECT 'concept:cooling-subsystem', 'concept:radiator' UNION ALL
  SELECT 'concept:cooling-subsystem', 'concept:water-pump' UNION ALL
  SELECT 'concept:cooling-subsystem', 'concept:thermostat' UNION ALL
  SELECT 'concept:cooling-subsystem', 'concept:coolant-reservoir' UNION ALL
  SELECT 'concept:exhaust-subsystem', 'concept:catalytic-converter' UNION ALL
  SELECT 'concept:exhaust-subsystem', 'concept:muffler' UNION ALL
  SELECT 'concept:exhaust-subsystem', 'concept:exhaust-manifold' UNION ALL
  SELECT 'concept:transmission-subsystem', 'concept:transmission' UNION ALL
  SELECT 'concept:transmission-subsystem', 'concept:clutch' UNION ALL
  SELECT 'concept:transmission-subsystem', 'concept:drive-shaft' UNION ALL
  -- شاسی
  SELECT 'concept:braking-subsystem', 'concept:brake-master' UNION ALL
  SELECT 'concept:braking-subsystem', 'concept:brake-booster' UNION ALL
  SELECT 'concept:braking-subsystem', 'concept:brake-disc' UNION ALL
  SELECT 'concept:braking-subsystem', 'concept:brake-pad' UNION ALL
  SELECT 'concept:braking-subsystem', 'concept:brake-caliper' UNION ALL
  SELECT 'concept:braking-subsystem', 'concept:brake-fluid' UNION ALL
  SELECT 'concept:braking-subsystem', 'concept:brake-line' UNION ALL
  SELECT 'concept:steering-subsystem', 'concept:steering-wheel' UNION ALL
  SELECT 'concept:steering-subsystem', 'concept:steering-column' UNION ALL
  SELECT 'concept:steering-subsystem', 'concept:steering-rack' UNION ALL
  SELECT 'concept:steering-subsystem', 'concept:power-steering' UNION ALL
  SELECT 'concept:steering-subsystem', 'concept:tie-rod' UNION ALL
  SELECT 'concept:suspension-subsystem', 'concept:coil-spring' UNION ALL
  SELECT 'concept:suspension-subsystem', 'concept:shock-absorber' UNION ALL
  SELECT 'concept:suspension-subsystem', 'concept:control-arm' UNION ALL
  SELECT 'concept:suspension-subsystem', 'concept:ball-joint' UNION ALL
  SELECT 'concept:suspension-subsystem', 'concept:bushing' UNION ALL
  SELECT 'concept:wheel-subsystem', 'concept:wheel' UNION ALL
  SELECT 'concept:wheel-subsystem', 'concept:tire' UNION ALL
  SELECT 'concept:wheel-subsystem', 'concept:tpms-sensor' UNION ALL
  -- بدنه
  SELECT 'concept:lighting-subsystem', 'concept:headlight-low' UNION ALL
  SELECT 'concept:lighting-subsystem', 'concept:headlight-high' UNION ALL
  SELECT 'concept:lighting-subsystem', 'concept:tail-light' UNION ALL
  SELECT 'concept:lighting-subsystem', 'concept:brake-light' UNION ALL
  SELECT 'concept:lighting-subsystem', 'concept:turn-signal' UNION ALL
  SELECT 'concept:comfort-subsystem', 'concept:seat' UNION ALL
  SELECT 'concept:comfort-subsystem', 'concept:door' UNION ALL
  SELECT 'concept:comfort-subsystem', 'concept:window' UNION ALL
  SELECT 'concept:comfort-subsystem', 'concept:windshield' UNION ALL
  SELECT 'concept:comfort-subsystem', 'concept:mirror' UNION ALL
  SELECT 'concept:hvac-subsystem', 'concept:ac-compressor' UNION ALL
  SELECT 'concept:hvac-subsystem', 'concept:ac-condenser' UNION ALL
  SELECT 'concept:hvac-subsystem', 'concept:ac-expansion' UNION ALL
  SELECT 'concept:hvac-subsystem', 'concept:ac-refrigerant' UNION ALL
  SELECT 'concept:hvac-subsystem', 'concept:blower-motor' UNION ALL
  SELECT 'concept:hvac-subsystem', 'concept:cabin-filter' UNION ALL
  SELECT 'concept:hvac-subsystem', 'concept:heater-core' UNION ALL
  -- برق
  SELECT 'concept:power-supply-subsystem', 'concept:battery' UNION ALL
  SELECT 'concept:power-supply-subsystem', 'concept:alternator' UNION ALL
  SELECT 'concept:power-supply-subsystem', 'concept:fuse' UNION ALL
  SELECT 'concept:power-supply-subsystem', 'concept:relay' UNION ALL
  SELECT 'concept:power-supply-subsystem', 'concept:wiring' UNION ALL
  SELECT 'concept:starting-subsystem', 'concept:starter' UNION ALL
  SELECT 'concept:starting-subsystem', 'concept:ignition-switch' UNION ALL
  SELECT 'concept:ecu-subsystem', 'concept:engine-ecu' UNION ALL
  SELECT 'concept:ecu-subsystem', 'concept:transmission-ecu' UNION ALL
  SELECT 'concept:ecu-subsystem', 'concept:body-ecu' UNION ALL
  SELECT 'concept:ecu-subsystem', 'concept:abs-ecu' UNION ALL
  SELECT 'concept:sensor-subsystem', 'concept:crankshaft-sensor' UNION ALL
  SELECT 'concept:sensor-subsystem', 'concept:camshaft-sensor' UNION ALL
  SELECT 'concept:sensor-subsystem', 'concept:map-sensor' UNION ALL
  SELECT 'concept:sensor-subsystem', 'concept:coolant-sensor' UNION ALL
  SELECT 'concept:sensor-subsystem', 'concept:o2-sensor' UNION ALL
  SELECT 'concept:sensor-subsystem', 'concept:maf-sensor' UNION ALL
  SELECT 'concept:sensor-subsystem', 'concept:knock-sensor' UNION ALL
  SELECT 'concept:sensor-subsystem', 'concept:tps' UNION ALL
  SELECT 'concept:bus-subsystem', 'concept:can-bus' UNION ALL
  SELECT 'concept:audio-subsystem', 'concept:infotainment' UNION ALL
  SELECT 'concept:audio-subsystem', 'concept:speaker' UNION ALL
  -- ایمنی
  SELECT 'concept:airbag-subsystem', 'concept:airbag' UNION ALL
  SELECT 'concept:airbag-subsystem', 'concept:seatbelt' UNION ALL
  SELECT 'concept:abs-subsystem', 'concept:abs-module' UNION ALL
  SELECT 'concept:abs-subsystem', 'concept:abs-sensor' UNION ALL
  SELECT 'concept:adas-subsystem', 'concept:cruise-control' UNION ALL
  SELECT 'concept:adas-subsystem', 'concept:parking-sensor' UNION ALL
  SELECT 'concept:adas-subsystem', 'concept:reverse-camera' UNION ALL
  SELECT 'concept:dashboard-subsystem', 'concept:check-engine-light'
) p
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.sub)
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.part)
  AND NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.rel_uid = 'r:' || REPLACE(p.sub, 'concept:', '') || '-has-' || REPLACE(p.part, 'concept:', ''));

-- ═══════════════════════════════════════════════════════
-- ۷. بازنشستگی روابط مسطح قدیمی
-- ═══════════════════════════════════════════════════════
UPDATE e01_222_01_tb 
SET status = 'retracted', superseded_at = datetime('now')
WHERE reltype_id = (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_part')
  AND subj_ent_id = (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:vehicle')
  AND status = 'asserted'
  AND superseded_at IS NULL;

-- ═══════════════════════════════════════════════════════
-- ۸. لاگ
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v78_4level_hierarchy','4-level hierarchy: vehicle → 5 systems → 23 subsystems → parts');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- ═══════════════════════════════════════════════════════
-- گزارش
-- ═══════════════════════════════════════════════════════
SELECT 'entities' AS k, COUNT(*) AS n FROM e01_200_03_tb
UNION ALL SELECT 'relations', COUNT(*) FROM e01_222_01_tb;

SELECT '=== ساختار درختی ===' AS section;
SELECT 
  CASE 
    WHEN ent_uid LIKE 'concept:%system' AND ent_uid NOT LIKE '%-subsystem' THEN '۱. system'
    WHEN ent_uid LIKE '%-subsystem' THEN '۲. subsystem'
    WHEN ent_uid = 'concept:vehicle' THEN '۰. vehicle'
    ELSE '—'
  END AS level,
  ent_uid,
  label
FROM e01_200_03_tb
WHERE ent_uid LIKE 'concept:%system%' OR ent_uid = 'concept:vehicle'
ORDER BY level, ent_uid;
