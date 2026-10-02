-- v97 — inherent_to برای قطعات لاجرم هر زیرسیستم
.mode column
.headers on

BEGIN;

-- ═══════════════════════════════════════════════════════
-- اعلام قطعات لاجرم (inherent) برای هر زیرسیستم
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:inh-' || REPLACE(p.sub, 'concept:', '') || '-' || REPLACE(p.part, 'concept:', ''),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='inherent_to'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.sub),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.part),
  'asserted', 2
FROM (
  -- ═══ پیشرانه ═══
  -- جرقه‌زنی
  SELECT 'concept:ignition-subsystem' AS sub, 'concept:ignition-coil' AS part UNION ALL
  SELECT 'concept:ignition-subsystem', 'concept:spark-plug' UNION ALL
  -- سوخت‌رسانی
  SELECT 'concept:fuel-subsystem', 'concept:fuel-pump' UNION ALL
  SELECT 'concept:fuel-subsystem', 'concept:injector' UNION ALL
  SELECT 'concept:fuel-subsystem', 'concept:fuel-tank' UNION ALL
  -- خنک‌کننده
  SELECT 'concept:cooling-subsystem', 'concept:radiator' UNION ALL
  SELECT 'concept:cooling-subsystem', 'concept:water-pump' UNION ALL
  SELECT 'concept:cooling-subsystem', 'concept:thermostat' UNION ALL
  SELECT 'concept:cooling-subsystem', 'concept:coolant-reservoir' UNION ALL
  SELECT 'concept:cooling-subsystem', 'concept:cooling-fan' UNION ALL
  SELECT 'concept:cooling-subsystem', 'concept:cooling-fan-relay' UNION ALL
  -- اگزوز
  SELECT 'concept:exhaust-subsystem', 'concept:exhaust-manifold' UNION ALL
  SELECT 'concept:exhaust-subsystem', 'concept:muffler' UNION ALL
  SELECT 'concept:exhaust-subsystem', 'concept:exhaust-pipe' UNION ALL
  -- انتقال قدرت
  SELECT 'concept:transmission-subsystem', 'concept:transmission' UNION ALL
  SELECT 'concept:transmission-subsystem', 'concept:drive-shaft' UNION ALL
  -- ═══ شاسی ═══
  -- ترمز
  SELECT 'concept:braking-subsystem', 'concept:brake-master' UNION ALL
  SELECT 'concept:braking-subsystem', 'concept:brake-booster' UNION ALL
  SELECT 'concept:braking-subsystem', 'concept:brake-line' UNION ALL
  SELECT 'concept:braking-subsystem', 'concept:brake-fluid' UNION ALL
  SELECT 'concept:braking-subsystem', 'concept:brake-disc' UNION ALL
  SELECT 'concept:braking-subsystem', 'concept:brake-pad' UNION ALL
  SELECT 'concept:braking-subsystem', 'concept:brake-caliper' UNION ALL
  -- فرمان
  SELECT 'concept:steering-subsystem', 'concept:steering-wheel' UNION ALL
  SELECT 'concept:steering-subsystem', 'concept:steering-column' UNION ALL
  SELECT 'concept:steering-subsystem', 'concept:steering-rack' UNION ALL
  SELECT 'concept:steering-subsystem', 'concept:tie-rod' UNION ALL
  -- تعلیق
  SELECT 'concept:suspension-subsystem', 'concept:coil-spring' UNION ALL
  SELECT 'concept:suspension-subsystem', 'concept:shock-absorber' UNION ALL
  SELECT 'concept:suspension-subsystem', 'concept:control-arm' UNION ALL
  SELECT 'concept:suspension-subsystem', 'concept:ball-joint' UNION ALL
  SELECT 'concept:suspension-subsystem', 'concept:bushing' UNION ALL
  -- چرخ
  SELECT 'concept:wheel-subsystem', 'concept:wheel' UNION ALL
  SELECT 'concept:wheel-subsystem', 'concept:tire' UNION ALL
  -- ═══ بدنه ═══
  -- روشنایی
  SELECT 'concept:lighting-subsystem', 'concept:headlight-low' UNION ALL
  SELECT 'concept:lighting-subsystem', 'concept:headlight-high' UNION ALL
  SELECT 'concept:lighting-subsystem', 'concept:tail-light' UNION ALL
  SELECT 'concept:lighting-subsystem', 'concept:brake-light' UNION ALL
  SELECT 'concept:lighting-subsystem', 'concept:turn-signal' UNION ALL
  -- راحتی
  SELECT 'concept:comfort-subsystem', 'concept:seat' UNION ALL
  SELECT 'concept:comfort-subsystem', 'concept:door' UNION ALL
  SELECT 'concept:comfort-subsystem', 'concept:window' UNION ALL
  SELECT 'concept:comfort-subsystem', 'concept:windshield' UNION ALL
  SELECT 'concept:comfort-subsystem', 'concept:mirror' UNION ALL
  -- داشبورد
  SELECT 'concept:dashboard-subsystem', 'concept:speedometer' UNION ALL
  SELECT 'concept:dashboard-subsystem', 'concept:fuel-gauge' UNION ALL
  -- ═══ E/E ═══
  -- تأمین برق
  SELECT 'concept:power-supply-subsystem', 'concept:battery' UNION ALL
  SELECT 'concept:power-supply-subsystem', 'concept:alternator' UNION ALL
  SELECT 'concept:power-supply-subsystem', 'concept:voltage-regulator' UNION ALL
  SELECT 'concept:power-supply-subsystem', 'concept:fuse' UNION ALL
  SELECT 'concept:power-supply-subsystem', 'concept:relay' UNION ALL
  SELECT 'concept:power-supply-subsystem', 'concept:wiring' UNION ALL
  -- راه‌اندازی
  SELECT 'concept:starting-subsystem', 'concept:starter' UNION ALL
  SELECT 'concept:starting-subsystem', 'concept:ignition-switch' UNION ALL
  -- ECU
  SELECT 'concept:ecu-subsystem', 'concept:engine-ecu' UNION ALL
  -- شبکه
  SELECT 'concept:bus-subsystem', 'concept:can-bus' UNION ALL
  -- سنسورها
  SELECT 'concept:sensor-subsystem', 'concept:crankshaft-sensor' UNION ALL
  SELECT 'concept:sensor-subsystem', 'concept:camshaft-sensor' UNION ALL
  SELECT 'concept:sensor-subsystem', 'concept:coolant-sensor' UNION ALL
  SELECT 'concept:sensor-subsystem', 'concept:o2-sensor' UNION ALL
  SELECT 'concept:sensor-subsystem', 'concept:maf-sensor' UNION ALL
  SELECT 'concept:sensor-subsystem', 'concept:tps' UNION ALL
  SELECT 'concept:sensor-subsystem', 'concept:vss' UNION ALL
  -- EV
  SELECT 'concept:ev-subsystem', 'concept:traction-motor' UNION ALL
  SELECT 'concept:ev-subsystem', 'concept:inverter' UNION ALL
  SELECT 'concept:ev-subsystem', 'concept:battery-pack' UNION ALL
  SELECT 'concept:ev-subsystem', 'concept:onboard-charger' UNION ALL
  SELECT 'concept:ev-subsystem', 'concept:charging-port' UNION ALL
  SELECT 'concept:ev-subsystem', 'concept:bms' UNION ALL
  SELECT 'concept:ev-subsystem', 'concept:dcdc' UNION ALL
  SELECT 'concept:ev-subsystem', 'concept:hv-cable'
) p
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.sub)
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.part)
  AND NOT EXISTS (
    SELECT 1 FROM e01_222_01_tb r
    WHERE r.rel_uid = 'r:inh-' || REPLACE(p.sub, 'concept:', '') || '-' || REPLACE(p.part, 'concept:', '')
  );

INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v97_mandatory_parts','Declared inherent parts for each subsystem');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- ═══════════════════════════════════════════════════════
-- گزارش
-- ═══════════════════════════════════════════════════════
SELECT 'entities' AS k, COUNT(*) AS n FROM e01_200_03_tb
UNION ALL SELECT 'relations', COUNT(*) FROM e01_222_01_tb;

SELECT '=== شمارش inherent/design/option هر زیرسیستم ===' AS section;
SELECT 
  sub.label AS subsystem,
  (SELECT COUNT(*) FROM e01_222_01_tb r2
     JOIN e01_202_01_tb rt2 ON rt2.reltype_id = r2.reltype_id
     WHERE r2.subj_ent_id = sub.ent_id 
       AND rt2.type_uid='inherent_to'
       AND r2.status='asserted' AND r2.superseded_at IS NULL) AS inherent,
  (SELECT COUNT(*) FROM e01_222_01_tb r3
     JOIN e01_202_01_tb rt3 ON rt3.reltype_id = r3.reltype_id
     WHERE r3.subj_ent_id = sub.ent_id 
       AND rt3.type_uid='has_direct_part'
       AND r3.status='asserted' AND r3.superseded_at IS NULL) AS total_parts,
  (SELECT COUNT(*) FROM e01_222_01_tb r4
     JOIN e01_202_01_tb rt4 ON rt4.reltype_id = r4.reltype_id
     WHERE r4.subj_ent_id = sub.ent_id 
       AND rt4.type_uid='has_direct_part'
       AND r4.status='asserted' AND r4.superseded_at IS NULL
       AND NOT EXISTS (
         SELECT 1 FROM e01_222_01_tb r5
         JOIN e01_202_01_tb rt5 ON rt5.reltype_id = r5.reltype_id
         WHERE r5.subj_ent_id = r4.subj_ent_id 
           AND r5.obj_ent_id = r4.obj_ent_id
           AND rt5.type_uid='inherent_to'
           AND r5.status='asserted' AND r5.superseded_at IS NULL
       )
  ) AS design_or_option
FROM e01_200_03_tb sub
WHERE sub.ent_uid LIKE 'concept:%-subsystem'
  AND EXISTS (
    SELECT 1 FROM e01_222_01_tb r
    JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id
    WHERE r.subj_ent_id = sub.ent_id 
      AND rt.type_uid IN ('inherent_to','has_direct_part')
      AND r.status='asserted' AND r.superseded_at IS NULL
  )
ORDER BY design_or_option DESC, subsystem;
