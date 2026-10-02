-- v83 — تکمیل همه زیرسیستم‌ها بر اساس استاندارد
.mode column
.headers on

BEGIN;

-- ═══════════════════════════════════════════════════════
-- ۱. انواع جدید
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract) VALUES
('FuelFilter',        'فیلتر سوخت',       0),
('FuelRail',          'ریل سوخت',         0),
('FuelRegulator',     'رگولاتور فشار سوخت',0),
('Differential',      'دیفرانسیل',        0),
('BrakeDrum',         'کاسه چرخ',         0),
('BrakeShoe',         'لنت کاسه‌ای',      0),
('SwayBar',           'موج‌گیر',          0),
('WheelBearing',      'یاتاقان چرخ',      0),
('WheelNut',          'مهره چرخ',         0),
('Rim',               'رینگ',             0),
('ReverseLight',      'چراغ دنده عقب',    0),
('FogLight',          'چراغ مه‌شکن',      0),
('InteriorLight',     'چراغ سقفی',        0),
('WiperMotor',        'موتور برف‌پاک‌کن',  0),
('WiperBlade',        'تیغه برف‌پاک‌کن',   0),
('DoorLockActuator',  'قفل مرکزی',        0),
('CrashSensor',       'سنسور تصادف',      0),
('SeatbeltPretensioner','پیش‌کشنده کمربند',0),
('Speedometer',       'کیلومتر',          0),
('Tachometer',        'دورسنج',           0),
('FuelGauge',         'آمپر بنزین',       0),
('CoolantTempGauge',  'آمپر دما',         0),
('Radar',             'رادار',            0),
('Lidar',             'لیدار',            0),
('Amplifier',         'آمپلی‌فایر',       0),
('Antenna',           'آنتن',             0),
('Touchscreen',       'تاچ‌اسکرین',       0),
('VoltageRegulator',  'تنظیم‌کننده ولتاژ',0),
('IgnitionModule',    'ماژول جرقه',       0),
('IntakeAirTempSensor','سنسور IAT',       0),
('FuelLevelSensor',   'سنسور سطح سوخت',   0),
('FuelPressureSensor','سنسور فشار سوخت',  0),
('OilPressureSensor', 'سنسور فشار روغن',  0),
('OilTempSensor',     'سنسور دمای روغن',  0),
('VehicleSpeedSensor','سنسور سرعت خودرو', 0),
('WheelSpeedSensor',  'سنسور سرعت چرخ',   0),
('EGRPositionSensor', 'سنسور موقعیت EGR', 0),
('TurboBoostSensor',  'سنسور بوست توربو', 0),
('UpstreamO2Sensor',  'سنسور O2 بالادست', 0),
('DownstreamO2Sensor','سنسور O2 پایین‌دست',0),
('BarometricPressureSensor','سنسور بارومتریک',0),
('ExhaustPipe',       'لوله اگزوز',       0);

