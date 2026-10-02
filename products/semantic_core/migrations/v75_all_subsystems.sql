-- v75 — تکمیل همه ۲۳ زیرسیستم گمشده
.mode column
.headers on

BEGIN;

-- =====================================================================
-- ۱. انواع جدید
-- =====================================================================
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract) VALUES
-- ABS
('ABSModule',          'ماژول ABS',           0),
('ABSSensor',          'سنسور ABS',          0),
-- انتقال قدرت
('Transmission',       'گیربکس',             0),
('Clutch',             'کلاچ',               0),
('DriveShaft',         'میل‌گاردان',          0),
-- خنک‌کننده
('Radiator',           'رادیاتور',           0),
('WaterPump',          'واتر پمپ',           0),
('Thermostat',         'ترموستات',           0),
('CoolantReservoir',   'مخزن انبساط',        0),
-- اگزوز
('CatalyticConverter', 'کاتالیست',           0),
('Muffler',            'صداگیر اگزوز',       0),
('ExhaustManifold',    'منیفولد دود',        0),
-- ایمنی
('Airbag',             'ایربگ',              0),
('Seatbelt',           'کمربند ایمنی',       0),
-- راحتی
('Seat',               'صندلی',              0),
('Door',               'در',                 0),
('Window',             'شیشه',               0),
('Windshield',         'شیشه جلو',           0),
('Mirror',             'آینه',               0),
-- زیرساخت
('FuelTank',           'مخزن سوخت',          0),
('Wheel',              'چرخ',                0),
('Tire',               'لاستیک',             0),
('TPMSSensor',         'سنسور فشار لاستیک',  0),
-- اطلاعات و سرگرمی
('Infotainment',       'سیستم صوتی و مالتی‌مدیا', 0),
('Speaker',            'بلندگو',             0),
-- ADAS
('CruiseControl',      'کروز کنترل',         0),
('ParkingSensor',      'سنسور دنده عقب',     0),
('ReverseCamera',      'دوربین دنده عقب',    0),
-- پرفورمنس
('Turbocharger',       'توربو',              0),
-- داشبورد
('CheckEngineLight',   'چراغ هشدار موتور',   0);

-- اتصال به والدهای منطقی
UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Unit')
  WHERE type_uid IN ('ABSModule','Transmission','Clutch','DriveShaft','Radiator','WaterPump','Thermostat','CoolantReservoir','CatalyticConverter','Muffler','ExhaustManifold','Turbocharger','FuelTank','TPMSSensor','Infotainment','Speaker','CheckEngineLight');
UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Sensor')
  WHERE type_uid IN ('ABSSensor','ParkingSensor');
UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Actuator')
  WHERE type_uid IN ('CruiseControl','ReverseCamera');
UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Vehicle')
  WHERE type_uid IN ('Wheel','Tire');

