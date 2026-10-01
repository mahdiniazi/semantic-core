-- v30.0 — روابط واقعی بین قطعات برقی
.mode column
.headers on

BEGIN;

INSERT OR IGNORE INTO e01_222_01_tb 
  (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
VALUES

-- ========== جریان برق ==========
('r:alternator-supplies-battery',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='supplies'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='alternator:90a'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='battery:12v-66ah'),
 'asserted', 2),

('r:battery-supplies-starter',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='supplies'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='battery:12v-66ah'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='starter:1.2kw'),
 'asserted', 2),

('r:battery-supplies-relay-main',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='supplies'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='battery:12v-66ah'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='relay:main'),
 'asserted', 2),

('r:relay-main-supplies-fuse',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='supplies'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='relay:main'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fuse:15a'),
 'asserted', 2),

('r:fuse-supplies-ecu',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='supplies'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fuse:15a'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='ecu:engine-generic'),
 'asserted', 2),

-- ========== کنترل ==========
('r:ecu-controls-coil',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='controls'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='ecu:engine-generic'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='coil:double'),
 'asserted', 2),

('r:ecu-controls-injector',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='controls'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='ecu:engine-generic'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='injector:generic'),
 'asserted', 2),

-- ========== انتقال سیگنال ==========
('r:crankshaft-transmits-ecu',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='transmits'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='sensor:crankshaft'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='ecu:engine-generic'),
 'asserted', 2),

('r:o2-transmits-ecu',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='transmits'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='sensor:o2'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='ecu:engine-generic'),
 'asserted', 2),

('r:coolant-temp-transmits-ecu',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='transmits'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='sensor:coolant-temp'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='ecu:engine-generic'),
 'asserted', 2),

-- ========== ارتباط شبکه‌ای ==========
('r:ecu-communicates-can',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='communicates_over'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='ecu:engine-generic'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='bus:can-500k'),
 'asserted', 2),

-- ========== حالت‌های خرابی ==========
('r:coil-has-fm-open',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_failure_mode'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='coil:double'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:coil-open'),
 'asserted', 2),

('r:coil-has-fm-short',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_failure_mode'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='coil:double'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:coil-short'),
 'asserted', 2),

('r:injector-has-fm-clogged',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_failure_mode'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='injector:generic'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:injector-clogged'),
 'asserted', 2),

-- ========== تبدیل خرابی به DTC ==========
('r:fm-open-manifests-p0301',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='manifests_as'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:coil-open'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='dtc:P0301'),
 'asserted', 2),

('r:fm-short-manifests-p0301',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='manifests_as'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:coil-short'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='dtc:P0301'),
 'asserted', 2),

('r:fm-clogged-manifests-p0300',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='manifests_as'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:injector-clogged'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='dtc:P0300'),
 'asserted', 2),

-- ========== گزارش خطا توسط ECU ==========
('r:ecu-reports-p0301',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='reports_dtc'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='ecu:engine-generic'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='dtc:P0301'),
 'asserted', 2);

INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v30.0_seed_relations', 'Seeded 18 real electrical relations');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

SELECT COUNT(*) AS total_relations FROM e01_222_01_tb;
