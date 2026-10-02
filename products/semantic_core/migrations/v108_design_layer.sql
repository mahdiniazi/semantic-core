-- v108 — لایه design: طراحی خاص هر مدل
.mode column
.headers on

BEGIN;

-- ═══════════════════════════════════════════════════════
-- ۱. ساخت relation type جدید
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_202_01_tb
  (type_uid, label, description, object_kind, is_symmetric, is_transitive, is_functional, inverse_uid)
VALUES
  ('designed_with','طراحی شده با','طراحی خاص این مدل خودرو','entity',0,0,0,NULL);

INSERT OR IGNORE INTO e01_202_02_tb (reltype_id, reify_rule, category, reason)
SELECT reltype_id, 'never', 'structural', 'طراحی مدل — بدون داده'
FROM e01_202_01_tb WHERE type_uid='designed_with';

-- ═══════════════════════════════════════════════════════
-- ۲. پر کردن لایه design برای خودروهای ایرانی
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:design-' || REPLACE(p.sub, ':', '-') || '-' || REPLACE(p.obj, ':', '-'),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='designed_with'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.sub),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.obj),
  'asserted', 2
FROM (
  -- ═══ پراید ۱۳۱ (پایه، بدون کولر) ═══
  -- (هیچ design خاص ندارد — تمام inherent است)
  
  -- ═══ پژو ۲۰۶ ═══
  SELECT 'concept:206' AS sub, 'concept:ac-compressor' AS obj UNION ALL
  SELECT 'concept:206', 'concept:abs-subsystem' UNION ALL
  SELECT 'concept:206', 'concept:power-steering' UNION ALL
  SELECT 'concept:206', 'concept:airbag-subsystem' UNION ALL
  SELECT 'concept:206', 'concept:dashboard-subsystem' UNION ALL
  SELECT 'concept:206', 'concept:ac-condenser' UNION ALL
  SELECT 'concept:206', 'concept:ac-expansion' UNION ALL
  SELECT 'concept:206', 'concept:ac-refrigerant' UNION ALL
  
  -- ═══ پژو ۴۰۵ ═══
  SELECT 'concept:405', 'concept:ac-compressor' UNION ALL
  SELECT 'concept:405', 'concept:power-steering' UNION ALL
  SELECT 'concept:405', 'concept:ac-condenser' UNION ALL
  SELECT 'concept:405', 'concept:ac-expansion' UNION ALL
  SELECT 'concept:405', 'concept:ac-refrigerant' UNION ALL
  SELECT 'concept:405', 'concept:airbag-subsystem' UNION ALL
  
  -- ═══ سمند ═══
  SELECT 'concept:samand', 'concept:ac-compressor' UNION ALL
  SELECT 'concept:samand', 'concept:power-steering' UNION ALL
  SELECT 'concept:samand', 'concept:airbag-subsystem' UNION ALL
  SELECT 'concept:samand', 'concept:ac-condenser' UNION ALL
  SELECT 'concept:samand', 'concept:ac-expansion' UNION ALL
  SELECT 'concept:samand', 'concept:ac-refrigerant' UNION ALL
  SELECT 'concept:samand', 'concept:abs-subsystem' UNION ALL
  
  -- ═══ دنا ═══
  SELECT 'concept:dena', 'concept:ac-compressor' UNION ALL
  SELECT 'concept:dena', 'concept:power-steering' UNION ALL
  SELECT 'concept:dena', 'concept:airbag-subsystem' UNION ALL
  SELECT 'concept:dena', 'concept:abs-subsystem' UNION ALL
  SELECT 'concept:dena', 'concept:ac-condenser' UNION ALL
  SELECT 'concept:dena', 'concept:ac-expansion' UNION ALL
  SELECT 'concept:dena', 'concept:ac-refrigerant' UNION ALL
  
  -- ═══ شاهین ═══
  SELECT 'concept:shahin', 'concept:ac-compressor' UNION ALL
  SELECT 'concept:shahin', 'concept:power-steering' UNION ALL
  SELECT 'concept:shahin', 'concept:airbag-subsystem' UNION ALL
  SELECT 'concept:shahin', 'concept:abs-subsystem' UNION ALL
  SELECT 'concept:shahin', 'concept:cruise-control' UNION ALL
  SELECT 'concept:shahin', 'concept:parking-sensor' UNION ALL
  SELECT 'concept:shahin', 'concept:reverse-camera' UNION ALL
  SELECT 'concept:shahin', 'concept:infotainment' UNION ALL
  SELECT 'concept:shahin', 'concept:ac-condenser' UNION ALL
  SELECT 'concept:shahin', 'concept:ac-expansion' UNION ALL
  SELECT 'concept:shahin', 'concept:ac-refrigerant' UNION ALL
  
  -- ═══ تارا (مدرن) ═══
  SELECT 'concept:tara', 'concept:ac-compressor' UNION ALL
  SELECT 'concept:tara', 'concept:power-steering' UNION ALL
  SELECT 'concept:tara', 'concept:airbag-subsystem' UNION ALL
  SELECT 'concept:tara', 'concept:abs-subsystem' UNION ALL
  SELECT 'concept:tara', 'concept:cruise-control' UNION ALL
  SELECT 'concept:tara', 'concept:parking-sensor' UNION ALL
  SELECT 'concept:tara', 'concept:reverse-camera' UNION ALL
  SELECT 'concept:tara', 'concept:infotainment' UNION ALL
  SELECT 'concept:tara', 'concept:adas-subsystem' UNION ALL
  SELECT 'concept:tara', 'concept:ac-condenser' UNION ALL
  SELECT 'concept:tara', 'concept:ac-expansion' UNION ALL
  SELECT 'concept:tara', 'concept:ac-refrigerant' UNION ALL
  
  -- ═══ رانا ═══
  SELECT 'concept:rana', 'concept:ac-compressor' UNION ALL
  SELECT 'concept:rana', 'concept:power-steering' UNION ALL
  SELECT 'concept:rana', 'concept:abs-subsystem' UNION ALL
  SELECT 'concept:rana', 'concept:airbag-subsystem' UNION ALL
  SELECT 'concept:rana', 'concept:ac-condenser' UNION ALL
  SELECT 'concept:rana', 'concept:ac-expansion' UNION ALL
  SELECT 'concept:rana', 'concept:ac-refrigerant' UNION ALL
  
  -- ═══ رانا پلاس ═══
  SELECT 'concept:runna', 'concept:ac-compressor' UNION ALL
  SELECT 'concept:runna', 'concept:power-steering' UNION ALL
  SELECT 'concept:runna', 'concept:abs-subsystem' UNION ALL
  SELECT 'concept:runna', 'concept:airbag-subsystem' UNION ALL
  SELECT 'concept:runna', 'concept:infotainment' UNION ALL
  SELECT 'concept:runna', 'concept:parking-sensor' UNION ALL
  SELECT 'concept:runna', 'concept:ac-condenser' UNION ALL
  SELECT 'concept:runna', 'concept:ac-expansion' UNION ALL
  SELECT 'concept:runna', 'concept:ac-refrigerant' UNION ALL
  
  -- ═══ سورن ═══
  SELECT 'concept:soren', 'concept:ac-compressor' UNION ALL
  SELECT 'concept:soren', 'concept:power-steering' UNION ALL
  SELECT 'concept:soren', 'concept:abs-subsystem' UNION ALL
  SELECT 'concept:soren', 'concept:airbag-subsystem' UNION ALL
  SELECT 'concept:soren', 'concept:ac-condenser' UNION ALL
  SELECT 'concept:soren', 'concept:ac-expansion' UNION ALL
  SELECT 'concept:soren', 'concept:ac-refrigerant' UNION ALL
  
  -- ═══ ری‌را (کراس‌اوور مدرن) ═══
  SELECT 'concept:reera', 'concept:ac-compressor' UNION ALL
  SELECT 'concept:reera', 'concept:power-steering' UNION ALL
  SELECT 'concept:reera', 'concept:abs-subsystem' UNION ALL
  SELECT 'concept:reera', 'concept:airbag-subsystem' UNION ALL
  SELECT 'concept:reera', 'concept:cruise-control' UNION ALL
  SELECT 'concept:reera', 'concept:parking-sensor' UNION ALL
  SELECT 'concept:reera', 'concept:reverse-camera' UNION ALL
  SELECT 'concept:reera', 'concept:infotainment' UNION ALL
  SELECT 'concept:reera', 'concept:ac-condenser' UNION ALL
  SELECT 'concept:reera', 'concept:ac-expansion' UNION ALL
  SELECT 'concept:reera', 'concept:ac-refrigerant' UNION ALL
  
  -- ═══ تیبا ═══
  SELECT 'concept:tiba', 'concept:ac-compressor' UNION ALL
  SELECT 'concept:tiba', 'concept:power-steering' UNION ALL
  SELECT 'concept:tiba', 'concept:ac-condenser' UNION ALL
  SELECT 'concept:tiba', 'concept:ac-expansion' UNION ALL
  SELECT 'concept:tiba', 'concept:ac-refrigerant' UNION ALL
  
  -- ═══ ساینا ═══
  SELECT 'concept:saina', 'concept:ac-compressor' UNION ALL
  SELECT 'concept:saina', 'concept:power-steering' UNION ALL
  SELECT 'concept:saina', 'concept:airbag-subsystem' UNION ALL
  SELECT 'concept:saina', 'concept:abs-subsystem' UNION ALL
  SELECT 'concept:saina', 'concept:ac-condenser' UNION ALL
  SELECT 'concept:saina', 'concept:ac-expansion' UNION ALL
  SELECT 'concept:saina', 'concept:ac-refrigerant' UNION ALL
  
  -- ═══ کوییک ═══
  SELECT 'concept:quick', 'concept:ac-compressor' UNION ALL
  SELECT 'concept:quick', 'concept:power-steering' UNION ALL
  SELECT 'concept:quick', 'concept:abs-subsystem' UNION ALL
  SELECT 'concept:quick', 'concept:airbag-subsystem' UNION ALL
  SELECT 'concept:quick', 'concept:infotainment' UNION ALL
  SELECT 'concept:quick', 'concept:ac-condenser' UNION ALL
  SELECT 'concept:quick', 'concept:ac-expansion' UNION ALL
  SELECT 'concept:quick', 'concept:ac-refrigerant'
) p
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.sub)
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.obj)
  AND NOT EXISTS (
    SELECT 1 FROM e01_222_01_tb r
    WHERE r.rel_uid = 'r:design-' || REPLACE(p.sub, ':', '-') || '-' || REPLACE(p.obj, ':', '-')
  );

