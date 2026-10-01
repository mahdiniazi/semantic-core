-- v29.5 — Seed new electrical entities
.mode column
.headers on

BEGIN;

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('battery:12v-66ah',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='LeadAcidBattery'), 'instance', 'باتری ۱۲V ۶۶Ah', 'باتری سربی-اسیدی معمول', 2),
('alternator:90a',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Alternator'),      'instance', 'دینام ۹۰ آمپر',    'دینام استاندارد',       2),
('starter:1.2kw',     (SELECT type_id FROM e01_200_01_tb WHERE type_uid='StarterMotor'),    'instance', 'استارت ۱.۲ کیلووات','استارت معمول',          2),
('coil:double',       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='IgnitionCoil'),    'instance', 'کوئل دوبل',        'کوئل دوبل انژکتوری',     2),
('ecu:engine-generic',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='EngineECU'),       'instance', 'ECU موتور',        'واحد کنترل موتور',       2),
('sensor:crankshaft', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='CrankshaftSensor'),'instance', 'سنسور دور موتور',  'سنسور میل‌لنگ',          2),
('sensor:o2',         (SELECT type_id FROM e01_200_01_tb WHERE type_uid='O2Sensor'),        'instance', 'سنسور اکسیژن',     'سنسور ترکیب سوخت',       2),
('sensor:coolant-temp',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='CoolantTempSensor'),'instance','سنسور دمای آب',   'سنسور خنک‌کننده',         2),
('injector:generic',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Injector'),        'instance', 'انژکتور',          'انژکتور بنزینی',         2),
('relay:main',        (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Relay'),           'instance', 'رله اصلی',         'رله مدار برق',           2),
('fuse:15a',          (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Fuse'),            'instance', 'فیوز ۱۵ آمپر',     'فیوز ۱۵ آمپری',          2),
('bus:can-500k',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='CANBus'),          'instance', 'CAN Bus 500kbps',  'شبکه CAN',               2),
('dtc:P0300',         (SELECT type_id FROM e01_200_01_tb WHERE type_uid='DTC'),             'concept',  'P0300',            'جرقه تصادفی',            2),
('fm:injector-clogged',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='FailureMode'),    'concept',  'گرفتگی انژکتور',   'گرفتگی نازل',            2);

INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v29.5_seed_new_entities', 'Seeded 14 new electrical entities');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

SELECT COUNT(*) AS total FROM e01_200_03_tb;
