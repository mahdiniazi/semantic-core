-- v37 — تکمیل گالری: قطعات مشترک روی همه خودروها
.mode column
.headers on

BEGIN;

-- ========== ۱. برای پراید ==========
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('starter:pride-1kw',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='StarterMotor'),'instance','استارت پراید','۱ کیلووات',2),
('sensor:pride-crank',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='CrankshaftSensor'),'instance','سنسور دور موتور پراید','میل‌لنگ',2),
('sensor:pride-o2',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='O2Sensor'),'instance','سنسور اکسیژن پراید','بالادست',2),
('sensor:pride-coolant',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='CoolantTempSensor'),'instance','سنسور دمای پراید','آب',2),
('sensor:pride-maf',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='MassAirFlowSensor'),'instance','MAF پراید','دبی هوا',2),
('injector:pride-1',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='Injector'),'instance','انژکتور پراید ۱','سیلندر ۱',2),
('relay:pride-main',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='Relay'),'instance','رله اصلی پراید','رله',2),
('fuse:pride-15a',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='Fuse'),'instance','فیوز پراید','۱۵ آمپر',2),
('bus:pride-can',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='CANBus'),'instance','CAN پراید','شبکه',2);

-- ========== ۲. برای ۲۰۶ ==========
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('starter:206-1.4kw',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='StarterMotor'),'instance','استارت ۲۰۶','۱.۴ کیلووات',2),
('sensor:206-crank',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='CrankshaftSensor'),'instance','سنسور دور موتور ۲۰۶','میل‌لنگ',2),
('sensor:206-o2',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='O2Sensor'),'instance','سنسور اکسیژن ۲۰۶','بالادست',2),
('sensor:206-coolant',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='CoolantTempSensor'),'instance','سنسور دمای ۲۰۶','آب',2),
('sensor:206-maf',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='MassAirFlowSensor'),'instance','MAF ۲۰۶','دبی هوا',2),
('injector:206-1',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='Injector'),'instance','انژکتور ۲۰۶ ۱','سیلندر ۱',2),
('relay:206-main',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='Relay'),'instance','رله اصلی ۲۰۶','رله',2),
('fuse:206-15a',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='Fuse'),'instance','فیوز ۲۰۶','۱۵ آمپر',2),
('bus:206-can',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='CANBus'),'instance','CAN ۲۰۶','شبکه',2);

-- ========== ۳. برای دنا ==========
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('starter:dena-1.4kw',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='StarterMotor'),'instance','استارت دنا','۱.۴ کیلووات',2),
('sensor:dena-crank',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='CrankshaftSensor'),'instance','سنسور دور موتور دنا','میل‌لنگ',2),
('sensor:dena-o2',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='O2Sensor'),'instance','سنسور اکسیژن دنا','بالادست',2),
('sensor:dena-coolant',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='CoolantTempSensor'),'instance','سنسور دمای دنا','آب',2),
('sensor:dena-maf',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='MassAirFlowSensor'),'instance','MAF دنا','دبی هوا',2),
('injector:dena-1',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='Injector'),'instance','انژکتور دنا ۱','سیلندر ۱',2),
('relay:dena-main',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='Relay'),'instance','رله اصلی دنا','رله',2),
('fuse:dena-15a',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='Fuse'),'instance','فیوز دنا','۱۵ آمپر',2),
('bus:dena-can',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='CANBus'),'instance','CAN دنا','شبکه',2);

-- ========== ۴. نصب همه روی خودروهای مربوطه ==========
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || e.ent_uid || '-installed',
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='installed_on'),
  e.ent_id,
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid = 
    CASE 
      WHEN e.ent_uid LIKE '%-pride-%' OR e.ent_uid LIKE 'pride-%' THEN 'vehicle:pride-1'
      WHEN e.ent_uid LIKE '%-206-%' OR e.ent_uid LIKE '206-%' THEN 'vehicle:206-1'
      WHEN e.ent_uid LIKE '%-dena-%' OR e.ent_uid LIKE 'dena-%' THEN 'vehicle:dena-1'
    END),
  'asserted', 2
FROM e01_200_03_tb e
WHERE e.ent_uid IN (
  'starter:pride-1kw','sensor:pride-crank','sensor:pride-o2','sensor:pride-coolant','sensor:pride-maf','injector:pride-1','relay:pride-main','fuse:pride-15a','bus:pride-can',
  'starter:206-1.4kw','sensor:206-crank','sensor:206-o2','sensor:206-coolant','sensor:206-maf','injector:206-1','relay:206-main','fuse:206-15a','bus:206-can',
  'starter:dena-1.4kw','sensor:dena-crank','sensor:dena-o2','sensor:dena-coolant','sensor:dena-maf','injector:dena-1','relay:dena-main','fuse:dena-15a','bus:dena-can'
);

-- ========== ۵. اتصال به نوع کلی ==========
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || e.ent_uid || '-instance-of',
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='instance_of'),
  e.ent_id,
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='battery:generic'),
  'asserted', 2
FROM e01_200_03_tb e
WHERE e.ent_uid LIKE 'battery:%'
  AND e.ent_uid <> 'battery:generic';

INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v37_complete_gallery','Completed vehicle gallery with shared electrical components');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- ========== گزارش ==========
SELECT 'entities' AS k, COUNT(*) AS n FROM e01_200_03_tb
UNION ALL SELECT 'relations', COUNT(*) FROM e01_222_01_tb;

SELECT '=== خودروها ===' AS section;
SELECT 
  v.ent_uid AS vehicle,
  COUNT(r.rel_id) AS n_components
FROM e01_200_03_tb v
LEFT JOIN e01_222_01_tb r ON r.obj_ent_id = v.ent_id
  AND r.reltype_id = (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='installed_on')
WHERE v.ent_uid LIKE 'vehicle:%'
GROUP BY v.ent_id
ORDER BY v.ent_uid;
