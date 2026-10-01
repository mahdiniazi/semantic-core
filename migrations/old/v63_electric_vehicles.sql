-- v63 — خودروهای برقی
.mode column
.headers on

BEGIN;

-- =====================================================================
-- ۱. شاخه EV
-- =====================================================================
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract) VALUES
('ElectricVehicle',    'خودروی برقی',        1),
('BatteryElectricVehicle','خودروی تمام برقی',0),
('HybridVehicle',      'خودروی هیبرید',      1),
('PlugInHybrid',       'هیبرید پلاگ‌این',    0),
('MildHybrid',         'هیبرید ملایم',       0),
('FuelCellVehicle',    'خودروی سلول سوختی',  0);

UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Vehicle')
  WHERE type_uid = 'ElectricVehicle';
UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='ElectricVehicle')
  WHERE type_uid IN ('BatteryElectricVehicle','HybridVehicle','FuelCellVehicle');
UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='HybridVehicle')
  WHERE type_uid IN ('PlugInHybrid','MildHybrid');

-- =====================================================================
-- ۲. قطعات EV
-- =====================================================================
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract) VALUES
('TractionMotor',       'موتور کششی',          0),
('Inverter',            'اینورتر',             0),
('BatteryPack',         'پک باتری',            0),
('BatteryModule',       'ماژول باتری',         0),
('BatteryCell',         'سلول باتری',          0),
('OnboardCharger',      'شارژر داخلی',         0),
('ChargingPort',        'پورت شارژ',           0),
('BMS',                 'مدیر باتری BMS',      0),
('DCDCConverter',       'مبدل DC/DC',          0),
('RegenerativeBrake',   'ترمز بازیابی',        0),
('ThermalManagement',   'مدیریت حرارتی',       0),
('HighVoltageCable',    'کابل فشار قوی',       0);

-- =====================================================================
-- ۳. مفاهیم قطعات EV
-- =====================================================================
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('concept:traction-motor',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='TractionMotor'),'concept','موتور کششی','موتور برقی خودرو',2),
('concept:inverter',          (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Inverter'),'concept','اینورتر','تبدیل DC به AC',2),
('concept:battery-pack',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='BatteryPack'),'concept','پک باتری','باتری ولتاژ بالا',2),
('concept:battery-module',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='BatteryModule'),'concept','ماژول باتری','ماژول داخل پک',2),
('concept:battery-cell',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='BatteryCell'),'concept','سلول باتری','سلول لیتیوم-یونی',2),
('concept:onboard-charger',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='OnboardCharger'),'concept','شارژر داخلی','شارژر AC داخلی',2),
('concept:charging-port',     (SELECT type_id FROM e01_200_01_tb WHERE type_uid='ChargingPort'),'concept','پورت شارژ','محل اتصال کابل',2),
('concept:bms',               (SELECT type_id FROM e01_200_01_tb WHERE type_uid='BMS'),'concept','BMS','مدیریت باتری',2),
('concept:dcdc',              (SELECT type_id FROM e01_200_01_tb WHERE type_uid='DCDCConverter'),'concept','مبدل DC/DC','کاهش ولتاژ بالا به ۱۲V',2),
('concept:regen-brake',       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='RegenerativeBrake'),'concept','ترمز بازیابی','تبدیل ترمز به برق',2),
('concept:thermal-mgmt',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='ThermalManagement'),'concept','مدیریت حرارتی','خنک‌کننده باتری',2),
('concept:hv-cable',          (SELECT type_id FROM e01_200_01_tb WHERE type_uid='HighVoltageCable'),'concept','کابل فشار قوی','سیم ولتاژ بالا',2);

-- =====================================================================
-- ۴. مفهوم خودروی برقی (کلاس مشترک)
-- =====================================================================
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('concept:ev', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='ElectricVehicle'),'concept','خودروی برقی','هر خودروی برقی',2);

INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
VALUES
('r:ev-is-a-vehicle',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:ev'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:vehicle'),
 'asserted', 2);

-- =====================================================================
-- ۵. قطعات EV مشترک (has_part از concept:ev)
-- =====================================================================
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:ev-has-' || REPLACE(p.obj_uid, 'concept:', ''),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_part'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:ev'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.obj_uid),
  'asserted', 2
