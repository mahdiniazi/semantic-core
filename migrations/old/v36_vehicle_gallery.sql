-- v36 — گالری خودروها: پراید، ۲۰۶، دنا
.mode column
.headers on

BEGIN;

-- ========== ۱. انواع خودروی خاص ==========
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract) VALUES
('PassengerCar','خودرو سواری',0),
('Pride','پراید',0),
('Peugeot206','پژو ۲۰۶',0),
('Dena','دنا',0);

UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Vehicle')
  WHERE type_uid = 'PassengerCar';
UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='PassengerCar')
  WHERE type_uid IN ('Pride','Peugeot206','Dena');

-- ========== ۲. خودروهای نمونه ==========
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('vehicle:pride-1',
 (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Pride'),
 'instance','پراید','خودروی سواری پراید — موتور ۱.۳ لیتر',2),

('vehicle:206-1',
 (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Peugeot206'),
 'instance','پژو ۲۰۶','خودروی سواری پژو ۲۰۶ — موتور ۱.۴ لیتر',2),

('vehicle:dena-1',
 (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Dena'),
 'instance','دنا','خودروی سواری دنا — موتور ۱.۷ لیتر',2);

-- ========== ۳. قطعات مشترک (باتری) روی همه خودروها ==========
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('battery:pride-66ah',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='LeadAcidBattery'),'instance','باتری پراید','۶۶ آمپر',2),
('battery:206-60ah',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='LeadAcidBattery'),'instance','باتری ۲۰۶','۶۰ آمپر',2),
('battery:dena-74ah',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='LeadAcidBattery'),'instance','باتری دنا','۷۴ آمپر',2);

-- ========== ۴. قطعات اختصاصی ==========
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('ecu:pride-sagem',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='EngineECU'),'instance','ECU پراید ساگم','ECU موتور پراید',2),
('ecu:206-magneti',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='EngineECU'),'instance','ECU ۲۰۶ مگنتی مارلی','ECU موتور ۲۰۶',2),
('ecu:dena-mefi',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='EngineECU'),'instance','ECU دنا MEFI','ECU موتور دنا',2),

('coil:pride-double',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='IgnitionCoil'),'instance','کوئل پراید','کوئل دوبل',2),
('coil:206-double',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='IgnitionCoil'),'instance','کوئل ۲۰۶','کوئل دوبل',2),

('alternator:pride-70a',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='Alternator'),'instance','دینام پراید','۷۰ آمپر',2),
('alternator:206-90a',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='Alternator'),'instance','دینام ۲۰۶','۹۰ آمپر',2);

-- ========== ۵. نصب روی خودرو ==========
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id) VALUES
('r:battery-pride-installed',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='installed_on'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='battery:pride-66ah'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='vehicle:pride-1'),'asserted',2),
('r:battery-206-installed',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='installed_on'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='battery:206-60ah'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='vehicle:206-1'),'asserted',2),
('r:battery-dena-installed',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='installed_on'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='battery:dena-74ah'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='vehicle:dena-1'),'asserted',2),

('r:ecu-pride-installed',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='installed_on'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='ecu:pride-sagem'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='vehicle:pride-1'),'asserted',2),
('r:ecu-206-installed',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='installed_on'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='ecu:206-magneti'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='vehicle:206-1'),'asserted',2),
('r:ecu-dena-installed',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='installed_on'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='ecu:dena-mefi'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='vehicle:dena-1'),'asserted',2),

('r:coil-pride-installed',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='installed_on'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='coil:pride-double'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='vehicle:pride-1'),'asserted',2),
('r:coil-206-installed',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='installed_on'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='coil:206-double'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='vehicle:206-1'),'asserted',2),

('r:alternator-pride-installed',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='installed_on'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='alternator:pride-70a'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='vehicle:pride-1'),'asserted',2),
('r:alternator-206-installed',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='installed_on'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='alternator:206-90a'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='vehicle:206-1'),'asserted',2);

-- ========== ۶. باتری‌ها همگی از یک نوع ==========
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id) VALUES
('r:battery-pride-instance-of',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='instance_of'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='battery:pride-66ah'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='battery:generic'),'asserted',2),
('r:battery-206-instance-of',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='instance_of'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='battery:206-60ah'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='battery:generic'),'asserted',2),
('r:battery-dena-instance-of',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='instance_of'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='battery:dena-74ah'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='battery:generic'),'asserted',2);

-- ========== لاگ ==========
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v36_vehicle_gallery','Vehicle gallery: Pride, Peugeot 206, Dena + shared and specific components');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

SELECT 'entities' AS k, COUNT(*) AS n FROM e01_200_03_tb
UNION ALL SELECT 'vehicles', COUNT(*) FROM e01_200_03_tb WHERE ent_uid LIKE 'vehicle:%'
UNION ALL SELECT 'relations', COUNT(*) FROM e01_222_01_tb;
