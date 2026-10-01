-- =====================================================================
-- v27.9 Phase 2.1 — Seed Context Layer + test ctx_key mechanism
-- =====================================================================

-- Step 1: Add sample context entities
INSERT OR IGNORE INTO e01_200_03_tb 
(ent_uid, type_id, nature, label, description, label_norm, desc_norm)
VALUES 
('cond:cold-start', 
 (SELECT type_id FROM e01_200_01_tb WHERE type_uid='OperatingState'),
 'concept', 'Cold start', 'engine cold start condition',
 'cold start', 'engine cold start condition'),
('env:high-humidity',
 (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Configuration'),
 'concept', 'High humidity', 'humidity above 80 percent',
 'high humidity', 'humidity above 80 percent'),
('env:hot-weather',
 (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Configuration'),
 'concept', 'Hot weather', 'ambient temp above 40C',
 'hot weather', 'ambient temp above 40c');

-- Step 2: Add context to existing relation r:coil-has-fmopen
INSERT OR IGNORE INTO e01_305_03_tb (rel_id, ctx_ent_id, role)
SELECT r.rel_id, e.ent_id, 'condition'
FROM e01_222_01_tb r, e01_200_03_tb e
WHERE r.rel_uid='r:coil-has-fmopen'
  AND e.ent_uid='cond:cold-start';

INSERT OR IGNORE INTO e01_305_03_tb (rel_id, ctx_ent_id, role)
SELECT r.rel_id, e.ent_id, 'environment'
FROM e01_222_01_tb r, e01_200_03_tb e
WHERE r.rel_uid='r:coil-has-fmopen'
  AND e.ent_uid='env:high-humidity';

-- Step 3: Add context to relation r:coil-has-fmshort (single context)
INSERT OR IGNORE INTO e01_305_03_tb (rel_id, ctx_ent_id, role)
SELECT r.rel_id, e.ent_id, 'environment'
FROM e01_222_01_tb r, e01_200_03_tb e
WHERE r.rel_uid='r:coil-has-fmshort'
  AND e.ent_uid='env:hot-weather';

-- Log
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v27.9_phase2_1_context', 'Seeded Context layer + tested ctx_key trigger');

-- Bump
UPDATE e01_676_02_tb SET schema_ver = 46, last_scan_at = datetime('now') WHERE id = 1;