-- ═══════════════════════════════════════════════════════
-- ۳. برای خودروهای خارجی
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:design-' || REPLACE(p.sub, ':', '-') || '-' || REPLACE(p.obj, ':', '-'),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='designed_with'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.sub),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.obj),
  'asserted', 2
FROM (
  -- ═══ تویوتا کرولا (هیبرید کامل) ═══
  SELECT 'concept:toyota-corolla' AS sub, 'concept:ac-compressor' AS obj UNION ALL
  SELECT 'concept:toyota-corolla', 'concept:ac-condenser' UNION ALL
  SELECT 'concept:toyota-corolla', 'concept:ac-expansion' UNION ALL
  SELECT 'concept:toyota-corolla', 'concept:ac-refrigerant' UNION ALL
  SELECT 'concept:toyota-corolla', 'concept:power-steering' UNION ALL
  SELECT 'concept:toyota-corolla', 'concept:airbag-subsystem' UNION ALL
  SELECT 'concept:toyota-corolla', 'concept:abs-subsystem' UNION ALL
  SELECT 'concept:toyota-corolla', 'concept:cruise-control' UNION ALL
  SELECT 'concept:toyota-corolla', 'concept:parking-sensor' UNION ALL
  SELECT 'concept:toyota-corolla', 'concept:reverse-camera' UNION ALL
  SELECT 'concept:toyota-corolla', 'concept:infotainment' UNION ALL
  SELECT 'concept:toyota-corolla', 'concept:adas-subsystem' UNION ALL
  SELECT 'concept:toyota-corolla', 'concept:touchscreen' UNION ALL
  SELECT 'concept:toyota-corolla', 'concept:radar' UNION ALL
  
  -- ═══ BMW X5 (لوکس) ═══
  SELECT 'concept:bmw-x5', 'concept:ac-compressor' UNION ALL
  SELECT 'concept:bmw-x5', 'concept:ac-condenser' UNION ALL
  SELECT 'concept:bmw-x5', 'concept:ac-expansion' UNION ALL
  SELECT 'concept:bmw-x5', 'concept:ac-refrigerant' UNION ALL
  SELECT 'concept:bmw-x5', 'concept:power-steering' UNION ALL
  SELECT 'concept:bmw-x5', 'concept:airbag-subsystem' UNION ALL
  SELECT 'concept:bmw-x5', 'concept:abs-subsystem' UNION ALL
  SELECT 'concept:bmw-x5', 'concept:cruise-control' UNION ALL
  SELECT 'concept:bmw-x5', 'concept:parking-sensor' UNION ALL
  SELECT 'concept:bmw-x5', 'concept:reverse-camera' UNION ALL
  SELECT 'concept:bmw-x5', 'concept:infotainment' UNION ALL
  SELECT 'concept:bmw-x5', 'concept:adas-subsystem' UNION ALL
  SELECT 'concept:bmw-x5', 'concept:touchscreen' UNION ALL
  SELECT 'concept:bmw-x5', 'concept:radar' UNION ALL
  SELECT 'concept:bmw-x5', 'concept:lidar' UNION ALL
  SELECT 'concept:bmw-x5', 'concept:amplifier' UNION ALL
  SELECT 'concept:bmw-x5', 'concept:speaker' UNION ALL
  SELECT 'concept:bmw-x5', 'concept:antenna' UNION ALL
  
  -- ═══ تسلا مدل ۳ (برقی، خودران) ═══
  SELECT 'concept:tesla-model-3', 'concept:ac-compressor' UNION ALL
  SELECT 'concept:tesla-model-3', 'concept:ac-condenser' UNION ALL
  SELECT 'concept:tesla-model-3', 'concept:ac-expansion' UNION ALL
  SELECT 'concept:tesla-model-3', 'concept:ac-refrigerant' UNION ALL
  SELECT 'concept:tesla-model-3', 'concept:power-steering' UNION ALL
  SELECT 'concept:tesla-model-3', 'concept:airbag-subsystem' UNION ALL
  SELECT 'concept:tesla-model-3', 'concept:abs-subsystem' UNION ALL
  SELECT 'concept:tesla-model-3', 'concept:cruise-control' UNION ALL
  SELECT 'concept:tesla-model-3', 'concept:parking-sensor' UNION ALL
  SELECT 'concept:tesla-model-3', 'concept:reverse-camera' UNION ALL
  SELECT 'concept:tesla-model-3', 'concept:infotainment' UNION ALL
  SELECT 'concept:tesla-model-3', 'concept:adas-subsystem' UNION ALL
  SELECT 'concept:tesla-model-3', 'concept:touchscreen' UNION ALL
  SELECT 'concept:tesla-model-3', 'concept:radar' UNION ALL
  SELECT 'concept:tesla-model-3', 'concept:lidar' UNION ALL
  
  -- ═══ هیوندای توسان ═══
  SELECT 'concept:hyundai-tucson', 'concept:ac-compressor' UNION ALL
  SELECT 'concept:hyundai-tucson', 'concept:ac-condenser' UNION ALL
  SELECT 'concept:hyundai-tucson', 'concept:ac-expansion' UNION ALL
  SELECT 'concept:hyundai-tucson', 'concept:ac-refrigerant' UNION ALL
  SELECT 'concept:hyundai-tucson', 'concept:power-steering' UNION ALL
  SELECT 'concept:hyundai-tucson', 'concept:airbag-subsystem' UNION ALL
  SELECT 'concept:hyundai-tucson', 'concept:abs-subsystem' UNION ALL
  SELECT 'concept:hyundai-tucson', 'concept:cruise-control' UNION ALL
  SELECT 'concept:hyundai-tucson', 'concept:parking-sensor' UNION ALL
  SELECT 'concept:hyundai-tucson', 'concept:reverse-camera' UNION ALL
  SELECT 'concept:hyundai-tucson', 'concept:infotainment' UNION ALL
  SELECT 'concept:hyundai-tucson', 'concept:adas-subsystem' UNION ALL
  SELECT 'concept:hyundai-tucson', 'concept:touchscreen' UNION ALL
  SELECT 'concept:hyundai-tucson', 'concept:radar'
) p
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.sub)
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.obj)
  AND NOT EXISTS (
    SELECT 1 FROM e01_222_01_tb r
    WHERE r.rel_uid = 'r:design-' || REPLACE(p.sub, ':', '-') || '-' || REPLACE(p.obj, ':', '-')
  );

INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v108_design_layer','Design layer: model-specific design features');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- ═══ گزارش ═══
SELECT 'entities' AS k, COUNT(*) AS n FROM e01_200_03_tb
UNION ALL SELECT 'relations', COUNT(*) FROM e01_222_01_tb;

SELECT '' AS x;
SELECT '═══ طراحی خاص هر مدل ═══' AS section;
SELECT 
  sub.label AS model,
  COUNT(*) AS n_design_features
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='designed_with'
JOIN e01_200_03_tb sub ON sub.ent_id = r.subj_ent_id
WHERE r.status='asserted' AND r.superseded_at IS NULL
GROUP BY sub.ent_uid
ORDER BY n_design_features DESC;
