-- v83.1 — رفع سه زیرسیستم ناقص
.mode column
.headers on

BEGIN;

-- ═══════════════════════════════════════════════════════
-- ۱. انواع جدید شبکه
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract) VALUES
('LINBus',             'شبکه LIN',         0),
('FlexRayBus',         'شبکه FlexRay',     0),
('AutomotiveEthernet', 'اترنت خودرویی',    0);

-- ═══════════════════════════════════════════════════════
-- ۲. مفاهیم جدید شبکه
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('concept:lin-bus',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='LINBus'),'concept','شبکه LIN','LIN bus',2),
('concept:flexray-bus',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='FlexRayBus'),'concept','شبکه FlexRay','FlexRay',2),
('concept:automotive-ethernet',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='AutomotiveEthernet'),'concept','اترنت خودرویی','Automotive Ethernet',2);

-- ═══════════════════════════════════════════════════════
-- ۳. اتصال شبکه‌ها به bus-subsystem
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
VALUES
('r:bus-subsystem-has-lin',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_part'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:bus-subsystem'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:lin-bus'),'asserted',2),
('r:bus-subsystem-has-flexray',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_part'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:bus-subsystem'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:flexray-bus'),'asserted',2),
('r:bus-subsystem-has-ethernet',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_part'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:bus-subsystem'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:automotive-ethernet'),'asserted',2);

-- ═══════════════════════════════════════════════════════
-- ۴. اتصال ignition-switch به starting
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
VALUES
('r:starting-subsystem-has-switch',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_part'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:starting-subsystem'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:ignition-switch'),'asserted',2);

-- ═══════════════════════════════════════════════════════
-- ۵. اتصال ECUهای تخصصی به ecu-subsystem
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:ecu-subsystem-has-' || REPLACE(p.part, 'concept:', ''),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_part'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:ecu-subsystem'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.part),
  'asserted', 2
FROM (
  SELECT 'concept:transmission-ecu' AS part UNION ALL
  SELECT 'concept:body-ecu' UNION ALL
  SELECT 'concept:abs-ecu'
) p
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.part)
  AND NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.rel_uid = 'r:ecu-subsystem-has-' || REPLACE(p.part, 'concept:', ''));

-- ═══════════════════════════════════════════════════════
-- ۶. لاگ
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v83.1_fix_three','Fixed three incomplete subsystems: starting, ecu, bus');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- ═══════════════════════════════════════════════════════
-- گزارش نهایی
-- ═══════════════════════════════════════════════════════
SELECT 'entities' AS k, COUNT(*) AS n FROM e01_200_03_tb
UNION ALL SELECT 'relations', COUNT(*) FROM e01_222_01_tb;

SELECT '=== شمارش نهایی ===' AS section;
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

SELECT '=== یتیم‌های واقعی (قطعه بدون زیرسیستم) ===' AS section;
SELECT 
  e.ent_uid AS orphan,
  t.type_uid AS type,
  e.label
FROM e01_200_03_tb e
JOIN e01_200_01_tb t ON t.type_id = e.type_id
WHERE e.ent_uid LIKE 'concept:%'
  AND t.type_uid NOT IN (
    'Vehicle','PassengerCar','Motorcycle','Truck','Bus','PickupTruck','Van',
    'ElectricVehicle','HybridVehicle','FireTruck','Ambulance','PoliceCar',
    'VehicleSystem','VehicleSubsystem','VehicleDomain','DomainController','EEArchitecture',
    'IranianManufacturer','KoreanManufacturer','JapaneseManufacturer',
    'GermanManufacturer','FrenchManufacturer','ChineseManufacturer',
    'AmericanManufacturer','ItalianManufacturer','BritishManufacturer',
    'CzechManufacturer','SpanishManufacturer','RussianManufacturer',
    'RomanianManufacturer','IndianManufacturer','EVManufacturer',
    'MotorcycleManufacturer','TruckManufacturer','BusManufacturer',
    'SpecialVehicleManufacturer'
  )
  AND e.ent_uid NOT IN (
    SELECT ent_uid FROM e01_200_03_tb WHERE ent_uid LIKE 'concept:%-subsystem'
  )
  AND e.ent_id NOT IN (
    SELECT obj.ent_id FROM e01_222_01_tb r
    JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid IN ('has_part','composed_of')
    JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
    WHERE r.status='asserted' AND r.superseded_at IS NULL
  )
ORDER BY t.type_uid, e.ent_uid;
