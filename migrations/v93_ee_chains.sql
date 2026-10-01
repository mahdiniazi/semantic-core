-- v93 — زنجیره‌های کارکردی دامنه برق و الکترونیک
.mode column
.headers on

BEGIN;

-- ═══════════════════════════════════════════════════════
-- ۱. ساخت ۷ زنجیره جدید
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id)
SELECT 'fn:' || p.uid, 
       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='FunctionalChain'),
       'concept', p.label, p.descr, 2
FROM (
  SELECT 'power-supply-chain' AS uid, 'زنجیره تأمین برق' AS label, 'Power supply flow' AS descr UNION ALL
  SELECT 'starting-chain', 'زنجیره راه‌اندازی', 'Engine starting flow' UNION ALL
  SELECT 'bus-chain', 'زنجیره شبکه', 'Communication bus' UNION ALL
  SELECT 'sensor-chain', 'زنجیره سنسور', 'Sensor acquisition' UNION ALL
  SELECT 'ev-chain', 'زنجیره برقی', 'EV powertrain' UNION ALL
  SELECT 'gateway-chain', 'زنجیره دروازه', 'Gateway routing' UNION ALL
  SELECT 'ee-super-chain', 'زنجیره کل E/E', 'E/E super chain'
) p;

-- ═══════════════════════════════════════════════════════
-- ۲. اتصال قطعات به زنجیره‌ها
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || REPLACE(p.part, ':', '-') || '-plays-in-' || REPLACE(p.chain, ':', '-'),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='plays_role_in'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.part),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.chain),
  'asserted', 2
FROM (
  -- زنجیره تأمین برق
  SELECT 'concept:battery' AS part, 'fn:power-supply-chain' AS chain UNION ALL
  SELECT 'concept:alternator',              'fn:power-supply-chain' UNION ALL
  SELECT 'concept:voltage-regulator',       'fn:power-supply-chain' UNION ALL
  SELECT 'concept:fuse',                    'fn:power-supply-chain' UNION ALL
  SELECT 'concept:relay',                   'fn:power-supply-chain' UNION ALL
  SELECT 'concept:wiring',                  'fn:power-supply-chain' UNION ALL
  -- زنجیره راه‌اندازی
  SELECT 'concept:battery',                 'fn:starting-chain' UNION ALL
  SELECT 'concept:ignition-switch',         'fn:starting-chain' UNION ALL
  SELECT 'concept:starter',                 'fn:starting-chain' UNION ALL
  SELECT 'concept:engine-ecu',              'fn:starting-chain' UNION ALL
  -- زنجیره شبکه
  SELECT 'concept:can-bus',                 'fn:bus-chain' UNION ALL
  SELECT 'concept:lin-bus',                 'fn:bus-chain' UNION ALL
  SELECT 'concept:flexray-bus',             'fn:bus-chain' UNION ALL
  SELECT 'concept:automotive-ethernet',     'fn:bus-chain' UNION ALL
  -- زنجیره سنسور
  SELECT 'concept:crankshaft-sensor',       'fn:sensor-chain' UNION ALL
  SELECT 'concept:camshaft-sensor',         'fn:sensor-chain' UNION ALL
  SELECT 'concept:map-sensor',              'fn:sensor-chain' UNION ALL
  SELECT 'concept:coolant-sensor',          'fn:sensor-chain' UNION ALL
  SELECT 'concept:o2-sensor',               'fn:sensor-chain' UNION ALL
  SELECT 'concept:maf-sensor',              'fn:sensor-chain' UNION ALL
  SELECT 'concept:knock-sensor',            'fn:sensor-chain' UNION ALL
  SELECT 'concept:tps',                     'fn:sensor-chain' UNION ALL
  SELECT 'concept:iat-sensor',              'fn:sensor-chain' UNION ALL
  SELECT 'concept:fuel-level',              'fn:sensor-chain' UNION ALL
  SELECT 'concept:fuel-pressure',           'fn:sensor-chain' UNION ALL
  SELECT 'concept:oil-pressure',            'fn:sensor-chain' UNION ALL
  SELECT 'concept:oil-temp',                'fn:sensor-chain' UNION ALL
  SELECT 'concept:vss',                     'fn:sensor-chain' UNION ALL
  SELECT 'concept:wheel-speed',             'fn:sensor-chain' UNION ALL
  SELECT 'concept:egr-position',            'fn:sensor-chain' UNION ALL
  SELECT 'concept:turbo-boost',             'fn:sensor-chain' UNION ALL
  SELECT 'concept:baro-sensor',             'fn:sensor-chain' UNION ALL
  SELECT 'concept:upstream-o2',             'fn:sensor-chain' UNION ALL
  SELECT 'concept:downstream-o2',           'fn:sensor-chain' UNION ALL
  SELECT 'concept:engine-ecu',              'fn:sensor-chain' UNION ALL
  -- زنجیره برقی
  SELECT 'concept:battery-pack',            'fn:ev-chain' UNION ALL
  SELECT 'concept:bms',                     'fn:ev-chain' UNION ALL
  SELECT 'concept:onboard-charger',         'fn:ev-chain' UNION ALL
  SELECT 'concept:charging-port',           'fn:ev-chain' UNION ALL
  SELECT 'concept:inverter',                'fn:ev-chain' UNION ALL
  SELECT 'concept:traction-motor',          'fn:ev-chain' UNION ALL
  SELECT 'concept:regen-brake',             'fn:ev-chain' UNION ALL
  SELECT 'concept:dcdc',                    'fn:ev-chain' UNION ALL
  SELECT 'concept:thermal-mgmt',            'fn:ev-chain' UNION ALL
  SELECT 'concept:hv-cable',                'fn:ev-chain' UNION ALL
  -- زنجیره دروازه
  SELECT 'concept:gateway-ecu',             'fn:gateway-chain' UNION ALL
  SELECT 'concept:can-bus',                 'fn:gateway-chain' UNION ALL
  SELECT 'concept:lin-bus',                 'fn:gateway-chain' UNION ALL
  SELECT 'concept:flexray-bus',             'fn:gateway-chain' UNION ALL
  SELECT 'concept:automotive-ethernet',     'fn:gateway-chain'
) p
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.part)
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.chain)
  AND NOT EXISTS (
    SELECT 1 FROM e01_222_01_tb r
    WHERE r.rel_uid = 'r:' || REPLACE(p.part, ':', '-') || '-plays-in-' || REPLACE(p.chain, ':', '-')
  );

