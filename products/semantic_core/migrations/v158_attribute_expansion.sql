-- ============================================================
-- v158_attribute_expansion.sql
-- گسترش لایه ویژگی‌ها (Attribute) و واحدها (Unit)
-- بر اساس مدل دامنه (سند ۰۲) و قانون اساسی (سند ۰۱)
--
-- پیش‌نیاز: v157_attribute_hierarchy اجرا شده باشد
-- اجرای مکرر: بی‌خطر (idempotent)
-- ============================================================

BEGIN TRANSACTION;

-- ------------------------------------------------------------
-- ۱. افزودن ۱۵ ویژگی جدید (idempotent)
-- ------------------------------------------------------------

-- BaseQuantity: current, resistance, mass, length, frequency
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description)
SELECT 'attribute:current',
       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='BaseQuantity'),
       'instance', 'جریان', 'کمیت جریان الکتریکی'
WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='attribute:current');

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description)
SELECT 'attribute:resistance',
       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='BaseQuantity'),
       'instance', 'مقاومت', 'کمیت مقاومت الکتریکی'
WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='attribute:resistance');

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description)
SELECT 'attribute:mass',
       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='BaseQuantity'),
       'instance', 'جرم', 'کمیت جرم'
WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='attribute:mass');

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description)
SELECT 'attribute:length',
       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='BaseQuantity'),
       'instance', 'طول', 'کمیت طول'
WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='attribute:length');

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description)
SELECT 'attribute:frequency',
       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='BaseQuantity'),
       'instance', 'فرکانس', 'کمیت فرکانس'
WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='attribute:frequency');

-- DerivedQuantity: speed, torque, power, flow, acceleration
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description)
SELECT 'attribute:speed',
       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='DerivedQuantity'),
       'instance', 'سرعت', 'کمیت سرعت'
WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='attribute:speed');

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description)
SELECT 'attribute:torque',
       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='DerivedQuantity'),
       'instance', 'گشتاور', 'کمیت گشتاور'
WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='attribute:torque');

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description)
SELECT 'attribute:power',
       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='DerivedQuantity'),
       'instance', 'توان', 'کمیت توان'
WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='attribute:power');

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description)
SELECT 'attribute:flow',
       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='DerivedQuantity'),
       'instance', 'دبی', 'کمیت دبی جریان سیال'
WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='attribute:flow');

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description)
SELECT 'attribute:acceleration',
       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='DerivedQuantity'),
       'instance', 'شتاب', 'کمیت شتاب'
WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='attribute:acceleration');

-- QualitativeProperty: color, noise, vibration
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description)
SELECT 'attribute:color',
       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='QualitativeProperty'),
       'instance', 'رنگ', 'ویژگی رنگ'
WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='attribute:color');

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description)
SELECT 'attribute:noise',
       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='QualitativeProperty'),
       'instance', 'صدا', 'ویژگی صدای تولیدی'
WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='attribute:noise');

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description)
SELECT 'attribute:vibration',
       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='QualitativeProperty'),
       'instance', 'لرزش', 'ویژگی لرزش'
WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='attribute:vibration');

-- Identifier: vin, serial
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description)
SELECT 'attribute:vin',
       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Identifier'),
       'instance', 'شماره شاسی', 'شناسه یکتای خودرو (VIN)'
WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='attribute:vin');

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description)
SELECT 'attribute:serial',
       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Identifier'),
       'instance', 'شماره سری', 'شناسه سری قطعه'
WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='attribute:serial');

-- ------------------------------------------------------------
-- ۲. افزودن ۲۶ واحد جدید
-- ------------------------------------------------------------

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description)
SELECT 'unit:celsius', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Unit'),
       'instance', 'درجه سلسیوس', 'واحد دما'
WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='unit:celsius');

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description)
SELECT 'unit:fahrenheit', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Unit'),
       'instance', 'درجه فارنهایت', 'واحد دما'
WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='unit:fahrenheit');

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description)
SELECT 'unit:kelvin', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Unit'),
       'instance', 'کلوین', 'واحد دما'
WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='unit:kelvin');

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description)
SELECT 'unit:volt', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Unit'),
       'instance', 'ولت', 'واحد ولتاژ'
WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='unit:volt');

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description)
SELECT 'unit:millivolt', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Unit'),
       'instance', 'میلی‌ولت', 'واحد ولتاژ'
WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='unit:millivolt');

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description)
SELECT 'unit:ampere', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Unit'),
       'instance', 'آمپر', 'واحد جریان'
WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='unit:ampere');

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description)
SELECT 'unit:milliampere', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Unit'),
       'instance', 'میلی‌آمپر', 'واحد جریان'
WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='unit:milliampere');

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description)
SELECT 'unit:ohm', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Unit'),
       'instance', 'اهم', 'واحد مقاومت'
WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='unit:ohm');

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description)
SELECT 'unit:kilohm', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Unit'),
       'instance', 'کیلواهم', 'واحد مقاومت'
WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='unit:kilohm');

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description)
SELECT 'unit:bar', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Unit'),
       'instance', 'بار', 'واحد فشار'
WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='unit:bar');

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description)
SELECT 'unit:psi', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Unit'),
       'instance', 'پی‌اس‌آی', 'واحد فشار'
WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='unit:psi');

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description)
SELECT 'unit:pascal', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Unit'),
       'instance', 'پاسکال', 'واحد فشار'
WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='unit:pascal');

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description)
SELECT 'unit:kilopascal', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Unit'),
       'instance', 'کیلوپاسکال', 'واحد فشار'
WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='unit:kilopascal');

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description)
SELECT 'unit:rpm', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Unit'),
       'instance', 'دور بر دقیقه', 'واحد دور موتور'
WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='unit:rpm');

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description)
SELECT 'unit:kmh', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Unit'),
       'instance', 'کیلومتر بر ساعت', 'واحد سرعت'
WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='unit:kmh');

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description)
SELECT 'unit:ms', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Unit'),
       'instance', 'متر بر ثانیه', 'واحد سرعت'
WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='unit:ms');

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description)
SELECT 'unit:newtonmeter', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Unit'),
       'instance', 'نیوتون‌متر', 'واحد گشتاور'
WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='unit:newtonmeter');

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description)
SELECT 'unit:kilowatt', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Unit'),
       'instance', 'کیلووات', 'واحد توان'
WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='unit:kilowatt');

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description)
SELECT 'unit:horsepower', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Unit'),
       'instance', 'اسب بخار', 'واحد توان'
WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='unit:horsepower');

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description)
SELECT 'unit:kilogram', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Unit'),
       'instance', 'کیلوگرم', 'واحد جرم'
WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='unit:kilogram');

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description)
SELECT 'unit:meter', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Unit'),
       'instance', 'متر', 'واحد طول'
WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='unit:meter');

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description)
SELECT 'unit:hertz', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Unit'),
       'instance', 'هرتز', 'واحد فرکانس'
WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='unit:hertz');

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description)
SELECT 'unit:lpm', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Unit'),
       'instance', 'لیتر بر دقیقه', 'واحد دبی'
WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='unit:lpm');

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description)
SELECT 'unit:mps2', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Unit'),
       'instance', 'متر بر مجذور ثانیه', 'واحد شتاب'
WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='unit:mps2');

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description)
SELECT 'unit:percent', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Unit'),
       'instance', 'درصد', 'واحد نسبی'
WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='unit:percent');

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description)
SELECT 'unit:decibel', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Unit'),
       'instance', 'دسی‌بل', 'واحد صدا'
WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='unit:decibel');

-- ------------------------------------------------------------
-- ۳. افزودن relation type: has_unit
-- ------------------------------------------------------------

INSERT OR IGNORE INTO e01_202_01_tb (type_uid, label, description, object_kind, is_functional)
VALUES ('has_unit', 'واحد دارد', 'رابطه ویژگی به واحد اندازه‌گیری', 'entity', 1);

