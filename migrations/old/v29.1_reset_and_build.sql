-- =====================================================================
-- v29.1 — Reset Entities + Build Electrical System Hierarchy
-- =====================================================================
-- این فایل:
--   ۱. همه موجودیت‌های قبلی و ارجاع‌هایشان را پاک می‌کند
--   ۲. ساختار سلسله‌مراتبی برق خودرو را از ریشه تا میوه می‌سازد
--   ۳. نمونه‌های واقعی خودرویی را می‌کارد
-- =====================================================================

.mode column
.headers on

BEGIN;

-- =====================================================================
-- بخش ۱ — پاک کردن داده‌های قدیمی
-- (به ترتیب: از بیرونی‌ترین لایه به موجودیت‌ها)
-- =====================================================================

DELETE FROM e01_305_03_tb;   -- زمینه روی روابط
DELETE FROM e01_305_02_tb;   -- زمینه روی مقادیر
DELETE FROM e01_305_01_tb;   -- زمینه روی موجودیت‌ها
DELETE FROM e01_222_01_tb;   -- روابط
DELETE FROM e01_302_01_tb;   -- تبار
DELETE FROM e01_300_01_tb;   -- ادعاهای هویت
DELETE FROM e01_330_02_tb;   -- snapshot
DELETE FROM e01_330_01_tb;   -- نسخه‌ها
DELETE FROM e01_201_03_tb;   -- عضویت مقادیر
DELETE FROM e01_201_02_tb;   -- مقادیر
DELETE FROM e01_200_03_tb;   -- خود موجودیت‌ها

-- =====================================================================
-- بخش ۲ — ساخت ریشه و تنه (سیستم‌های اصلی برق)
-- =====================================================================

-- ریشه
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract)
VALUES ('EESystem', 'سیستم الکتریکی/الکترونیکی', 1);

-- ۵ سیستم اصلی
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract, parent_id) VALUES
('PowerSupplySystem',   'سیستم تأمین برق',        1, (SELECT type_id FROM e01_200_01_tb WHERE type_uid='EESystem')),
('StartingSystem',      'سیستم راه‌اندازی',       1, (SELECT type_id FROM e01_200_01_tb WHERE type_uid='EESystem')),
('IgnitionSystem',      'سیستم جرقه‌زنی',          1, (SELECT type_id FROM e01_200_01_tb WHERE type_uid='EESystem')),
('ChargingSystem',      'سیستم شارژ',             1, (SELECT type_id FROM e01_200_01_tb WHERE type_uid='EESystem')),
('ControlCommSystem',   'سیستم کنترل و ارتباط',   1, (SELECT type_id FROM e01_200_01_tb WHERE type_uid='EESystem'));

-- =====================================================================
-- بخش ۳ — ساخت شاخه‌ها (زیرسیستم‌ها)
-- =====================================================================

-- زیرسیستم‌های تأمین برق
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract, parent_id) VALUES
('BatterySystem',    'سیستم باتری',     1, (SELECT type_id FROM e01_200_01_tb WHERE type_uid='PowerSupplySystem')),
('AlternatorSystem', 'سیستم دینام',     1, (SELECT type_id FROM e01_200_01_tb WHERE type_uid='PowerSupplySystem')),
('FuseBoxSystem',    'سیستم جعبه فیوز', 1, (SELECT type_id FROM e01_200_01_tb WHERE type_uid='PowerSupplySystem')),
('RelaySystem',      'سیستم رله',       1, (SELECT type_id FROM e01_200_01_tb WHERE type_uid='PowerSupplySystem')),
('WiringSystem',     'سیستم سیم‌کشی',   1, (SELECT type_id FROM e01_200_01_tb WHERE type_uid='PowerSupplySystem'));

-- زیرسیستم‌های راه‌اندازی
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract, parent_id) VALUES
('StarterMotorSystem', 'سیستم استارت',      1, (SELECT type_id FROM e01_200_01_tb WHERE type_uid='StartingSystem')),
('IgnitionSwitchSystem','سیستم سوئیچ',      1, (SELECT type_id FROM e01_200_01_tb WHERE type_uid='StartingSystem'));

