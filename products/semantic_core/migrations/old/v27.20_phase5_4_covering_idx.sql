-- =====================================================================
-- v27.20 Phase 5.4 — Covering indexes for hot queries
-- =====================================================================

-- Composite index: subject + reltype + object (current relations)
CREATE INDEX IF NOT EXISTS e02_222_21_ix 
    ON e01_222_01_tb(subj_ent_id, reltype_id, obj_ent_id, status)
    WHERE superseded_at IS NULL;

-- Composite index: object + reltype + subject (reverse lookup)
CREATE INDEX IF NOT EXISTS e02_222_22_ix 
    ON e01_222_01_tb(obj_ent_id, reltype_id, subj_ent_id, status)
    WHERE superseded_at IS NULL AND obj_ent_id IS NOT NULL;

-- Partial index for current relations
CREATE INDEX IF NOT EXISTS e02_222_23_ix 
    ON e01_222_01_tb(reltype_id, subj_ent_id)
    WHERE superseded_at IS NULL AND status = 'asserted';

-- Index for temporal queries (current valid)
CREATE INDEX IF NOT EXISTS e02_222_24_ix 
    ON e01_222_01_tb(valid_from, valid_to)
    WHERE valid_to IS NULL OR valid_to > datetime('now');

-- Index for entity type + status
CREATE INDEX IF NOT EXISTS e02_200_25_ix 
    ON e01_200_03_tb(type_id, status)
    WHERE status = 'active';

-- Register indexes
INSERT OR IGNORE INTO e01_506_03_tb 
    (element_name, element_layer, element_kind, element_level)
VALUES 
    ('e02_222_21_ix', 'C', 'ix', 2),
    ('e02_222_22_ix', 'C', 'ix', 2),
    ('e02_222_23_ix', 'C', 'ix', 2),
    ('e02_222_24_ix', 'C', 'ix', 2),
    ('e02_200_25_ix', 'C', 'ix', 2);

-- Re-ANALYZE
ANALYZE e01_222_01_tb;
ANALYZE e01_200_03_tb;

-- Log
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v27.20_phase5_4', 'Covering indexes for hot queries');

-- Bump
UPDATE e01_676_02_tb SET schema_ver = 60 WHERE id = 1;
