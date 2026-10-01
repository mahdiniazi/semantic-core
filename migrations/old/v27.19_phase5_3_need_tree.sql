-- =====================================================================
-- v27.19 Phase 5.3 — Materialized need tree cache
-- =====================================================================

-- Step 1: Create cache table (WITHOUT ROWID)
CREATE TABLE IF NOT EXISTS e01_506_12_tb (
    need_uid     TEXT NOT NULL,
    node_id      INTEGER NOT NULL,
    question_uid TEXT NOT NULL,
    slot         TEXT,
    answer_text  TEXT,
    status       TEXT,
    depth        INTEGER NOT NULL DEFAULT 0,
    path         TEXT,
    cached_at    TEXT NOT NULL DEFAULT (datetime('now')),
    PRIMARY KEY (need_uid, node_id)
) WITHOUT ROWID;

CREATE INDEX IF NOT EXISTS e02_506_12_ix 
    ON e01_506_12_tb(need_uid, depth);
CREATE INDEX IF NOT EXISTS e02_506_13_ix 
    ON e01_506_12_tb(need_uid, question_uid);

-- Step 2: Populate cache from recursive tree
INSERT OR REPLACE INTO e01_506_12_tb 
    (need_uid, node_id, question_uid, slot, answer_text, status, depth, path)
WITH RECURSIVE tree AS (
    SELECT 
        n.need_uid,
        x.node_id,
        x.question_uid,
        x.slot,
        x.answer_text,
        x.status,
        0 AS depth,
        printf('%04d', x.ordinal) AS path
    FROM e01_506_06_tb x
    JOIN e01_506_01_tb n ON n.need_uid = x.need_uid
    WHERE x.parent_id IS NULL
    UNION ALL
    SELECT 
        t.need_uid,
        x.node_id,
        x.question_uid,
        x.slot,
        x.answer_text,
        x.status,
        t.depth + 1,
        t.path || '.' || printf('%04d', x.ordinal)
    FROM tree t
    JOIN e01_506_06_tb x ON x.parent_id = t.node_id
    WHERE t.depth < 50
)
SELECT need_uid, node_id, question_uid, slot, answer_text, status, depth, path
FROM tree;

-- Step 3: Register in element registry
INSERT OR IGNORE INTO e01_506_03_tb 
    (element_name, element_layer, element_kind, element_level)
VALUES 
    ('e01_506_12_tb', 'M', 'tb', 1),
    ('e02_506_12_ix', 'M', 'ix', 2),
    ('e02_506_13_ix', 'M', 'ix', 2);

-- Step 4: Log
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v27.19_phase5_3', 'Materialized need tree cache');

-- Step 5: Bump
UPDATE e01_676_02_tb SET schema_ver = 59 WHERE id = 1;
