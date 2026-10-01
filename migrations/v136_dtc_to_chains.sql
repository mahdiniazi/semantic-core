-- v136 — اتصال 48 DTC یتیم به زنجیره‌های کارکردی
.mode column
.headers on

BEGIN;

-- ═══ PRE-CHECK ═══
SELECT '=== PRE: 6 trigger جدید ===' AS section;
SELECT name FROM sqlite_master WHERE type='trigger'
  AND name NOT IN (
    SELECT name FROM sqlite_master 
    WHERE type='trigger' AND rowid < (SELECT MAX(rowid)-6 FROM sqlite_master WHERE type='trigger')
  )
ORDER BY name LIMIT 10;

-- ═══ STEP 1: ایجاد reltype جدید ═══
INSERT OR IGNORE INTO e01_202_01_tb (type_uid, label, is_transitive)
VALUES ('belongs_to_chain', 'تعلق دارد به زنجیره', 0);

-- ═══ STEP 2: نگاشت DTC → chain ═══
CREATE TEMP TABLE IF NOT EXISTS dtc_chain_map AS
SELECT * FROM (
  SELECT 'dtc:C0035' AS dtc_uid, 'fn:braking-chain' AS chain_uid UNION ALL
  SELECT 'dtc:C0040', 'fn:braking-chain' UNION ALL
  SELECT 'dtc:C0050', 'fn:braking-chain' UNION ALL
  SELECT 'dtc:C0110', 'fn:braking-chain' UNION ALL
  SELECT 'dtc:C0265', 'fn:braking-chain' UNION ALL
  SELECT 'dtc:C0710', 'fn:suspension-chain' UNION ALL
  SELECT 'dtc:C1145', 'fn:suspension-chain' UNION ALL
  SELECT 'dtc:C1234', 'fn:suspension-chain' UNION ALL
  SELECT 'dtc:C1200', 'fn:steering-chain' UNION ALL
  SELECT 'dtc:C1201', 'fn:steering-chain' UNION ALL
  SELECT 'dtc:C1202', 'fn:steering-chain' UNION ALL
  SELECT 'dtc:B1421', 'fn:hvac-chain' UNION ALL
  SELECT 'dtc:B1422', 'fn:hvac-chain' UNION ALL
  SELECT 'dtc:B1423', 'fn:hvac-chain' UNION ALL
  SELECT 'dtc:B1424', 'fn:hvac-chain' UNION ALL
  SELECT 'dtc:B1425', 'fn:hvac-chain' UNION ALL
  SELECT 'dtc:B1101', 'fn:body-super-chain' UNION ALL
  SELECT 'dtc:B1102', 'fn:body-super-chain' UNION ALL
  SELECT 'dtc:P0100', 'fn:sensor-chain' UNION ALL
  SELECT 'dtc:P0110', 'fn:sensor-chain' UNION ALL
  SELECT 'dtc:P0115', 'fn:sensor-chain' UNION ALL
  SELECT 'dtc:P0120', 'fn:sensor-chain' UNION ALL
  SELECT 'dtc:P0121', 'fn:sensor-chain' UNION ALL
  SELECT 'dtc:P0130', 'fn:sensor-chain' UNION ALL
  SELECT 'dtc:P0135', 'fn:sensor-chain' UNION ALL
  SELECT 'dtc:P0170', 'fn:fuel-chain' UNION ALL
  SELECT 'dtc:P0201', 'fn:fuel-chain' UNION ALL
  SELECT 'dtc:P0202', 'fn:fuel-chain' UNION ALL
  SELECT 'dtc:P0203', 'fn:fuel-chain' UNION ALL
  SELECT 'dtc:P0204', 'fn:fuel-chain' UNION ALL
  SELECT 'dtc:P0230', 'fn:fuel-chain' UNION ALL
  SELECT 'dtc:P0231', 'fn:fuel-chain' UNION ALL
  SELECT 'dtc:P0300', 'fn:ignition-chain' UNION ALL
  SELECT 'dtc:P0301', 'fn:ignition-chain' UNION ALL
  SELECT 'dtc:P0325', 'fn:sensor-chain' UNION ALL
  SELECT 'dtc:P0335', 'fn:sensor-chain' UNION ALL
  SELECT 'dtc:P0340', 'fn:sensor-chain' UNION ALL
  SELECT 'dtc:P0400', 'fn:exhaust-chain' UNION ALL
  SELECT 'dtc:P0403', 'fn:exhaust-chain' UNION ALL
  SELECT 'dtc:P0420', 'fn:exhaust-chain' UNION ALL
  SELECT 'dtc:P0440', 'fn:ev-chain' UNION ALL
  SELECT 'dtc:P0480', 'fn:cooling-chain' UNION ALL
  SELECT 'dtc:P0481', 'fn:cooling-chain' UNION ALL
  SELECT 'dtc:P0500', 'fn:sensor-chain' UNION ALL
  SELECT 'dtc:P0505', 'fn:sensor-chain' UNION ALL
  SELECT 'dtc:P0507', 'fn:sensor-chain' UNION ALL
  SELECT 'dtc:P0520', 'fn:sensor-chain' UNION ALL
  SELECT 'dtc:U0100', 'fn:bus-chain'
);

-- ═══ STEP 3: درج 48 رابطه ═══
INSERT OR IGNORE INTO e01_222_01_tb
  (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || lower(substr(m.dtc_uid, 5)) || '-in-' || replace(m.chain_uid, 'fn:', ''),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='belongs_to_chain'),
  d.ent_id,
  c.ent_id,
  'asserted',
  2
FROM dtc_chain_map m
JOIN e01_200_03_tb d ON d.ent_uid = m.dtc_uid
JOIN e01_200_03_tb c ON c.ent_uid = m.chain_uid;

DROP TABLE dtc_chain_map;

-- ═══ STEP 4: log و bump ═══
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v136_dtc_to_chains',
        'Connected 48 orphan DTCs to functional chains');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- ═══ POST-CHECK ═══
SELECT '=== POST 1: reltype جدید ===' AS section;
SELECT type_uid, label FROM e01_202_01_tb WHERE type_uid='belongs_to_chain';

SELECT '=== POST 2: تعداد روابط DTC→chain ===' AS section;
SELECT COUNT(*) AS n FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id=r.reltype_id
WHERE rt.type_uid='belongs_to_chain';

SELECT '=== POST 3: توزیع DTC بر زنجیره ===' AS section;
SELECT c.label AS chain_label, COUNT(*) AS n
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id=r.reltype_id
JOIN e01_200_03_tb c ON c.ent_id=r.obj_ent_id
WHERE rt.type_uid='belongs_to_chain'
GROUP BY c.ent_uid ORDER BY n DESC;

SELECT '=== POST 4: DTCهای باقی‌مانده یتیم ===' AS section;
SELECT COUNT(*) AS still_orphan FROM e01_200_03_tb d
WHERE d.ent_uid LIKE 'dtc:%'
  AND NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.subj_ent_id=d.ent_id);

SELECT '=== POST 5: health ===' AS section;
SELECT severity, COUNT(*) AS n FROM e04_900_02_vw GROUP BY severity;
