-- v62 — خودروهای ویژه: ون، آمبولانس، آتش‌نشانی، پلیس، تاکسی، ...
.mode column
.headers on

BEGIN;

-- =====================================================================
-- ۱. انواع خودروی ویژه
-- =====================================================================
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract) VALUES
('PoliceCar',        'خودروی پلیس',         0),
('Taxi',             'تاکسی',               0),
('GarbageTruck',     'خودروی زباله',        0),
('TowTruck',         'خودروی یدک‌کش',       0),
('DeliveryVan',      'ون تحویل',            0),
('PassengerVan',     'ون مسافربری',         0),
('RefrigeratedTruck','کامیون یخچال‌دار',    0),
('TankerTruck',      'تانکر',               0),
('BusFireTruck',     'آتش‌نشانی سنگین',     0),
('RescueVehicle',    'خودروی امداد',        0);

UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='SpecialVehicle')
  WHERE type_uid IN ('PoliceCar','Taxi','TowTruck','RescueVehicle');
UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Van')
  WHERE type_uid IN ('DeliveryVan','PassengerVan');
UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Truck')
  WHERE type_uid IN ('GarbageTruck','RefrigeratedTruck','TankerTruck');
UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='FireTruck')
  WHERE type_uid = 'BusFireTruck';

-- =====================================================================
-- ۲. مفاهیم جدید
-- =====================================================================
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('concept:police',       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='PoliceCar'),'concept','خودروی پلیس','هر خودروی پلیس',2),
('concept:taxi',         (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Taxi'),'concept','تاکسی','هر تاکسی',2),
('concept:garbage-truck',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='GarbageTruck'),'concept','خودروی زباله','هر کامیون جمع‌آوری زباله',2),
('concept:tow-truck',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='TowTruck'),'concept','یدک‌کش','هر خودروی یدک‌کش',2),
('concept:delivery-van', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='DeliveryVan'),'concept','ون تحویل','هر ون باربری',2),
('concept:passenger-van',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='PassengerVan'),'concept','ون مسافربری','هر ون مسافری',2),
('concept:tanker',       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='TankerTruck'),'concept','تانکر','هر کامیون تانکر',2),
('concept:rescue',       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='RescueVehicle'),'concept','خودروی امداد','هر خودروی امدادی',2),
('concept:bus-fire-truck',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='BusFireTruck'),'concept','آتش‌نشانی سنگین','آتش‌نشانی با نردبان',2);

-- is_a
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || REPLACE(p.sub_uid, ':', '-') || '-is-a',
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.sub_uid),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.obj_uid),
  'asserted', 2
FROM (
  SELECT 'concept:police' AS sub_uid, 'concept:vehicle' AS obj_uid UNION ALL
  SELECT 'concept:taxi', 'concept:passenger-car' UNION ALL
  SELECT 'concept:garbage-truck', 'concept:truck' UNION ALL
  SELECT 'concept:tow-truck', 'concept:truck' UNION ALL
  SELECT 'concept:delivery-van', 'concept:van' UNION ALL
  SELECT 'concept:passenger-van', 'concept:van' UNION ALL
  SELECT 'concept:tanker', 'concept:truck' UNION ALL
  SELECT 'concept:rescue', 'concept:vehicle' UNION ALL
  SELECT 'concept:bus-fire-truck', 'concept:fire-truck'
) p
WHERE NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.rel_uid = 'r:' || REPLACE(p.sub_uid, ':', '-') || '-is-a');

-- =====================================================================
-- ۳. قطعات اضافه‌شده ویژه
-- =====================================================================
-- انواع جدید قطعات
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract) VALUES
('WarningLight',     'چراغ هشدار',          0),
('Siren',            'آژیر',                0),
('HydraulicLift',    'بالابر هیدرولیک',     0),
('WheelchairRamp',   'رمپ ویلچر',          0),
('FirePump',         'پمپ آتش‌نشانی',       0),
('Ladder',           'نردبان',              0),
('Reefer',           'یخچال کامیون',        0),
('Tank',             'تانک',                0);

