-- v81.1 — اتصال DCUها به ECUهای تخصصی
.mode column
.headers on

BEGIN;

-- ═══════════════════════════════════════════════════════
-- ۱. بررسی وجود ECUهای تخصصی
-- ═══════════════════════════════════════════════════════
-- اگر نبودند، بساز
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('concept:transmission-ecu',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='TransmissionECU'),'concept','ECU گیربکس','Transmission ECU',2),
('concept:body-ecu',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='BodyECU'),'concept','ECU بدنه','Body ECU',2),
('concept:abs-ecu',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='ABS_ECU'),'concept','ECU ABS','ABS ECU',2);

-- ═══════════════════════════════════════════════════════
-- ۲. اتصال DCU → ECU تخصصی
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
VALUES
-- DCU موتور → transmission-ecu
('r:engine-dcu-has-transmission-ecu',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_part'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:engine-ecu-dcu'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:transmission-ecu'),
 'asserted', 2),

-- DCU شاسی → abs-ecu
('r:chassis-dcu-has-abs-ecu',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_part'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:chassis-ecu-dcu'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:abs-ecu'),
 'asserted', 2),

-- DCU بدنه → body-ecu (اگر جدا از DCU باشد)
('r:body-dcu-has-body-ecu',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_part'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:body-ecu-dcu'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:body-ecu'),
 'asserted', 2);

-- ═══════════════════════════════════════════════════════
-- ۳. لاگ
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v81.1_fix','Attached DCUs to specialized ECUs');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- ═══════════════════════════════════════════════════════
-- گزارش
-- ═══════════════════════════════════════════════════════
SELECT 'entities' AS k, COUNT(*) AS n FROM e01_200_03_tb
UNION ALL SELECT 'relations', COUNT(*) FROM e01_222_01_tb;

SELECT '=== DCU → ECU ===' AS section;
SELECT 
  dcu.label AS dcu,
  ecu.label AS ecu
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='has_part'
JOIN e01_200_03_tb dcu ON dcu.ent_id = r.subj_ent_id
JOIN e01_200_03_tb ecu ON ecu.ent_id = r.obj_ent_id
WHERE dcu.ent_uid LIKE 'concept:%-dcu'
  AND r.status='asserted' AND r.superseded_at IS NULL
ORDER BY dcu.label;
