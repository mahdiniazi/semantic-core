-- v107 — سه لایه: inherent (لاجرم) + design (طراحی) + chosen (انتخاب نمونه)
.mode column
.headers on

BEGIN;

-- ═══════════════════════════════════════════════════════
-- ۱. رفع کرولا (هیبرید = ICE + EV)
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:inh-' || REPLACE(p.sub, 'concept:', '') || '-' || REPLACE(p.obj, 'concept:', ''),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='inherent_to'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.sub),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.obj),
  'asserted', 2
FROM (
  -- کرولا هیبرید لاجرم هر دو سوخت را دارد
  SELECT 'concept:passenger-car-hybrid' AS sub, 'concept:ignition-subsystem' AS obj UNION ALL
  SELECT 'concept:passenger-car-hybrid', 'concept:fuel-subsystem' UNION ALL
  SELECT 'concept:passenger-car-hybrid', 'concept:exhaust-subsystem' UNION ALL
  SELECT 'concept:passenger-car-hybrid', 'concept:ev-subsystem' UNION ALL
  SELECT 'concept:passenger-car-hybrid', 'concept:ecu-subsystem' UNION ALL
  SELECT 'concept:passenger-car-hybrid', 'concept:sensor-subsystem' UNION ALL
  SELECT 'concept:passenger-car-hybrid', 'concept:bus-subsystem'
) p
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.sub)
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.obj)
  AND NOT EXISTS (
    SELECT 1 FROM e01_222_01_tb r
    WHERE r.rel_uid = 'r:inh-' || REPLACE(p.sub, 'concept:', '') || '-' || REPLACE(p.obj, 'concept:', '')
  );

-- ═══════════════════════════════════════════════════════
-- ۲. لایه design: اعلام طراحی خاص هر مفهوم خودرو
-- ═══════════════════════════════════════════════════════
-- design = has_direct_part در سطح concept → ولی در v103 به may_have تبدیل شد
-- راه‌حل: استفاده از may_have_direct_part برای design

-- برای BMW X5: طراحی لوکس
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:design-' || REPLACE(p.sub, ':', '-') || '-' || REPLACE(p.obj, ':', '-'),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='may_have_direct_part'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.sub),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.obj),
  'asserted', 2
FROM (
  -- BMW X5 - طراحی خاص
  SELECT 'concept:bmw-x5' AS sub, 'concept:adas-subsystem' AS obj UNION ALL
  SELECT 'concept:bmw-x5', 'concept:airbag-subsystem' UNION ALL
  SELECT 'concept:bmw-x5', 'concept:infotainment' UNION ALL
  SELECT 'concept:bmw-x5', 'concept:abs-subsystem' UNION ALL
  SELECT 'concept:bmw-x5', 'concept:cruise-control' UNION ALL
  SELECT 'concept:bmw-x5', 'concept:parking-sensor' UNION ALL
  SELECT 'concept:bmw-x5', 'concept:reverse-camera' UNION ALL
  SELECT 'concept:bmw-x5', 'concept:ac-compressor' UNION ALL
  -- کرولا - طراحی خاص
  SELECT 'concept:toyota-corolla', 'concept:adas-subsystem' UNION ALL
  SELECT 'concept:toyota-corolla', 'concept:airbag-subsystem' UNION ALL
  SELECT 'concept:toyota-corolla', 'concept:abs-subsystem' UNION ALL
  SELECT 'concept:toyota-corolla', 'concept:ac-compressor'
) p
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.sub)
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.obj)
  AND NOT EXISTS (
    SELECT 1 FROM e01_222_01_tb r
    WHERE r.rel_uid = 'r:design-' || REPLACE(p.sub, ':', '-') || '-' || REPLACE(p.obj, ':', '-')
  );

INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v107_three_layers','Three layers: inherent (min) + design (model choice) + chosen (instance)');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- ═══ گزارش ═══
SELECT '=== inherent_to کرولا (هیبرید) ===' AS section;
SELECT obj.label AS has_inherently
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='inherent_to'
JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
WHERE r.subj_ent_id = (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:passenger-car-hybrid')
  AND r.status='asserted' AND r.superseded_at IS NULL
ORDER BY obj.label;