-- ═══════════════════════════════════════════════════════
-- ۳. زنجیره کل E/E: زیرزنجیره‌ها
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || REPLACE(p.sub, ':', '-') || '-plays-in-' || REPLACE(p.super, ':', '-'),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='plays_role_in'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.sub),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.super),
  'asserted', 2
FROM (
  SELECT 'fn:power-supply-chain' AS sub, 'fn:ee-super-chain' AS super UNION ALL
  SELECT 'fn:starting-chain',              'fn:ee-super-chain' UNION ALL
  SELECT 'fn:bus-chain',                   'fn:ee-super-chain' UNION ALL
  SELECT 'fn:sensor-chain',                'fn:ee-super-chain' UNION ALL
  SELECT 'fn:ev-chain',                    'fn:ee-super-chain' UNION ALL
  SELECT 'fn:gateway-chain',               'fn:ee-super-chain'
) p
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.sub)
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.super)
  AND NOT EXISTS (
    SELECT 1 FROM e01_222_01_tb r
    WHERE r.rel_uid = 'r:' || REPLACE(p.sub, ':', '-') || '-plays-in-' || REPLACE(p.super, ':', '-')
  );

INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v93_ee_chains','7 functional chains for E/E domain');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- ═══════════════════════════════════════════════════════
-- گزارش
-- ═══════════════════════════════════════════════════════
SELECT 'entities' AS k, COUNT(*) AS n FROM e01_200_03_tb
UNION ALL SELECT 'relations', COUNT(*) FROM e01_222_01_tb;

SELECT '=== زنجیره‌های E/E ===' AS section;
SELECT 
  chain.label AS chain,
  GROUP_CONCAT(part.label, ' → ') AS roles
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='plays_role_in'
JOIN e01_200_03_tb part ON part.ent_id = r.subj_ent_id
JOIN e01_200_03_tb chain ON chain.ent_id = r.obj_ent_id
WHERE chain.ent_uid IN ('fn:power-supply-chain','fn:starting-chain','fn:bus-chain','fn:sensor-chain','fn:ev-chain','fn:gateway-chain','fn:ee-super-chain')
  AND r.status='asserted' AND r.superseded_at IS NULL
GROUP BY chain.ent_uid
ORDER BY chain.ent_uid;
