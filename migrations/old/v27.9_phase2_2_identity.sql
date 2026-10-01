-- =====================================================================
-- v27.9 Phase 2.2 — Seed Identity Layer + test same_as/distinct_from
-- =====================================================================

-- Step 1: Add a duplicate entity (alias for coil:generic)
INSERT OR IGNORE INTO e01_200_03_tb 
(ent_uid, type_id, nature, label, description, label_norm, desc_norm)
VALUES (
  'coil:generic-alias',
  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='IgnitionCoil'),
  'concept',
  'Coil (duplicate entry)',
  'duplicate entry for testing identity layer',
  'coil duplicate',
  'duplicate entry for testing identity layer'
);

-- Step 2: Add same_as claim (needs ent_a_id < ent_b_id per CHECK)
INSERT OR IGNORE INTO e01_300_01_tb 
(ent_a_id, ent_b_id, clm_type, purpose, status, prv_id)
SELECT 
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='coil:generic'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='coil:generic-alias'),
  'same_as',
  'coil:generic has an alias entry',
  'asserted',
  1
WHERE (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='coil:generic') 
    < (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='coil:generic-alias');

-- Step 3: Add distinct_from claim (two clearly different entities)
INSERT OR IGNORE INTO e01_300_01_tb 
(ent_a_id, ent_b_id, clm_type, purpose, status, prv_id)
SELECT 
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='coil:generic'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='battery:generic'),
  'distinct_from',
  'coil and battery are different components',
  'asserted',
  1
WHERE (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='coil:generic') 
    < (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='battery:generic');

-- Step 4: Verify what got inserted
-- (the WHERE clauses ensure CHECK constraint never fails)

-- Log
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v27.9_phase2_2_identity', 'Seeded Identity layer: 1 same_as + 1 distinct_from');

-- Bump
UPDATE e01_676_02_tb SET schema_ver = 47, last_scan_at = datetime('now') WHERE id = 1;