-- =====================================================================
-- ۲. مفاهیم
-- =====================================================================
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
-- ABS
('concept:abs-module',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='ABSModule'),'concept','ماژول ABS','ABS module',2),
('concept:abs-sensor',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='ABSSensor'),'concept','سنسور ABS','ABS sensor',2),
-- انتقال قدرت
('concept:transmission',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Transmission'),'concept','گیربکس','Transmission',2),
('concept:clutch',          (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Clutch'),'concept','کلاچ','Clutch',2),
('concept:drive-shaft',     (SELECT type_id FROM e01_200_01_tb WHERE type_uid='DriveShaft'),'concept','میل‌گاردان','Drive shaft',2),
-- خنک‌کننده
('concept:radiator',        (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Radiator'),'concept','رادیاتور','Radiator',2),
('concept:water-pump',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='WaterPump'),'concept','واتر پمپ','Water pump',2),
('concept:thermostat',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Thermostat'),'concept','ترموستات','Thermostat',2),
('concept:coolant-reservoir',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='CoolantReservoir'),'concept','مخزن انبساط','Coolant reservoir',2),
-- اگزوز
('concept:catalytic-converter',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='CatalyticConverter'),'concept','کاتالیست','Catalytic converter',2),
('concept:muffler',         (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Muffler'),'concept','صداگیر اگزوز','Muffler',2),
('concept:exhaust-manifold',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='ExhaustManifold'),'concept','منیفولد دود','Exhaust manifold',2),
-- ایمنی
('concept:airbag',          (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Airbag'),'concept','ایربگ','Airbag',2),
('concept:seatbelt',        (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Seatbelt'),'concept','کمربند ایمنی','Seatbelt',2),
-- راحتی
('concept:seat',            (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Seat'),'concept','صندلی','Seat',2),
('concept:door',            (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Door'),'concept','در','Door',2),
('concept:window',          (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Window'),'concept','شیشه','Window',2),
('concept:windshield',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Windshield'),'concept','شیشه جلو','Windshield',2),
('concept:mirror',          (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Mirror'),'concept','آینه','Mirror',2),
-- زیرساخت
('concept:fuel-tank',       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='FuelTank'),'concept','مخزن سوخت','Fuel tank',2),
('concept:wheel',           (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Wheel'),'concept','چرخ','Wheel',2),
('concept:tire',            (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Tire'),'concept','لاستیک','Tire',2),
('concept:tpms-sensor',     (SELECT type_id FROM e01_200_01_tb WHERE type_uid='TPMSSensor'),'concept','سنسور فشار لاستیک','TPMS sensor',2),
-- اطلاعات و سرگرمی
('concept:infotainment',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Infotainment'),'concept','سیستم صوتی','Infotainment',2),
('concept:speaker',         (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Speaker'),'concept','بلندگو','Speaker',2),
-- ADAS
('concept:cruise-control',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='CruiseControl'),'concept','کروز کنترل','Cruise control',2),
('concept:parking-sensor',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='ParkingSensor'),'concept','سنسور دنده عقب','Parking sensor',2),
('concept:reverse-camera',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='ReverseCamera'),'concept','دوربین دنده عقب','Reverse camera',2),
-- پرفورمنس
('concept:turbocharger',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Turbocharger'),'concept','توربو','Turbocharger',2),
-- داشبورد
('concept:check-engine-light',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='CheckEngineLight'),'concept','چراغ هشدار موتور','Check engine light',2);

-- =====================================================================
-- ۳. has_part از concept:vehicle (همه وسایل نقلیه)
-- =====================================================================
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:vehicle-has-' || REPLACE(p.obj_uid, 'concept:', ''),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_part'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:vehicle'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.obj_uid),
  'asserted', 2
FROM (
  SELECT 'concept:wheel' AS obj_uid UNION ALL
  SELECT 'concept:tire' UNION ALL
  SELECT 'concept:seat' UNION ALL
  SELECT 'concept:seatbelt' UNION ALL
  SELECT 'concept:door' UNION ALL
  SELECT 'concept:window' UNION ALL
  SELECT 'concept:windshield' UNION ALL
  SELECT 'concept:mirror'
) p
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.obj_uid)
  AND NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.rel_uid = 'r:vehicle-has-' || REPLACE(p.obj_uid, 'concept:', ''));

-- =====================================================================
-- ۴. has_part از concept:passenger-car
-- =====================================================================
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:passengercar-has-' || REPLACE(p.obj_uid, 'concept:', ''),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_part'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:passenger-car'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.obj_uid),
  'asserted', 2
FROM (
  -- ABS
  SELECT 'concept:abs-module' AS obj_uid UNION ALL
  SELECT 'concept:abs-sensor' UNION ALL
  -- انتقال قدرت
  SELECT 'concept:transmission' UNION ALL
  SELECT 'concept:clutch' UNION ALL
  SELECT 'concept:drive-shaft' UNION ALL
  -- خنک‌کننده
  SELECT 'concept:radiator' UNION ALL
  SELECT 'concept:water-pump' UNION ALL
  SELECT 'concept:thermostat' UNION ALL
  SELECT 'concept:coolant-reservoir' UNION ALL
  -- اگزوز
  SELECT 'concept:catalytic-converter' UNION ALL
  SELECT 'concept:muffler' UNION ALL
  SELECT 'concept:exhaust-manifold' UNION ALL
  -- ایمنی
  SELECT 'concept:airbag' UNION ALL
  -- زیرساخت
  SELECT 'concept:fuel-tank' UNION ALL
  SELECT 'concept:tpms-sensor' UNION ALL
  -- اطلاعات و سرگرمی
  SELECT 'concept:infotainment' UNION ALL
  SELECT 'concept:speaker' UNION ALL
  -- ADAS
  SELECT 'concept:cruise-control' UNION ALL
  SELECT 'concept:parking-sensor' UNION ALL
  SELECT 'concept:reverse-camera' UNION ALL
  -- داشبورد
  SELECT 'concept:check-engine-light'
) p
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.obj_uid)
  AND NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.rel_uid = 'r:passengercar-has-' || REPLACE(p.obj_uid, 'concept:', ''));

-- =====================================================================
-- ۵. توربو — فقط برای passenger-car های توربو
-- =====================================================================
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
VALUES
('r:passengercar-has-turbo',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_part'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:passenger-car'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:turbocharger'),
 'asserted', 2);

-- =====================================================================
-- ۶. لاگ
-- =====================================================================
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v75_all_subsystems','Complete all 23 missing subsystems: ABS, transmission, cooling, exhaust, safety, comfort, ADAS, etc.');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- =====================================================================
-- گزارش
-- =====================================================================
SELECT 'entities' AS k, COUNT(*) AS n FROM e01_200_03_tb
UNION ALL SELECT 'relations', COUNT(*) FROM e01_222_01_tb;

SELECT '=== شمارش نهایی کلاس‌ها ===' AS section;
SELECT 
  src.ent_uid AS class,
  COUNT(*) AS n
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='has_part'
JOIN e01_200_03_tb src ON src.ent_id = r.subj_ent_id
WHERE src.ent_uid IN ('concept:vehicle','concept:passenger-car','concept:ev',
                      'concept:motorcycle','concept:truck','concept:bus')
GROUP BY src.ent_uid
ORDER BY n DESC;

SELECT '=== زیرسیستم‌های تازه ===' AS section;
SELECT 
  e.ent_uid AS concept,
  e.label,
  CASE WHEN e.ent_id IN (
    SELECT obj.ent_id FROM e01_222_01_tb r
    JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='has_part'
    JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
  ) THEN 'مضاف' ELSE 'یتیم' END AS status
FROM e01_200_03_tb e
WHERE e.ent_uid IN (
  'concept:abs-module','concept:abs-sensor','concept:transmission','concept:clutch',
  'concept:drive-shaft','concept:radiator','concept:water-pump','concept:thermostat',
  'concept:coolant-reservoir','concept:catalytic-converter','concept:muffler',
  'concept:exhaust-manifold','concept:airbag','concept:seatbelt','concept:seat',
  'concept:door','concept:window','concept:windshield','concept:mirror',
  'concept:fuel-tank','concept:wheel','concept:tire','concept:tpms-sensor',
  'concept:infotainment','concept:speaker','concept:cruise-control',
  'concept:parking-sensor','concept:reverse-camera','concept:turbocharger',
  'concept:check-engine-light'
)
ORDER BY status, e.ent_uid;
