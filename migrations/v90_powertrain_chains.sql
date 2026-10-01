-- v90 — زنجیره‌های کارکردی دامنه پیشرانه
.mode column
.headers on

BEGIN;

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id)
SELECT 'fn:' || p.uid, 
       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='FunctionalChain'),
       'concept', p.label, p.descr, 2
FROM (
  SELECT 'cooling-chain' AS uid, 'زنجیره خنک‌کننده' AS label, 'Engine cooling flow' AS descr UNION ALL
  SELECT 'exhaust-chain', 'زنجیره اگزوز', 'Exhaust treatment flow' UNION ALL
  SELECT 'transmission-chain', 'زنجیره انتقال قدرت', 'Torque transmission' UNION ALL
  SELECT 'special-cargo-chain', 'زنجیره حمل ویژه', 'Refrigeration and tank' UNION ALL
  SELECT 'powertrain-super-chain', 'زنجیره کل پیشرانه', 'Powertrain super chain'
) p;

INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || REPLACE(p.part, ':', '-') || '-plays-in-' || REPLACE(p.chain, ':', '-'),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='plays_role_in'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.part),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.chain),
  'asserted', 2
FROM (
  SELECT 'concept:coolant-sensor' AS part, 'fn:cooling-chain' AS chain UNION ALL
  SELECT 'concept:engine-ecu',              'fn:cooling-chain' UNION ALL
  SELECT 'concept:thermostat',              'fn:cooling-chain' UNION ALL
  SELECT 'concept:water-pump',              'fn:cooling-chain' UNION ALL
  SELECT 'concept:radiator',                'fn:cooling-chain' UNION ALL
  SELECT 'concept:cooling-fan-relay',       'fn:cooling-chain' UNION ALL
  SELECT 'concept:cooling-fan',             'fn:cooling-chain' UNION ALL
  SELECT 'concept:engine-ecu',              'fn:exhaust-chain' UNION ALL
  SELECT 'concept:exhaust-manifold',        'fn:exhaust-chain' UNION ALL
  SELECT 'concept:upstream-o2',             'fn:exhaust-chain' UNION ALL
  SELECT 'concept:catalytic-converter',     'fn:exhaust-chain' UNION ALL
  SELECT 'concept:downstream-o2',           'fn:exhaust-chain' UNION ALL
  SELECT 'concept:muffler',                 'fn:exhaust-chain' UNION ALL
  SELECT 'concept:exhaust-pipe',            'fn:exhaust-chain' UNION ALL
  SELECT 'concept:engine-ecu',              'fn:transmission-chain' UNION ALL
  SELECT 'concept:transmission-ecu',        'fn:transmission-chain' UNION ALL
  SELECT 'concept:clutch',                  'fn:transmission-chain' UNION ALL
  SELECT 'concept:transmission',            'fn:transmission-chain' UNION ALL
  SELECT 'concept:drive-shaft',             'fn:transmission-chain' UNION ALL
  SELECT 'concept:differential',            'fn:transmission-chain' UNION ALL
  SELECT 'concept:reefer',                  'fn:special-cargo-chain' UNION ALL
  SELECT 'concept:tank',                    'fn:special-cargo-chain' UNION ALL
  SELECT 'concept:hydraulic-lift',          'fn:special-cargo-chain'
) p
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.part)
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.chain)
  AND NOT EXISTS (
    SELECT 1 FROM e01_222_01_tb r
    WHERE r.rel_uid = 'r:' || REPLACE(p.part, ':', '-') || '-plays-in-' || REPLACE(p.chain, ':', '-')
  );

INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || REPLACE(p.sub, ':', '-') || '-plays-in-' || REPLACE(p.super, ':', '-'),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='plays_role_in'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.sub),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.super),
  'asserted', 2
FROM (
  SELECT 'fn:ignition-chain' AS sub, 'fn:powertrain-super-chain' AS super UNION ALL
  SELECT 'fn:fuel-chain',             'fn:powertrain-super-chain' UNION ALL
  SELECT 'fn:cooling-chain',          'fn:powertrain-super-chain' UNION ALL
  SELECT 'fn:exhaust-chain',          'fn:powertrain-super-chain' UNION ALL
  SELECT 'fn:transmission-chain',     'fn:powertrain-super-chain' UNION ALL
  SELECT 'fn:special-cargo-chain',    'fn:powertrain-super-chain' UNION ALL
  SELECT 'fn:combustion-chain',       'fn:powertrain-super-chain'
) p
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.sub)
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.super)
  AND NOT EXISTS (
    SELECT 1 FROM e01_222_01_tb r
    WHERE r.rel_uid = 'r:' || REPLACE(p.sub, ':', '-') || '-plays-in-' || REPLACE(p.super, ':', '-')
  );

INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v90_powertrain_chains','5 functional chains for powertrain domain');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

SELECT 'entities' AS k, COUNT(*) AS n FROM e01_200_03_tb
UNION ALL SELECT 'relations', COUNT(*) FROM e01_222_01_tb;

SELECT '=== زنجیره‌های پیشرانه ===' AS section;
SELECT chain.label AS chain, COUNT(*) AS n_roles
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='plays_role_in'
JOIN e01_200_03_tb chain ON chain.ent_id = r.obj_ent_id
WHERE chain.ent_uid IN ('fn:cooling-chain','fn:exhaust-chain','fn:transmission-chain','fn:special-cargo-chain','fn:powertrain-super-chain')
  AND r.status='asserted' AND r.superseded_at IS NULL
GROUP BY chain.ent_uid;
