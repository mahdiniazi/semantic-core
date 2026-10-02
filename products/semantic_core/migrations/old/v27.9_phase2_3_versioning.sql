-- =====================================================================
-- v27.9 Phase 2.3 — Seed Versioning Layer + test supersedes chain
-- =====================================================================

-- Step 1: Create initial version (v1) for coil:generic
INSERT OR IGNORE INTO e01_330_01_tb 
(ent_id, vers_label, valid_from, status)
SELECT 
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='coil:generic'),
  'v1.0',
  '2024-01-01',
  'approved';

-- Step 2: Create second version (v2) with supersedes
INSERT OR IGNORE INTO e01_330_01_tb 
(ent_id, vers_label, valid_from, status, supersedes_id)
SELECT 
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='coil:generic'),
  'v2.0',
  '2024-06-01',
  'approved',
  (SELECT vers_id FROM e01_330_01_tb 
   WHERE ent_id = (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='coil:generic')
     AND vers_label = 'v1.0');

-- Step 3: Create snapshot for v1.0
INSERT OR IGNORE INTO e01_330_02_tb 
(ent_id, snap_at, vers_id, schema_ver, snap_data, reason)
SELECT 
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='coil:generic'),
  '2024-01-01 00:00:00',
  (SELECT vers_id FROM e01_330_01_tb 
   WHERE ent_id = (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='coil:generic')
     AND vers_label = 'v1.0'),
  'v26.0',
  '{"label":"Coil","description":"standard"}',
  'initial version';

-- Step 4: Create snapshot for v2.0
INSERT OR IGNORE INTO e01_330_02_tb 
(ent_id, snap_at, vers_id, schema_ver, snap_data, reason)
SELECT 
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='coil:generic'),
  '2024-06-01 00:00:00',
  (SELECT vers_id FROM e01_330_01_tb 
   WHERE ent_id = (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='coil:generic')
     AND vers_label = 'v2.0'),
  'v27.0',
  '{"label":"Coil","description":"standard 4-pin"}',
  'added pin info';

-- Log
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v27.9_phase2_3_versioning', 'Seeded Versioning layer: 2 versions + 2 snapshots');

-- Bump
UPDATE e01_676_02_tb SET schema_ver = 48, last_scan_at = datetime('now') WHERE id = 1;
