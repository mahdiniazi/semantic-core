-- v91 — زنجیره‌های کارکردی دامنه شاسی
.mode column
.headers on

BEGIN;

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id)
SELECT 'fn:' || p.uid, 
       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='FunctionalChain'),
       'concept', p.label, p.descr, 2
FROM (
  SELECT 'braking-chain' AS uid, 'زنجیره ترمز' AS label, 'Braking flow' AS descr UNION ALL
  SELECT 'abs-chain', 'زنجیره ABS', 'Anti-lock braking' UNION ALL
  SELECT 'steering-chain', 'زنجیره فرمان', 'Steering flow' UNION ALL
  SELECT 'suspension-chain', 'زنجیره تعلیق', 'Suspension flow' UNION ALL
  SELECT 'chassis-super-chain', 'زنجیره کل شاسی', 'Chassis super chain'
) p;

INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || REPLACE(p.part, ':', '-') || '-plays-in-' || REPLACE(p.chain, ':', '-'),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='plays_role_in'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.part),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.chain),
  'asserted', 2
FROM (
  SELECT 'concept:brake-pad' AS part, 'fn:braking-chain' AS chain UNION ALL
  SELECT 'concept:brake-disc',              'fn:braking-chain' UNION ALL
  SELECT 'concept:brake-caliper',           'fn:braking-chain' UNION ALL
  SELECT 'concept:brake-fluid',             'fn:braking-chain' UNION ALL
  SELECT 'concept:brake-line',              'fn:braking-chain' UNION ALL
  SELECT 'concept:brake-booster',           'fn:braking-chain' UNION ALL
  SELECT 'concept:brake-master',            'fn:braking-chain' UNION ALL
  SELECT 'concept:brake-drum',              'fn:braking-chain' UNION ALL
  SELECT 'concept:brake-shoe',              'fn:braking-chain' UNION ALL
  SELECT 'concept:abs-sensor',              'fn:abs-chain' UNION ALL
  SELECT 'concept:abs-ecu',                 'fn:abs-chain' UNION ALL
  SELECT 'concept:abs-module',              'fn:abs-chain' UNION ALL
  SELECT 'concept:brake-caliper',           'fn:abs-chain' UNION ALL
  SELECT 'concept:steering-wheel',          'fn:steering-chain' UNION ALL
  SELECT 'concept:steering-column',         'fn:steering-chain' UNION ALL
  SELECT 'concept:steering-rack',           'fn:steering-chain' UNION ALL
  SELECT 'concept:power-steering',          'fn:steering-chain' UNION ALL
  SELECT 'concept:tie-rod',                 'fn:steering-chain' UNION ALL
  SELECT 'concept:wheel',                   'fn:steering-chain' UNION ALL
  SELECT 'concept:wheel',                   'fn:suspension-chain' UNION ALL
  SELECT 'concept:control-arm',             'fn:suspension-chain' UNION ALL
  SELECT 'concept:ball-joint',              'fn:suspension-chain' UNION ALL
  SELECT 'concept:coil-spring',             'fn:suspension-chain' UNION ALL
  SELECT 'concept:shock-absorber',          'fn:suspension-chain' UNION ALL
  SELECT 'concept:bushing',                 'fn:suspension-chain' UNION ALL
  SELECT 'concept:wheel-bearing',           'fn:suspension-chain' UNION ALL
  SELECT 'concept:sway-bar',                'fn:suspension-chain'
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
  SELECT 'fn:braking-chain' AS sub, 'fn:chassis-super-chain' AS super UNION ALL
  SELECT 'fn:abs-chain',                'fn:chassis-super-chain' UNION ALL
  SELECT 'fn:steering-chain',           'fn:chassis-super-chain' UNION ALL
  SELECT 'fn:suspension-chain',         'fn:chassis-super-chain'
) p
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.sub)
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.super)
  AND NOT EXISTS (
    SELECT 1 FROM e01_222_01_tb r
    WHERE r.rel_uid = 'r:' || REPLACE(p.sub, ':', '-') || '-plays-in-' || REPLACE(p.super, ':', '-')
  );

INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v91_chassis_chains','5 functional chains for chassis domain');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

SELECT 'entities' AS k, COUNT(*) AS n FROM e01_200_03_tb
UNION ALL SELECT 'relations', COUNT(*) FROM e01_222_01_tb;

SELECT '=== زنجیره‌های شاسی ===' AS section;
SELECT 
  chain.label AS chain,
  GROUP_CONCAT(part.label, ' → ') AS roles
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='plays_role_in'
JOIN e01_200_03_tb part ON part.ent_id = r.subj_ent_id
JOIN e01_200_03_tb chain ON chain.ent_id = r.obj_ent_id
WHERE chain.ent_uid IN ('fn:braking-chain','fn:abs-chain','fn:steering-chain','fn:suspension-chain','fn:chassis-super-chain')
  AND r.status='asserted' AND r.superseded_at IS NULL
GROUP BY chain.ent_uid
ORDER BY chain.ent_uid;
