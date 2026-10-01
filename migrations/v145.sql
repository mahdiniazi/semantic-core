.mode column
.headers on

BEGIN;

-- ═══ گپ ۱: افزودن FMهای open/short به role:actuator ═══
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id) VALUES
('r:actuator-fm-open',  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_failure_mode'), (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='role:actuator'), (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:generic-open'),  'asserted', 2),
('r:actuator-fm-short', (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_failure_mode'), (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='role:actuator'), (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:generic-short'), 'asserted', 2),
('r:actuator-fm-worn',  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_failure_mode'), (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='role:actuator'), (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:generic-worn'),  'asserted', 2);

-- ═══ گپ ۳: بازآرایی نقش ignition-coil از actuator به switch-power ═══
DELETE FROM e01_222_01_tb 
WHERE reltype_id = (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='plays_role')
  AND subj_ent_id = (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:ignition-coil');

INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id) VALUES
('r:ignition-coil-plays-switch-power',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='plays_role'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:ignition-coil'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='role:switch-power'),
 'asserted', 2);

-- ═══ گپ ۲: حذف is_aهای غلط از FM به DTC ═══
DELETE FROM e01_222_01_tb
WHERE reltype_id = (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a')
  AND subj_ent_id IN (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid LIKE 'fm:%' AND ent_uid NOT LIKE 'fm:generic-%')
  AND obj_ent_id IN (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid LIKE 'dtc:%');

-- ═══ log + bump ═══
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v145_fix_role_gaps', 'Fixed actuator FM, ignition-coil role, is_a overload');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- ═══ POST-CHECK ═══
SELECT 'actuator_fms' AS metric, COUNT(*) AS n FROM e01_222_01_tb r JOIN e01_202_01_tb rt ON rt.reltype_id=r.reltype_id WHERE rt.type_uid='has_failure_mode' AND r.subj_ent_id=(SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='role:actuator')
UNION ALL SELECT 'coil_role', COUNT(*) FROM e01_222_01_tb r JOIN e01_202_01_tb rt ON rt.reltype_id=r.reltype_id WHERE rt.type_uid='plays_role' AND r.subj_ent_id=(SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:ignition-coil')
UNION ALL SELECT 'fm_dtc_is_a', COUNT(*) FROM e01_222_01_tb r JOIN e01_202_01_tb rt ON rt.reltype_id=r.reltype_id WHERE rt.type_uid='is_a' AND r.subj_ent_id IN (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid LIKE 'fm:%') AND r.obj_ent_id IN (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid LIKE 'dtc:%');

SELECT '' AS x;
SELECT severity, COUNT(*) AS n FROM e04_900_02_vw GROUP BY severity;
