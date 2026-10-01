-- v77 — رفع رابطه‌ی اشتباه seat
.mode column
.headers on

BEGIN;

-- =====================================================================
-- ۱. اصلاح رابطه vehicle → seat
-- =====================================================================
UPDATE e01_222_01_tb
SET obj_ent_id = (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:seat')
WHERE rel_uid = 'r:vehicle-has-seat';

-- =====================================================================
-- ۲. بررسی یتیم‌های باقی‌مانده در کل
-- =====================================================================
SELECT '=== یتیم‌های باقی‌مانده ===' AS section;
SELECT 
  e.ent_uid AS orphan,
  t.type_uid AS type,
  e.label
FROM e01_200_03_tb e
JOIN e01_200_01_tb t ON t.type_id = e.type_id
WHERE e.ent_uid LIKE 'concept:%'
  AND t.type_uid NOT LIKE '%Manufacturer'
  AND t.type_uid NOT IN ('Vehicle','PassengerCar','Motorcycle','Truck','Bus',
                          'ElectricVehicle','HybridVehicle','PickupTruck','Van',
                          'FireTruck','Ambulance','SpecialVehicle','PoliceCar',
                          'Taxi','GarbageTruck','TowTruck','RefrigeratedTruck','TankerTruck')
  AND e.ent_id NOT IN (
    SELECT obj.ent_id FROM e01_222_01_tb r
    JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid IN ('has_part','composed_of')
    JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
  )
ORDER BY t.type_uid, e.ent_uid;

-- =====================================================================
-- ۳. لاگ
-- =====================================================================
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v77_fix_seat_relation','Fixed vehicle has_part seat relation pointing to wrong entity');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- =====================================================================
-- گزارش نهایی
-- =====================================================================
SELECT 'entities' AS k, COUNT(*) AS n FROM e01_200_03_tb
UNION ALL SELECT 'relations', COUNT(*) FROM e01_222_01_tb;

SELECT '=== بررسی نهایی صندلی ===' AS section;
SELECT 
  e.ent_uid,
  e.label,
  t.type_uid AS type,
  CASE WHEN e.ent_id IN (
    SELECT obj.ent_id FROM e01_222_01_tb r
    JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='has_part'
    JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
  ) THEN 'مضاف' ELSE 'یتیم' END AS status
FROM e01_200_03_tb e
JOIN e01_200_01_tb t ON t.type_id = e.type_id
WHERE e.ent_uid IN ('concept:seat','concept:seat-brand');