-- ═══════════════════════════════════════════════════════
-- ۲. مفاهیم جدید
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
-- جرقه
('concept:ignition-module',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='IgnitionModule'),'concept','ماژول جرقه','Ignition module',2),
-- سوخت
('concept:fuel-filter',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='FuelFilter'),'concept','فیلتر سوخت','Fuel filter',2),
('concept:fuel-rail',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='FuelRail'),'concept','ریل سوخت','Fuel rail',2),
('concept:fuel-regulator',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='FuelRegulator'),'concept','رگولاتور فشار','Fuel pressure regulator',2),
-- خنک‌کننده
('concept:cooling-fan',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='CoolingFanMotor'),'concept','فن رادیاتور','Cooling fan',2),
('concept:cooling-fan-relay',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='CoolingFanRelay'),'concept','رله فن','Cooling fan relay',2),
-- اگزوز
('concept:exhaust-pipe',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='ExhaustPipe'),'concept','لوله اگزوز','Exhaust pipe',2),
('concept:egr-valve',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='EGRValve'),'concept','شیر EGR','EGR valve',2),
('concept:upstream-o2',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='UpstreamO2Sensor'),'concept','سنسور O2 بالادست','Upstream O2',2),
('concept:downstream-o2',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='DownstreamO2Sensor'),'concept','سنسور O2 پایین‌دست','Downstream O2',2),
-- انتقال قدرت
('concept:differential',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='Differential'),'concept','دیفرانسیل','Differential',2),
-- ترمز
('concept:brake-drum',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='BrakeDrum'),'concept','کاسه چرخ','Brake drum',2),
('concept:brake-shoe',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='BrakeShoe'),'concept','لنت کاسه‌ای','Brake shoe',2),
-- تعلیق
('concept:sway-bar',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='SwayBar'),'concept','موج‌گیر','Sway bar',2),
('concept:wheel-bearing',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='WheelBearing'),'concept','یاتاقان چرخ','Wheel bearing',2),
-- چرخ
('concept:wheel-nut',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='WheelNut'),'concept','مهره چرخ','Wheel nut',2),
('concept:rim',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='Rim'),'concept','رینگ','Rim',2),
-- روشنایی
('concept:reverse-light',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='ReverseLight'),'concept','چراغ دنده عقب','Reverse light',2),
('concept:fog-light',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='FogLight'),'concept','چراغ مه‌شکن','Fog light',2),
('concept:interior-light',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='InteriorLight'),'concept','چراغ سقفی','Interior light',2),
-- راحتی
('concept:wiper-motor',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='WiperMotor'),'concept','موتور برف‌پاک‌کن','Wiper motor',2),
('concept:wiper-blade',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='WiperBlade'),'concept','تیغه برف‌پاک‌کن','Wiper blade',2),
('concept:door-lock',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='DoorLockActuator'),'concept','قفل مرکزی','Central lock',2),
-- ایربگ
('concept:crash-sensor',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='CrashSensor'),'concept','سنسور تصادف','Crash sensor',2),
('concept:seatbelt-pretensioner',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='SeatbeltPretensioner'),'concept','پیش‌کشنده کمربند','Seatbelt pretensioner',2),
-- داشبورد
('concept:speedometer',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='Speedometer'),'concept','کیلومتر','Speedometer',2),
('concept:tachometer',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='Tachometer'),'concept','دورسنج','Tachometer',2),
('concept:fuel-gauge',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='FuelGauge'),'concept','آمپر بنزین','Fuel gauge',2),
('concept:coolant-gauge',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='CoolantTempGauge'),'concept','آمپر دما','Coolant temperature gauge',2),
-- ADAS
('concept:radar',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='Radar'),'concept','رادار','Radar',2),
('concept:lidar',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='Lidar'),'concept','لیدار','Lidar',2),
-- صوتی
('concept:amplifier',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='Amplifier'),'concept','آمپلی‌فایر','Amplifier',2),
('concept:antenna',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='Antenna'),'concept','آنتن','Antenna',2),
('concept:touchscreen',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='Touchscreen'),'concept','تاچ‌اسکرین','Touchscreen',2),
-- تأمین برق
('concept:voltage-regulator',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='VoltageRegulator'),'concept','تنظیم‌کننده ولتاژ','Voltage regulator',2),
-- سنسورهای بیشتر
('concept:iat-sensor',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='IntakeAirTempSensor'),'concept','سنسور IAT','IAT sensor',2),
('concept:fuel-level',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='FuelLevelSensor'),'concept','سنسور سطح سوخت','Fuel level',2),
('concept:fuel-pressure',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='FuelPressureSensor'),'concept','سنسور فشار سوخت','Fuel pressure',2),
('concept:oil-pressure',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='OilPressureSensor'),'concept','سنسور فشار روغن','Oil pressure',2),
('concept:oil-temp',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='OilTempSensor'),'concept','سنسور دمای روغن','Oil temp',2),
('concept:vss',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='VehicleSpeedSensor'),'concept','سنسور سرعت','VSS',2),
('concept:wheel-speed',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='WheelSpeedSensor'),'concept','سنسور سرعت چرخ','Wheel speed',2),
('concept:egr-position',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='EGRPositionSensor'),'concept','سنسور موقعیت EGR','EGR position',2),
('concept:turbo-boost',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='TurboBoostSensor'),'concept','سنسور بوست توربو','Turbo boost',2),
('concept:baro-sensor',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='BarometricPressureSensor'),'concept','سنسور بارومتریک','Barometric',2);

-- ═══════════════════════════════════════════════════════
-- ۳. اتصال به زیرسیستم‌ها
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || REPLACE(p.sub, 'concept:', '') || '-has-' || REPLACE(p.part, 'concept:', ''),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_part'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.sub),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.part),
  'asserted', 2