-- قواعد has_unit (subject = Attribute, object = Unit)
INSERT OR IGNORE INTO e01_112_01_tb (reltype_id, cons_kind, target_type_id)
SELECT (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_unit'),
       'allowed_subject_type',
       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Attribute')
WHERE NOT EXISTS (SELECT 1 FROM e01_112_01_tb c
                  JOIN e01_202_01_tb r ON r.reltype_id = c.reltype_id
                  WHERE r.type_uid='has_unit' AND c.cons_kind='allowed_subject_type');

INSERT OR IGNORE INTO e01_112_01_tb (reltype_id, cons_kind, target_type_id)
SELECT (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_unit'),
       'allowed_object_type',
       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Unit')
WHERE NOT EXISTS (SELECT 1 FROM e01_112_01_tb c
                  JOIN e01_202_01_tb r ON r.reltype_id = c.reltype_id
                  WHERE r.type_uid='has_unit' AND c.cons_kind='allowed_object_type');

-- ------------------------------------------------------------
-- ۴. اطمینان از قواعد has_value
-- ------------------------------------------------------------

INSERT OR IGNORE INTO e01_112_01_tb (reltype_id, cons_kind, target_type_id)
SELECT (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_value'),
       'allowed_subject_type',
       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Attribute')
WHERE NOT EXISTS (SELECT 1 FROM e01_112_01_tb c
                  JOIN e01_202_01_tb r ON r.reltype_id = c.reltype_id
                  WHERE r.type_uid='has_value' AND c.cons_kind='allowed_subject_type');

INSERT OR IGNORE INTO e01_112_01_tb (reltype_id, cons_kind, target_type_id)
SELECT (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_value'),
       'allowed_object_type',
       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Measurement')
WHERE NOT EXISTS (SELECT 1 FROM e01_112_01_tb c
                  JOIN e01_202_01_tb r ON r.reltype_id = c.reltype_id
                  WHERE r.type_uid='has_value' AND c.cons_kind='allowed_object_type');

-- ------------------------------------------------------------
-- ۵. ساخت concept:engine
-- ------------------------------------------------------------

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description)
SELECT 'concept:engine',
       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='VehicleSubsystem'),
       'concept', 'موتور', 'موتور احتراق داخلی خودرو'
WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='concept:engine');

-- ------------------------------------------------------------
-- ۶. اتصال concept:engine به powertrain
-- ------------------------------------------------------------

INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT 'r:has_direct_part-powertrain-engine',
       (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_direct_part'),
       (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:powertrain-system'),
       (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:engine'),
       'asserted', 2
WHERE NOT EXISTS (SELECT 1 FROM e01_222_01_tb WHERE rel_uid='r:has_direct_part-powertrain-engine');

-- ------------------------------------------------------------
-- ۷. اتصال attribute → unit (has_unit)
-- ------------------------------------------------------------

-- یک اتصال تکرارپذیر: همه attribute های مشخص، با unit های مشخص
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT 'r:has-unit-' || REPLACE(s.ent_uid, ':', '-') || '-' || REPLACE(o.ent_uid, ':', '-'),
       (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_unit'),
       s.ent_id, o.ent_id, 'asserted', 2
FROM e01_200_03_tb s, e01_200_03_tb o
WHERE (s.ent_uid, o.ent_uid) IN (
  ('attribute:temperature','unit:celsius'),
  ('attribute:voltage','unit:volt'),
  ('attribute:pressure','unit:bar'),
  ('attribute:rpm','unit:rpm'),
  ('attribute:humidity','unit:percent'),
  ('attribute:current','unit:ampere'),
  ('attribute:resistance','unit:ohm'),
  ('attribute:mass','unit:kilogram'),
  ('attribute:length','unit:meter'),
  ('attribute:frequency','unit:hertz'),
  ('attribute:speed','unit:kmh'),
  ('attribute:torque','unit:newtonmeter'),
  ('attribute:power','unit:kilowatt'),
  ('attribute:flow','unit:lpm'),
  ('attribute:acceleration','unit:mps2'),
  ('attribute:noise','unit:decibel')
)
AND NOT EXISTS (
  SELECT 1 FROM e01_222_01_tb r
  WHERE r.rel_uid = 'r:has-unit-' || REPLACE(s.ent_uid, ':', '-') || '-' || REPLACE(o.ent_uid, ':', '-')
);

-- ------------------------------------------------------------
-- ۸. اتصال attribute → concept (applies_to)
-- ------------------------------------------------------------

INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT 'r:applies-' || REPLACE(s.ent_uid, ':', '-') || '-' || REPLACE(o.ent_uid, ':', '-'),
       (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='applies_to'),
       s.ent_id, o.ent_id, 'asserted', 2
FROM e01_200_03_tb s, e01_200_03_tb o
WHERE (s.ent_uid, o.ent_uid) IN (
  ('attribute:temperature','concept:engine'),
  ('attribute:rpm','concept:engine'),
  ('attribute:torque','concept:engine'),
  ('attribute:power','concept:engine'),
  ('attribute:pressure','concept:engine'),
  ('attribute:noise','concept:engine'),
  ('attribute:vibration','concept:engine'),
  ('attribute:temperature','concept:cooling-subsystem'),
  ('attribute:pressure','concept:cooling-subsystem'),
  ('attribute:flow','concept:cooling-subsystem'),
  ('attribute:temperature','concept:exhaust-subsystem'),
  ('attribute:noise','concept:exhaust-subsystem'),
  ('attribute:rpm','concept:powertrain-system'),
  ('attribute:torque','concept:powertrain-system'),
  ('attribute:power','concept:powertrain-system'),
  ('attribute:acceleration','concept:powertrain-system'),
  ('attribute:vibration','concept:powertrain-system'),
  ('attribute:voltage','concept:battery'),
  ('attribute:current','concept:battery'),
  ('attribute:mass','concept:battery'),
  ('attribute:pressure','concept:braking-subsystem'),
  ('attribute:speed','concept:transmission-subsystem'),
  ('attribute:torque','concept:transmission-subsystem'),
  ('attribute:pressure','concept:fuel-subsystem'),
  ('attribute:flow','concept:fuel-subsystem'),
  ('attribute:humidity','concept:hvac-subsystem'),
  ('attribute:temperature','concept:hvac-subsystem'),
  ('attribute:vibration','concept:suspension-subsystem'),
  ('attribute:voltage','concept:ee-system'),
  ('attribute:current','concept:ee-system'),
  ('attribute:frequency','concept:ee-system'),
  ('attribute:resistance','concept:sensor-subsystem'),
  ('attribute:noise','concept:audio-subsystem')
)
AND NOT EXISTS (
  SELECT 1 FROM e01_222_01_tb r
  WHERE r.rel_uid = 'r:applies-' || REPLACE(s.ent_uid, ':', '-') || '-' || REPLACE(o.ent_uid, ':', '-')
);

-- ------------------------------------------------------------
-- ۹. ثبت در migration log
-- ------------------------------------------------------------

INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v158_attribute_expansion',
        'Expanded Attribute layer: 15 new attributes + 26 units + has_unit + applies_to relations');

COMMIT;