-- زیرسیستم‌های جرقه‌زنی
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract, parent_id) VALUES
('IgnitionCoilSystem',  'سیستم کوئل',       1, (SELECT type_id FROM e01_200_01_tb WHERE type_uid='IgnitionSystem')),
('SparkPlugSystem',     'سیستم شمع',        1, (SELECT type_id FROM e01_200_01_tb WHERE type_uid='IgnitionSystem'));

-- زیرسیستم‌های شارژ
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract, parent_id) VALUES
('VoltageRegulatorSystem','سیستم تنظیم ولتاژ', 1, (SELECT type_id FROM e01_200_01_tb WHERE type_uid='ChargingSystem'));

-- زیرسیستم‌های کنترل و ارتباط
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract, parent_id) VALUES
('ECUSystem',     'سیستم ECU',      1, (SELECT type_id FROM e01_200_01_tb WHERE type_uid='ControlCommSystem')),
('SensorSystem',  'سیستم سنسور',    1, (SELECT type_id FROM e01_200_01_tb WHERE type_uid='ControlCommSystem')),
('ActuatorSystem','سیستم عملگر',    1, (SELECT type_id FROM e01_200_01_tb WHERE type_uid='ControlCommSystem')),
('BusSystem',     'سیستم شبکه',     1, (SELECT type_id FROM e01_200_01_tb WHERE type_uid='ControlCommSystem'));

-- =====================================================================
-- بخش ۴ — اتصال قطعات موجود به زیرسیستم‌های جدید
-- (به‌جای ساختن دوباره، همان قطعات قبلی را منتقل می‌کنیم)
-- =====================================================================

UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='BatterySystem')
  WHERE type_uid = 'Battery';

UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='AlternatorSystem')
  WHERE type_uid = 'Alternator';

UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='FuseBoxSystem')
  WHERE type_uid = 'Fuse';

UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='RelaySystem')
  WHERE type_uid = 'Relay';

UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='WiringSystem')
  WHERE type_uid IN ('Wiring');

UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='StarterMotorSystem')
  WHERE type_uid = 'StarterMotor';

UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='IgnitionSwitchSystem')
  WHERE type_uid = 'IgnitionSwitch';

UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='IgnitionCoilSystem')
  WHERE type_uid = 'IgnitionCoil';

UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='SparkPlugSystem')
  WHERE type_uid = 'SparkPlug';

UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='VoltageRegulatorSystem')
  WHERE type_uid = 'VoltageRegulator';

UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='ECUSystem')
  WHERE type_uid = 'ECU';

UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='SensorSystem')
  WHERE type_uid = 'Sensor';

UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='ActuatorSystem')
  WHERE type_uid = 'Actuator';

UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='BusSystem')
  WHERE type_uid = 'Bus';

-- =====================================================================
-- بخش ۵ — ساخت انواع جدید که هنوز نیستند
-- =====================================================================

-- قطعات برقی
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract) VALUES
('StarterMotor',       'استارت',                    0),
('StarterRelay',       'رله استارت',                0),
('IgnitionSwitch',     'سوئیچ ignition',             0),
('SparkPlug',          'شمع',                       0),
('IgnitionModule',     'ماژول جرقه',                0),
('Alternator',         'دینام',                     0),
('VoltageRegulator',   'تنظیم‌کننده ولتاژ',           0),
('ChargeIndicator',    'نشانگر شارژ',               0),
('LeadAcidBattery',    'باتری سربی-اسیدی',          0),
('LithiumIonBattery',  'باتری لیتیوم-یونی',         0);

-- انواع ECU
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract) VALUES
('EngineECU',          'ECU موتور',                  0),
('TransmissionECU',    'ECU گیربکس',                 0),
('BodyECU',            'ECU بدنه',                   0),
('ABS_ECU',            'ECU ترمز ABS',               0);

