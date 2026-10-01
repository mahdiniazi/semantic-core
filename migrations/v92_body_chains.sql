-- v92 — زنجیره‌های کارکردی دامنه بدنه
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
  SELECT 'lighting-chain' AS uid, 'زنجیره روشنایی' AS label, 'Lighting flow' AS descr UNION ALL
  SELECT 'comfort-chain', 'زنجیره راحتی', 'Comfort flow' UNION ALL
  SELECT 'hvac-chain', 'زنجیره تهویه', 'HVAC flow' UNION ALL
  SELECT 'airbag-chain', 'زنجیره ایربگ', 'Airbag flow' UNION ALL
  SELECT 'dashboard-chain', 'زنجیره داشبورد', 'Dashboard flow' UNION ALL
  SELECT 'emergency-chain', 'زنجیره هشدار و امداد', 'Emergency flow' UNION ALL
  SELECT 'body-super-chain', 'زنجیره کل بدنه', 'Body super chain'
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
  -- زنجیره روشنایی
  SELECT 'concept:headlight-low' AS part, 'fn:lighting-chain' AS chain UNION ALL
  SELECT 'concept:headlight-high',           'fn:lighting-chain' UNION ALL
  SELECT 'concept:tail-light',               'fn:lighting-chain' UNION ALL
  SELECT 'concept:brake-light',              'fn:lighting-chain' UNION ALL
  SELECT 'concept:turn-signal',              'fn:lighting-chain' UNION ALL
  SELECT 'concept:reverse-light',            'fn:lighting-chain' UNION ALL
  SELECT 'concept:fog-light',                'fn:lighting-chain' UNION ALL
  SELECT 'concept:interior-light',           'fn:lighting-chain' UNION ALL
  -- زنجیره راحتی
  SELECT 'concept:seat',                     'fn:comfort-chain' UNION ALL
  SELECT 'concept:door',                     'fn:comfort-chain' UNION ALL
  SELECT 'concept:window',                   'fn:comfort-chain' UNION ALL
  SELECT 'concept:windshield',               'fn:comfort-chain' UNION ALL
  SELECT 'concept:mirror',                   'fn:comfort-chain' UNION ALL
  SELECT 'concept:wiper-motor',              'fn:comfort-chain' UNION ALL
  SELECT 'concept:wiper-blade',              'fn:comfort-chain' UNION ALL
  SELECT 'concept:door-lock',                'fn:comfort-chain' UNION ALL
  -- زنجیره تهویه
  SELECT 'concept:ac-refrigerant',           'fn:hvac-chain' UNION ALL
  SELECT 'concept:ac-compressor',            'fn:hvac-chain' UNION ALL
  SELECT 'concept:ac-condenser',             'fn:hvac-chain' UNION ALL
  SELECT 'concept:ac-expansion',             'fn:hvac-chain' UNION ALL
  SELECT 'concept:heater-core',              'fn:hvac-chain' UNION ALL
  SELECT 'concept:blower-motor',             'fn:hvac-chain' UNION ALL
  SELECT 'concept:cabin-filter',             'fn:hvac-chain' UNION ALL
  -- زنجیره ایربگ
  SELECT 'concept:crash-sensor',             'fn:airbag-chain' UNION ALL
  SELECT 'concept:airbag',                   'fn:airbag-chain' UNION ALL
  SELECT 'concept:seatbelt-pretensioner',    'fn:airbag-chain' UNION ALL
  SELECT 'concept:seatbelt',                 'fn:airbag-chain' UNION ALL
  -- زنجیره داشبورد
  SELECT 'concept:coolant-sensor',           'fn:dashboard-chain' UNION ALL
  SELECT 'concept:fuel-level',               'fn:dashboard-chain' UNION ALL
  SELECT 'concept:vss',                      'fn:dashboard-chain' UNION ALL
  SELECT 'concept:speedometer',              'fn:dashboard-chain' UNION ALL
  SELECT 'concept:tachometer',               'fn:dashboard-chain' UNION ALL
  SELECT 'concept:fuel-gauge',               'fn:dashboard-chain' UNION ALL
  SELECT 'concept:coolant-gauge',            'fn:dashboard-chain' UNION ALL
  SELECT 'concept:check-engine-light',       'fn:dashboard-chain' UNION ALL
  -- زنجیره هشدار و امداد
  SELECT 'concept:siren',                    'fn:emergency-chain' UNION ALL
  SELECT 'concept:warning-light',            'fn:emergency-chain' UNION ALL
  SELECT 'concept:wheelchair-ramp',          'fn:emergency-chain' UNION ALL
  SELECT 'concept:fire-pump',                'fn:emergency-chain' UNION ALL
  SELECT 'concept:ladder',                   'fn:emergency-chain' UNION ALL
  SELECT 'concept:hydraulic-lift',           'fn:emergency-chain'
) p
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.part)
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.chain)
  AND NOT EXISTS (
    SELECT 1 FROM e01_222_01_tb r
    WHERE r.rel_uid = 'r:' || REPLACE(p.part, ':', '-') || '-plays-in-' || REPLACE(p.chain, ':', '-')
  );

-- ═══════════════════════════════════════════════════════
-- ۳. زنجیره کل بدنه: زیرزنجیره‌ها
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || REPLACE(p.sub, ':', '-') || '-plays-in-' || REPLACE(p.super, ':', '-'),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='plays_role_in'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.sub),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.super),
  'asserted', 2
FROM (
  SELECT 'fn:lighting-chain' AS sub, 'fn:body-super-chain' AS super UNION ALL
  SELECT 'fn:comfort-chain',          'fn:body-super-chain' UNION ALL
  SELECT 'fn:hvac-chain',             'fn:body-super-chain' UNION ALL
  SELECT 'fn:airbag-chain',           'fn:body-super-chain' UNION ALL
  SELECT 'fn:dashboard-chain',        'fn:body-super-chain' UNION ALL
  SELECT 'fn:emergency-chain',        'fn:body-super-chain'
) p
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.sub)
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.super)
  AND NOT EXISTS (
    SELECT 1 FROM e01_222_01_tb r
    WHERE r.rel_uid = 'r:' || REPLACE(p.sub, ':', '-') || '-plays-in-' || REPLACE(p.super, ':', '-')
  );

INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v92_body_chains','7 functional chains for body domain');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- ═══════════════════════════════════════════════════════
-- گزارش
-- ═══════════════════════════════════════════════════════
SELECT 'entities' AS k, COUNT(*) AS n FROM e01_200_03_tb
UNION ALL SELECT 'relations', COUNT(*) FROM e01_222_01_tb;

SELECT '=== زنجیره‌های بدنه ===' AS section;
SELECT 
  chain.label AS chain,
  GROUP_CONCAT(part.label, ' → ') AS roles
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='plays_role_in'
JOIN e01_200_03_tb part ON part.ent_id = r.subj_ent_id
JOIN e01_200_03_tb chain ON chain.ent_id = r.obj_ent_id
WHERE chain.ent_uid IN ('fn:lighting-chain','fn:comfort-chain','fn:hvac-chain','fn:airbag-chain','fn:dashboard-chain','fn:emergency-chain','fn:body-super-chain')
  AND r.status='asserted' AND r.superseded_at IS NULL
GROUP BY chain.ent_uid
ORDER BY chain.ent_uid;
