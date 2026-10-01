-- v31.0 — افزودن خودرو و اتصال قطعات به آن
.mode column
.headers on

BEGIN;

-- ========== خودرو نمونه ==========
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id)
VALUES
('vehicle:sample-1',
 (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Vehicle'),
 'instance', 'خودروی نمونه', 'خودروی سواری نمونه با موتور بنزینی', 2);

-- ========== اتصال قطعات به خودرو ==========
INSERT OR IGNORE INTO e01_222_01_tb 
  (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
VALUES

('r:vehicle-installed-battery',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='installed_on'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='battery:12v-66ah'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='vehicle:sample-1'),
 'asserted', 2),

('r:vehicle-installed-alternator',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='installed_on'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='alternator:90a'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='vehicle:sample-1'),
 'asserted', 2),

('r:vehicle-installed-starter',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='installed_on'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='starter:1.2kw'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='vehicle:sample-1'),
 'asserted', 2),

('r:vehicle-installed-ecu',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='installed_on'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='ecu:engine-generic'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='vehicle:sample-1'),
 'asserted', 2),

('r:vehicle-installed-coil',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='installed_on'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='coil:double'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='vehicle:sample-1'),
 'asserted', 2),

('r:vehicle-installed-injector',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='installed_on'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='injector:generic'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='vehicle:sample-1'),
 'asserted', 2),

('r:vehicle-installed-canbus',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='installed_on'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='bus:can-500k'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='vehicle:sample-1'),
 'asserted', 2);

INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v31.0_add_vehicle', 'Added sample vehicle + 7 installed_on relations');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

SELECT COUNT(*) AS total_entities FROM e01_200_03_tb;
SELECT COUNT(*) AS total_relations FROM e01_222_01_tb;