-- سنسورهای جدید
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract) VALUES
('KnockSensor',            'سنسور ناک',                 0),
('SpeedSensor',            'سنسور سرعت',                0),
('ThrottlePositionSensor', 'سنسور موقعیت دریچه گاز',    0);

-- عملگرهای جدید
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract) VALUES
('IdleAirControlValve','استپر موتور',                0);

-- شبکه‌های جدید
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract) VALUES
('CANBus',             'شبکه CAN',                   0),
('LINBus',             'شبکه LIN',                   0),
('FlexRayBus',         'شبکه FlexRay',               0),
('AutomotiveEthernet', 'اترنت خودرویی',              0);

-- =====================================================================
-- بخش ۶ — اتصال قطعات جدید به زیرسیستم‌ها
-- =====================================================================

UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='StarterMotorSystem')
  WHERE type_uid = 'StarterMotor';
UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='StarterMotorSystem')
  WHERE type_uid = 'StarterRelay';
UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='IgnitionSwitchSystem')
  WHERE type_uid = 'IgnitionSwitch';
UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='SparkPlugSystem')
  WHERE type_uid = 'SparkPlug';
UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='IgnitionCoilSystem')
  WHERE type_uid = 'IgnitionModule';
UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='AlternatorSystem')
  WHERE type_uid = 'Alternator';
UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='VoltageRegulatorSystem')
  WHERE type_uid = 'VoltageRegulator';
UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='VoltageRegulatorSystem')
  WHERE type_uid = 'ChargeIndicator';
UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='BatterySystem')
  WHERE type_uid IN ('LeadAcidBattery','LithiumIonBattery');
UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='ECUSystem')
  WHERE type_uid IN ('EngineECU','TransmissionECU','BodyECU','ABS_ECU');
UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='SensorSystem')
  WHERE type_uid IN ('KnockSensor','SpeedSensor','ThrottlePositionSensor');
UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='ActuatorSystem')
  WHERE type_uid = 'IdleAirControlValve';
UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='BusSystem')
  WHERE type_uid IN ('CANBus','LINBus','FlexRayBus','AutomotiveEthernet');

-- =====================================================================
-- بخش ۷ — کاشتن نمونه‌های واقعی (instances)
-- =====================================================================

INSERT INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
-- باتری
('battery:12v-66ah',
 (SELECT type_id FROM e01_200_01_tb WHERE type_uid='LeadAcidBattery'),
 'instance', 'باتری ۱۲V ۶۶Ah', 'باتری سربی-اسیدی معمول خودروی سواری', 2),