FROM (
  -- جرقه
  SELECT 'concept:ignition-subsystem' AS sub, 'concept:ignition-module' AS part UNION ALL
  -- سوخت
  SELECT 'concept:fuel-subsystem', 'concept:fuel-filter' UNION ALL
  SELECT 'concept:fuel-subsystem', 'concept:fuel-rail' UNION ALL
  SELECT 'concept:fuel-subsystem', 'concept:fuel-regulator' UNION ALL
  -- خنک‌کننده
  SELECT 'concept:cooling-subsystem', 'concept:cooling-fan' UNION ALL
  SELECT 'concept:cooling-subsystem', 'concept:cooling-fan-relay' UNION ALL
  -- اگزوز
  SELECT 'concept:exhaust-subsystem', 'concept:exhaust-pipe' UNION ALL
  SELECT 'concept:exhaust-subsystem', 'concept:egr-valve' UNION ALL
  SELECT 'concept:exhaust-subsystem', 'concept:upstream-o2' UNION ALL
  SELECT 'concept:exhaust-subsystem', 'concept:downstream-o2' UNION ALL
  -- انتقال قدرت
  SELECT 'concept:transmission-subsystem', 'concept:differential' UNION ALL
  -- ترمز
  SELECT 'concept:braking-subsystem', 'concept:brake-drum' UNION ALL
  SELECT 'concept:braking-subsystem', 'concept:brake-shoe' UNION ALL
  -- تعلیق
  SELECT 'concept:suspension-subsystem', 'concept:sway-bar' UNION ALL
  SELECT 'concept:suspension-subsystem', 'concept:wheel-bearing' UNION ALL
  -- چرخ
  SELECT 'concept:wheel-subsystem', 'concept:wheel-nut' UNION ALL
  SELECT 'concept:wheel-subsystem', 'concept:rim' UNION ALL
  -- روشنایی
  SELECT 'concept:lighting-subsystem', 'concept:reverse-light' UNION ALL
  SELECT 'concept:lighting-subsystem', 'concept:fog-light' UNION ALL
  SELECT 'concept:lighting-subsystem', 'concept:interior-light' UNION ALL
  -- راحتی
  SELECT 'concept:comfort-subsystem', 'concept:wiper-motor' UNION ALL
  SELECT 'concept:comfort-subsystem', 'concept:wiper-blade' UNION ALL
  SELECT 'concept:comfort-subsystem', 'concept:door-lock' UNION ALL
  -- ایربگ
  SELECT 'concept:airbag-subsystem', 'concept:crash-sensor' UNION ALL
  SELECT 'concept:airbag-subsystem', 'concept:seatbelt-pretensioner' UNION ALL
  -- داشبورد
  SELECT 'concept:dashboard-subsystem', 'concept:speedometer' UNION ALL
  SELECT 'concept:dashboard-subsystem', 'concept:tachometer' UNION ALL
  SELECT 'concept:dashboard-subsystem', 'concept:fuel-gauge' UNION ALL
  SELECT 'concept:dashboard-subsystem', 'concept:coolant-gauge' UNION ALL
  -- ADAS
  SELECT 'concept:adas-subsystem', 'concept:radar' UNION ALL
  SELECT 'concept:adas-subsystem', 'concept:lidar' UNION ALL
  -- صوتی
  SELECT 'concept:audio-subsystem', 'concept:amplifier' UNION ALL
  SELECT 'concept:audio-subsystem', 'concept:antenna' UNION ALL
  SELECT 'concept:audio-subsystem', 'concept:touchscreen' UNION ALL
  -- تأمین برق
  SELECT 'concept:power-supply-subsystem', 'concept:voltage-regulator' UNION ALL
  -- سنسورها
  SELECT 'concept:sensor-subsystem', 'concept:iat-sensor' UNION ALL
  SELECT 'concept:sensor-subsystem', 'concept:fuel-level' UNION ALL
  SELECT 'concept:sensor-subsystem', 'concept:fuel-pressure' UNION ALL
  SELECT 'concept:sensor-subsystem', 'concept:oil-pressure' UNION ALL
  SELECT 'concept:sensor-subsystem', 'concept:oil-temp' UNION ALL
  SELECT 'concept:sensor-subsystem', 'concept:vss' UNION ALL
  SELECT 'concept:sensor-subsystem', 'concept:wheel-speed' UNION ALL
  SELECT 'concept:sensor-subsystem', 'concept:egr-position' UNION ALL
  SELECT 'concept:sensor-subsystem', 'concept:turbo-boost' UNION ALL
  SELECT 'concept:sensor-subsystem', 'concept:baro-sensor' UNION ALL
  -- راه‌اندازی
  SELECT 'concept:starting-subsystem', 'concept:ignition-switch'
) p
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.sub)
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.part)
  AND NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.rel_uid = 'r:' || REPLACE(p.sub, 'concept:', '') || '-has-' || REPLACE(p.part, 'concept:', ''));

-- ═══════════════════════════════════════════════════════
-- ۴. لاگ
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v83_complete_subsystems','Added 42 missing parts across all subsystems');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- ═══════════════════════════════════════════════════════
-- گزارش
-- ═══════════════════════════════════════════════════════
SELECT 'entities' AS k, COUNT(*) AS n FROM e01_200_03_tb
UNION ALL SELECT 'relations', COUNT(*) FROM e01_222_01_tb;

SELECT '=== شمارش هر زیرسیستم ===' AS section;
SELECT 
  sub.label AS subsystem,
  COUNT(*) AS n
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='has_part'
JOIN e01_200_03_tb sub ON sub.ent_id = r.subj_ent_id
WHERE sub.ent_uid LIKE 'concept:%-subsystem'
  AND r.status='asserted' AND r.superseded_at IS NULL
GROUP BY sub.ent_uid
ORDER BY n DESC;