-- مفاهیم قطعات
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('concept:warning-light',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='WarningLight'),'concept','چراغ هشدار','چراغ گردان هشدار',2),
('concept:siren',           (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Siren'),'concept','آژیر','آژیر هشدار',2),
('concept:hydraulic-lift',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='HydraulicLift'),'concept','بالابر هیدرولیک','بالابر یدک‌کش یا زباله',2),
('concept:wheelchair-ramp', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='WheelchairRamp'),'concept','رمپ ویلچر','رمپ آمبولانس',2),
('concept:fire-pump',       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='FirePump'),'concept','پمپ آتش‌نشانی','پمپ آب آتش‌نشانی',2),
('concept:ladder',          (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Ladder'),'concept','نردبان','نردبان آتش‌نشانی',2),
('concept:reefer',          (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Reefer'),'concept','یخچال','سیستم تبرید کامیون',2),
('concept:tank',            (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Tank'),'concept','تانک','مخزن تانکر',2);

-- has_part برای انواع ویژه
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || REPLACE(p.sub_uid, ':', '-') || '-has-' || REPLACE(p.obj_uid, 'concept:', ''),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_part'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.sub_uid),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.obj_uid),
  'asserted', 2
FROM (
  -- آمبولانس
  SELECT 'concept:ambulance' AS sub_uid, 'concept:warning-light' AS obj_uid UNION ALL
  SELECT 'concept:ambulance', 'concept:siren' UNION ALL
  SELECT 'concept:ambulance', 'concept:wheelchair-ramp' UNION ALL
  -- آتش‌نشانی
  SELECT 'concept:fire-truck', 'concept:warning-light' UNION ALL
  SELECT 'concept:fire-truck', 'concept:siren' UNION ALL
  SELECT 'concept:fire-truck', 'concept:fire-pump' UNION ALL
  SELECT 'concept:fire-truck', 'concept:tank' UNION ALL
  SELECT 'concept:bus-fire-truck', 'concept:ladder' UNION ALL
  -- پلیس
  SELECT 'concept:police', 'concept:warning-light' UNION ALL
  SELECT 'concept:police', 'concept:siren' UNION ALL
  -- یدک‌کش
  SELECT 'concept:tow-truck', 'concept:hydraulic-lift' UNION ALL
  -- زباله
  SELECT 'concept:garbage-truck', 'concept:hydraulic-lift' UNION ALL
  -- تانکر
  SELECT 'concept:tanker', 'concept:tank' UNION ALL
  -- یخچال‌دار
  SELECT 'concept:bus' /* placeholder */, 'concept:tank'
) p
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.sub_uid)
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.obj_uid)
  AND NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.rel_uid = 'r:' || REPLACE(p.sub_uid, ':', '-') || '-has-' || REPLACE(p.obj_uid, 'concept:', ''));

-- =====================================================================
-- ۴. سازندگان خودروهای ویژه
-- =====================================================================
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract) VALUES
('SpecialVehicleManufacturer', 'سازنده خودروی ویژه', 1);

UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Manufacturer')
  WHERE type_uid = 'SpecialVehicleManufacturer';

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
-- جهانی
('concept:mercedes-special',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='SpecialVehicleManufacturer'),'concept','مرسدس ویژه','Mercedes-Benz Special Vehicles',2),
('concept:iveco-special',     (SELECT type_id FROM e01_200_01_tb WHERE type_uid='SpecialVehicleManufacturer'),'concept','ایوکو ویژه','Iveco Special',2),
('concept:man-special',       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='SpecialVehicleManufacturer'),'concept','MAN ویژه','MAN Special',2),
('concept:ford-special',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='SpecialVehicleManufacturer'),'concept','فورد ویژه','Ford Special',2),
-- ایرانی
('concept:khavar',            (SELECT type_id FROM e01_200_01_tb WHERE type_uid='SpecialVehicleManufacturer'),'concept','خاور','Khavar',2),
('concept:zamyad',            (SELECT type_id FROM e01_200_01_tb WHERE type_uid='SpecialVehicleManufacturer'),'concept','زمیاد','Zamyad',2),
('concept:saipa-diesel-special',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='SpecialVehicleManufacturer'),'concept','سایپا دیزل ویژه','Saipa Diesel Special',2);

-- =====================================================================
-- ۵. مدل‌های ویژه
-- =====================================================================
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract) VALUES
('Sprinter',           'اسپرینتر',           0),
('Daily',              'دیلی',               0),
('ZamyadZ24',          'زمیاد Z24',          0),
('Khavar',             'خاور',               0),
('PeugeotBoxer',       'پژو باکسر',          0),
('FiatDucato',         'فیات دوکاتو',        0);

UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='DeliveryVan')
  WHERE type_uid IN ('Sprinter','Daily','PeugeotBoxer','FiatDucato');
UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='PickupTruck')
  WHERE type_uid IN ('ZamyadZ24','Khavar');

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('concept:sprinter',     (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Sprinter'),'concept','مرسدس اسپرینتر','Mercedes Sprinter Van',2),
('concept:daily',        (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Daily'),'concept','ایوکو دیلی','Iveco Daily Van',2),
('concept:zamyad-z24',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='ZamyadZ24'),'concept','زمیاد Z24','Zamyad Z24',2),
('concept:khavar-van',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Khavar'),'concept','خاور','Khavar Truck',2),
('concept:boxer',        (SELECT type_id FROM e01_200_01_tb WHERE type_uid='PeugeotBoxer'),'concept','پژو باکسر','Peugeot Boxer Van',2),
('concept:ducato',       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='FiatDucato'),'concept','فیات دوکاتو','Fiat Ducato',2);

-- is_a
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || REPLACE(p.sub_uid, ':', '-') || '-is-a',
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.sub_uid),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.obj_uid),
  'asserted', 2
FROM (
  SELECT 'concept:sprinter' AS sub_uid, 'concept:delivery-van' AS obj_uid UNION ALL
  SELECT 'concept:daily', 'concept:delivery-van' UNION ALL
  SELECT 'concept:boxer', 'concept:delivery-van' UNION ALL
  SELECT 'concept:ducato', 'concept:delivery-van' UNION ALL
  SELECT 'concept:zamyad-z24', 'concept:pickup' UNION ALL
  SELECT 'concept:khavar-van', 'concept:pickup'
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
  SELECT 'concept:sprinter' AS product, 'concept:mercedes-special' AS maker UNION ALL
  SELECT 'concept:daily', 'concept:iveco-special' UNION ALL
  SELECT 'concept:zamyad-z24', 'concept:zamyad' UNION ALL
  SELECT 'concept:khavar-van', 'concept:zamyad' UNION ALL
  SELECT 'concept:boxer', 'concept:peugeot' UNION ALL
  SELECT 'concept:ducato', 'concept:iveco-special'
) p
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.product)
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.maker)
  AND NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.rel_uid = 'r:' || REPLACE(p.product, ':', '-') || '-by-' || REPLACE(p.maker, ':', '-'));

INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v62_special_vehicles','Special vehicles: police, taxi, ambulance, fire, van, tow, garbage, tanker');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

SELECT 'entities' AS k, COUNT(*) AS n FROM e01_200_03_tb
UNION ALL SELECT 'relations', COUNT(*) FROM e01_222_01_tb;