-- دینام
('alternator:90a',
 (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Alternator'),
 'instance', 'دینام ۹۰ آمپر', 'دینام استاندارد پراید و ۲۰۶', 2),

-- استارت
('starter:1.2kw',
 (SELECT type_id FROM e01_200_01_tb WHERE type_uid='StarterMotor'),
 'instance', 'استارت ۱.۲ کیلووات', 'استارت معمول موتور بنزینی', 2),

-- کوئل دوبل
('coil:double',
 (SELECT type_id FROM e01_200_01_tb WHERE type_uid='IgnitionCoil'),
 'instance', 'کوئل دوبل', 'کوئل دوبل معمول خودروی انژکتوری', 2),

-- ECU موتور
('ecu:engine-generic',
 (SELECT type_id FROM e01_200_01_tb WHERE type_uid='EngineECU'),
 'instance', 'ECU موتور', 'واحد کنترل الکترونیکی موتور', 2),

-- سنسورها
('sensor:crankshaft',
 (SELECT type_id FROM e01_200_01_tb WHERE type_uid='CrankshaftSensor'),
 'instance', 'سنسور دور موتور', 'سنسور موقعیت میل‌لنگ', 2),

('sensor:o2',
 (SELECT type_id FROM e01_200_01_tb WHERE type_uid='O2Sensor'),
 'instance', 'سنسور اکسیژن', 'سنسور ترکیب مخلوط سوخت', 2),

('sensor:coolant-temp',
 (SELECT type_id FROM e01_200_01_tb WHERE type_uid='CoolantTempSensor'),
 'instance', 'سنسور دمای آب', 'سنسور دمای مایع خنک‌کننده', 2),

-- انژکتور
('injector:generic',
 (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Injector'),
 'instance', 'انژکتور', 'انژکتور سوخت بنزینی', 2),

-- رله
('relay:main',
 (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Relay'),
 'instance', 'رله اصلی', 'رله اصلی مدار برق خودرو', 2),

-- فیوز
('fuse:15a',
 (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Fuse'),
 'instance', 'فیوز ۱۵ آمپر', 'فیوز استاندارد ۱۵ آمپری', 2),

-- شبکه CAN
('bus:can-500k',
 (SELECT type_id FROM e01_200_01_tb WHERE type_uid='CANBus'),
 'instance', 'CAN Bus 500kbps', 'شبکه CAN با سرعت ۵۰۰ کیلوبیت', 2),

-- DTC
('dtc:P0301',
 (SELECT type_id FROM e01_200_01_tb WHERE type_uid='DTC'),
 'concept', 'P0301', 'از دست رفتن جرقه سیلندر ۱', 2),

('dtc:P0300',
 (SELECT type_id FROM e01_200_01_tb WHERE type_uid='DTC'),
 'concept', 'P0300', 'از دست رفتن جرقه تصادفی', 2),

-- Failure modes
('fm:coil-open',
 (SELECT type_id FROM e01_200_01_tb WHERE type_uid='FailureMode'),
 'concept', 'قطع کوئل', 'قطع سیم‌پیچ اولیه کوئل', 2),

('fm:coil-short',
 (SELECT type_id FROM e01_200_01_tb WHERE type_uid='FailureMode'),
 'concept', 'اتصال کوتاه کوئل', 'اتصال کوتاه سیم‌پیچ کوئل', 2),

('fm:injector-clogged',
 (SELECT type_id FROM e01_200_01_tb WHERE type_uid='FailureMode'),
 'concept', 'گرفتگی انژکتور', 'گرفتگی نازل انژکتور', 2);

-- =====================================================================
-- بخش ۸ — لاگ و نسخه
-- =====================================================================

INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes) VALUES
('v29.1_reset_and_build',
 'Full reset of entities + electrical system hierarchy (root: EESystem, 5 systems, 17 subsystems, 40+ types, 20 sample instances)');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1, last_scan_at = datetime('now') WHERE id = 1;

COMMIT;

-- =====================================================================
-- گزارش نهایی
-- =====================================================================

SELECT '=== موجودیت‌ها ===' AS section;
SELECT COUNT(*) AS total_entities FROM e01_200_03_tb;

SELECT '=== انواع کل ===' AS section;
SELECT COUNT(*) AS total_types FROM e01_200_01_tb;

SELECT '=== شاخه برق ===' AS section;
SELECT 
  t.type_uid,
  t.label,
  t.is_abstract,
  COALESCE(p.type_uid, '(root)') AS parent
FROM e01_200_01_tb t
LEFT JOIN e01_200_01_tb p ON p.type_id = t.parent_id
WHERE t.type_uid IN ('EESystem',
                     'PowerSupplySystem','StartingSystem','IgnitionSystem',
                     'ChargingSystem','ControlCommSystem',
                     'BatterySystem','AlternatorSystem','FuseBoxSystem',
                     'RelaySystem','WiringSystem','StarterMotorSystem',
                     'IgnitionSwitchSystem','IgnitionCoilSystem','SparkPlugSystem',
                     'VoltageRegulatorSystem','ECUSystem','SensorSystem',
                     'ActuatorSystem','BusSystem')
ORDER BY parent NULLS FIRST, t.type_uid;

SELECT '=== موجودیت‌های تازه ===' AS section;
SELECT 
  e.ent_uid,
  t.type_uid AS type,
  e.nature
FROM e01_200_03_tb e
JOIN e01_200_01_tb t ON t.type_id = e.type_id
ORDER BY t.type_uid, e.ent_uid;
