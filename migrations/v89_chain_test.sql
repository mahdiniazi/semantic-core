-- v89 — تست plays_role_in روی زنجیره جرقه‌زنی
.mode column
.headers on

BEGIN;

-- ═══════════════════════════════════════════════════════
-- ۱. اصلاح label part_of
-- ═══════════════════════════════════════════════════════
UPDATE e01_202_01_tb SET label='بخشی از' WHERE type_uid='part_of';

-- ═══════════════════════════════════════════════════════
-- ۲. ساخت یک زنجیره کارکردی نمونه: احتراق
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('fn:ignition-chain',
 (SELECT type_id FROM e01_200_01_tb WHERE type_uid='FunctionalChain'),
 'concept','زنجیره جرقه‌زنی','Ignition functional chain',2),
('fn:fuel-chain',
 (SELECT type_id FROM e01_200_01_tb WHERE type_uid='FunctionalChain'),
 'concept','زنجیره سوخت‌رسانی','Fuel functional chain',2),
('fn:combustion-chain',
 (SELECT type_id FROM e01_200_01_tb WHERE type_uid='FunctionalChain'),
 'concept','زنجیره احتراق','Combustion functional chain',2);

-- ═══════════════════════════════════════════════════════
-- ۳. اتصال اجزا به زنجیره با plays_role_in
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || REPLACE(p.part, 'concept:', '') || '-plays-in-' || REPLACE(p.chain, 'fn:', ''),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='plays_role_in'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.part),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.chain),
  'asserted', 2
FROM (
  -- زنجیره جرقه‌زنی
  SELECT 'concept:crankshaft-sensor' AS part, 'fn:ignition-chain' AS chain UNION ALL
  SELECT 'concept:engine-ecu',                  'fn:ignition-chain' UNION ALL
  SELECT 'concept:ignition-coil',               'fn:ignition-chain' UNION ALL
  SELECT 'concept:spark-plug',                  'fn:ignition-chain' UNION ALL
  -- زنجیره سوخت‌رسانی
  SELECT 'concept:fuel-pump',                   'fn:fuel-chain' UNION ALL
  SELECT 'concept:fuel-tank',                   'fn:fuel-chain' UNION ALL
  SELECT 'concept:fuel-rail',                   'fn:fuel-chain' UNION ALL
  SELECT 'concept:injector',                    'fn:fuel-chain' UNION ALL
  SELECT 'concept:engine-ecu',                  'fn:fuel-chain' UNION ALL
  -- زنجیره احتراق
  SELECT 'fn:ignition-chain',                   'fn:combustion-chain' UNION ALL
  SELECT 'fn:fuel-chain',                       'fn:combustion-chain'
) p
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.part)
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.chain)
  AND NOT EXISTS (
    SELECT 1 FROM e01_222_01_tb r
    WHERE r.rel_uid = 'r:' || REPLACE(p.part, 'concept:', '') || '-plays-in-' || REPLACE(p.chain, 'fn:', '')
  );

INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v89_chain_test','Test plays_role_in on 3 functional chains');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- ═══════════════════════════════════════════════════════
-- گزارش
-- ═══════════════════════════════════════════════════════
SELECT 'entities' AS k, COUNT(*) AS n FROM e01_200_03_tb
UNION ALL SELECT 'relations', COUNT(*) FROM e01_222_01_tb;

SELECT '=== زنجیره‌های کارکردی ===' AS section;
SELECT 
  chain.label AS chain,
  GROUP_CONCAT(part.label, ' → ') AS roles
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='plays_role_in'
JOIN e01_200_03_tb part ON part.ent_id = r.subj_ent_id
JOIN e01_200_03_tb chain ON chain.ent_id = r.obj_ent_id
WHERE chain.ent_uid LIKE 'fn:%'
  AND r.status='asserted' AND r.superseded_at IS NULL
GROUP BY chain.ent_uid
ORDER BY chain.ent_uid;
