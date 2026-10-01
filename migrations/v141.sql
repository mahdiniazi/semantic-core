.mode column
.headers on

BEGIN;

-- ═══ ساخت ۴ نقش جدید ═══
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('role:structural-part',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Role'), 'concept', 'قطعه سازه‌ای', 'Structural/mechanical part', 2),
('role:fluid',              (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Role'), 'concept', 'سیال', 'Fluid (oil, refrigerant)', 2),
('role:display',            (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Role'), 'concept', 'نشانگر', 'Display/indicator', 2),
('role:electronic-module',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Role'), 'concept', 'ماژول الکترونیکی', 'Electronic module', 2);

-- ═══ اتصال دو نقش جدید به نقش پایه ═══
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id) VALUES
('r:display-is-a-actuation', (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a'), (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='role:display'), (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='role:actuation-function'), 'asserted', 2),
('r:electronic-module-is-a-control', (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a'), (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='role:electronic-module'), (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='role:control-function'), 'asserted', 2);

-- ═══ انتساب ۱۰۳ Concept به نقش ═══
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT 
  'r:' || REPLACE(REPLACE(e.ent_uid, ':', '-'), ' ', '-') || '-plays',
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='plays_role'),
  e.ent_id,
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid = 
    CASE
      WHEN e.ent_uid IN ('concept:brake-fluid','concept:ac-refrigerant') THEN 'role:fluid'
      WHEN e.ent_uid IN ('concept:vss','concept:tps','concept:fuel-level','concept:fuel-pressure','concept:oil-pressure','concept:oil-temp','concept:egr-position','concept:turbo-boost','concept:upstream-o2','concept:downstream-o2','concept:wheel-speed') THEN 'role:sensor'
      WHEN e.ent_uid IN ('concept:bms','concept:infotainment','concept:cruise-control','concept:thermal-mgmt') THEN 'role:controller'
      WHEN e.ent_uid IN ('concept:amplifier','concept:antenna','concept:speaker','concept:touchscreen') THEN 'role:electronic-module'
      WHEN e.ent_uid IN ('concept:check-engine-light','concept:coolant-gauge','concept:fuel-gauge','concept:speedometer','concept:tachometer','concept:warning-light','concept:headlight-high','concept:headlight-low','concept:fog-light','concept:interior-light','concept:reverse-light','concept:tail-light','concept:turn-signal','concept:brake-light') THEN 'role:display'
      WHEN e.ent_uid IN ('concept:dcdc','concept:inverter','concept:onboard-charger','concept:voltage-regulator','concept:hv-cable','concept:charging-port') THEN 'role:energy-conversion'
      WHEN e.ent_uid IN ('concept:ac-compressor','concept:airbag','concept:cooling-fan','concept:hydraulic-lift','concept:injector','concept:power-steering','concept:regen-brake','concept:siren','concept:starter','concept:wheelchair-ramp','concept:ignition-coil','concept:spark-plug','concept:seatbelt-pretensioner') THEN 'role:actuator'
      WHEN e.ent_uid = 'concept:ignition-switch' THEN 'role:switch-signal'
      WHEN e.ent_uid = 'concept:wiring' THEN 'role:transceiver'
      ELSE 'role:structural-part'
    END),
  'asserted', 2
FROM e01_200_03_tb e
WHERE e.ent_uid IN (
  'concept:ac-compressor','concept:ac-condenser','concept:ac-expansion','concept:ac-refrigerant',
  'concept:airbag','concept:amplifier','concept:antenna','concept:ball-joint','concept:bms',
  'concept:brake-booster','concept:brake-caliper','concept:brake-disc','concept:brake-drum',
  'concept:brake-fluid','concept:brake-light','concept:brake-line','concept:brake-master',
  'concept:brake-pad','concept:brake-shoe','concept:cabin-filter','concept:catalytic-converter',
  'concept:charging-port','concept:check-engine-light','concept:clutch','concept:coil-spring',
  'concept:control-arm','concept:coolant-gauge','concept:cooling-fan','concept:cruise-control',
  'concept:dcdc','concept:differential','concept:door','concept:door-lock','concept:downstream-o2',
  'concept:drive-shaft','concept:egr-position','concept:exhaust-manifold','concept:exhaust-pipe',
  'concept:fog-light','concept:fuel-gauge','concept:fuel-level','concept:fuel-pressure',
  'concept:fuel-rail','concept:fuel-tank','concept:headlight-high','concept:headlight-low',
  'concept:heater-core','concept:hv-cable','concept:hydraulic-lift','concept:ignition-coil',
  'concept:ignition-switch','concept:infotainment','concept:injector','concept:interior-light',
  'concept:inverter','concept:ladder','concept:mirror','concept:muffler','concept:oil-pressure',
  'concept:oil-temp','concept:onboard-charger','concept:power-steering','concept:radiator',
  'concept:reefer','concept:regen-brake','concept:reverse-light','concept:seat','concept:seatbelt',
  'concept:seatbelt-pretensioner','concept:shock-absorber','concept:siren','concept:spark-plug',
  'concept:speaker','concept:speedometer','concept:starter','concept:steering-column',
  'concept:steering-rack','concept:steering-wheel','concept:sway-bar','concept:tachometer',
  'concept:tail-light','concept:tank','concept:thermal-mgmt','concept:thermostat','concept:tie-rod',
  'concept:touchscreen','concept:tps','concept:transmission','concept:turbo-boost','concept:turn-signal',
  'concept:upstream-o2','concept:voltage-regulator','concept:vss','concept:warning-light',
  'concept:wheel','concept:wheel-bearing','concept:wheel-speed','concept:wheelchair-ramp',
  'concept:window','concept:windshield','concept:wiper-blade','concept:wiring'
);

-- ═══ log + bump ═══
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v141_role_assignment', 'Added 4 roles + assigned 103 concepts to roles');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- ═══ POST-CHECK ═══
SELECT 'roles_total' AS metric, COUNT(*) AS n FROM e01_200_03_tb WHERE ent_uid LIKE 'role:%'
UNION ALL SELECT 'plays_role_total', COUNT(*) FROM e01_222_01_tb r JOIN e01_202_01_tb rt ON rt.reltype_id=r.reltype_id WHERE rt.type_uid='plays_role'
UNION ALL SELECT 'pending', COUNT(*) FROM e01_200_05_tb WHERE status='pending';

SELECT '' AS x;
SELECT severity, COUNT(*) AS n FROM e04_900_02_vw GROUP BY severity;