FROM (
  SELECT 'concept:traction-motor' AS obj_uid UNION ALL
  SELECT 'concept:inverter' UNION ALL
  SELECT 'concept:battery-pack' UNION ALL
  SELECT 'concept:onboard-charger' UNION ALL
  SELECT 'concept:charging-port' UNION ALL
  SELECT 'concept:bms' UNION ALL
  SELECT 'concept:dcdc' UNION ALL
  SELECT 'concept:regen-brake' UNION ALL
  SELECT 'concept:thermal-mgmt' UNION ALL
  SELECT 'concept:hv-cable' UNION ALL
  -- قطعات مشترک با خودروی سواری
  SELECT 'concept:can-bus' UNION ALL
  SELECT 'concept:brake-master' UNION ALL
  SELECT 'concept:brake-disc' UNION ALL
  SELECT 'concept:brake-pad' UNION ALL
  SELECT 'concept:steering-wheel' UNION ALL
  SELECT 'concept:steering-rack' UNION ALL
  SELECT 'concept:power-steering' UNION ALL
  SELECT 'concept:shock-absorber' UNION ALL
  SELECT 'concept:coil-spring' UNION ALL
  SELECT 'concept:ac-compressor' UNION ALL
  SELECT 'concept:blower-motor' UNION ALL
  SELECT 'concept:cabin-filter'
) p
WHERE NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.rel_uid = 'r:ev-has-' || REPLACE(p.obj_uid, 'concept:', ''));

-- =====================================================================
-- ۶. سازندگان EV
-- =====================================================================
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract) VALUES
('EVManufacturer', 'سازنده خودروی برقی', 1);

UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Manufacturer')
  WHERE type_uid = 'EVManufacturer';

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('concept:tesla',         (SELECT type_id FROM e01_200_01_tb WHERE type_uid='EVManufacturer'),'concept','تسلا','Tesla',2),
('concept:nio',           (SELECT type_id FROM e01_200_01_tb WHERE type_uid='EVManufacturer'),'concept','نیو','NIO',2),
('concept:rivian',        (SELECT type_id FROM e01_200_01_tb WHERE type_uid='EVManufacturer'),'concept','ریوین','Rivian',2),
('concept:lucid',         (SELECT type_id FROM e01_200_01_tb WHERE type_uid='EVManufacturer'),'concept','لوسید','Lucid Motors',2),
('concept:polestar',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='EVManufacturer'),'concept','پولستار','Polestar',2),
('concept:xpeng',         (SELECT type_id FROM e01_200_01_tb WHERE type_uid='EVManufacturer'),'concept','XPeng','XPeng',2);

-- =====================================================================
-- ۷. مدل‌های EV
-- =====================================================================
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract) VALUES
('TeslaModel3',      'تسلا مدل ۳',      0),
('TeslaModelY',      'تسلا مدل Y',      0),
('TeslaModelS',      'تسلا مدل S',      0),
('TeslaModelX',      'تسلا مدل X',      0),
('NissanLeaf',       'نیسان لیف',       0),
('ChevroletBolt',    'شورولت بولت',     0),
('HyundaiIoniq5',    'هیوندای آیونیک ۵',0),
('KiaEV6',           'کیا EV6',         0),
('BYDHan',           'BYD هان',         0),
('NIOSUV',           'نیو SUV',         0),
('XpengP7',          'XPeng P7',        0);

UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='BatteryElectricVehicle')
  WHERE type_uid IN ('TeslaModel3','TeslaModelY','TeslaModelS','TeslaModelX',
                     'NissanLeaf','ChevroletBolt','HyundaiIoniq5','KiaEV6',
                     'BYDHan','NIOSUV','XpengP7');

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('concept:tesla-model-3',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='TeslaModel3'),'concept','تسلا مدل ۳','Tesla Model 3',2),
('concept:tesla-model-y',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='TeslaModelY'),'concept','تسلا مدل Y','Tesla Model Y',2),
('concept:tesla-model-s',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='TeslaModelS'),'concept','تسلا مدل S','Tesla Model S',2),
('concept:tesla-model-x',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='TeslaModelX'),'concept','تسلا مدل X','Tesla Model X',2),
('concept:nissan-leaf',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='NissanLeaf'),'concept','نیسان لیف','Nissan Leaf',2),
('concept:chevrolet-bolt',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='ChevroletBolt'),'concept','شورولت بولت','Chevrolet Bolt',2),
('concept:hyundai-ioniq-5',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='HyundaiIoniq5'),'concept','هیوندای آیونیک ۵','Hyundai Ioniq 5',2),
('concept:kia-ev6',          (SELECT type_id FROM e01_200_01_tb WHERE type_uid='KiaEV6'),'concept','کیا EV6','Kia EV6',2),
('concept:byd-han',          (SELECT type_id FROM e01_200_01_tb WHERE type_uid='BYDHan'),'concept','BYD هان','BYD Han',2),
('concept:nio-suv',          (SELECT type_id FROM e01_200_01_tb WHERE type_uid='NIOSUV'),'concept','نیو SUV','NIO SUV',2),
('concept:xpeng-p7',         (SELECT type_id FROM e01_200_01_tb WHERE type_uid='XpengP7'),'concept','XPeng P7','XPeng P7',2);

-- is_a
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || REPLACE(p.sub_uid, ':', '-') || '-is-a',
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.sub_uid),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:ev'),
  'asserted', 2
FROM (
  SELECT 'concept:tesla-model-3' AS sub_uid UNION ALL
  SELECT 'concept:tesla-model-y' UNION ALL
  SELECT 'concept:tesla-model-s' UNION ALL
  SELECT 'concept:tesla-model-x' UNION ALL
  SELECT 'concept:nissan-leaf' UNION ALL
  SELECT 'concept:chevrolet-bolt' UNION ALL
  SELECT 'concept:hyundai-ioniq-5' UNION ALL
  SELECT 'concept:kia-ev6' UNION ALL
  SELECT 'concept:byd-han' UNION ALL
  SELECT 'concept:nio-suv' UNION ALL
  SELECT 'concept:xpeng-p7'
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
  SELECT 'concept:tesla-model-3' AS product, 'concept:tesla' AS maker UNION ALL
  SELECT 'concept:tesla-model-y',              'concept:tesla' UNION ALL
  SELECT 'concept:tesla-model-s',              'concept:tesla' UNION ALL
  SELECT 'concept:tesla-model-x',              'concept:tesla' UNION ALL
  SELECT 'concept:nissan-leaf',                'concept:nissan' UNION ALL
  SELECT 'concept:chevrolet-bolt',             'concept:chevrolet' UNION ALL
  SELECT 'concept:hyundai-ioniq-5',            'concept:hyundai' UNION ALL
  SELECT 'concept:kia-ev6',                    'concept:kia' UNION ALL
  SELECT 'concept:byd-han',                    'concept:byd' UNION ALL
  SELECT 'concept:nio-suv',                    'concept:nio' UNION ALL
  SELECT 'concept:xpeng-p7',                   'concept:xpeng'
) p
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.product)
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.maker)
  AND NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.rel_uid = 'r:' || REPLACE(p.product, ':', '-') || '-by-' || REPLACE(p.maker, ':', '-'));

INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v63_electric_vehicles','EV: 6 manufacturers, 11 models + EV-specific parts');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

SELECT 'entities' AS k, COUNT(*) AS n FROM e01_200_03_tb
UNION ALL SELECT 'relations', COUNT(*) FROM e01_222_01_tb;

SELECT '=== خودروهای برقی ===' AS section;
SELECT 
  p.label AS model,
  m.label AS maker
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='manufactured_by'
JOIN e01_200_03_tb p ON p.ent_id = r.subj_ent_id
JOIN e01_200_03_tb m ON m.ent_id = r.obj_ent_id
WHERE m.type_id IN (SELECT type_id FROM e01_200_01_tb WHERE type_uid='EVManufacturer')
   OR m.ent_uid IN ('concept:nissan','concept:chevrolet','concept:hyundai','concept:kia','concept:byd')
ORDER BY m.ent_uid, p.ent_uid;
