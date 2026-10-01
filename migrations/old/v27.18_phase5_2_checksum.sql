-- =====================================================================
-- v27.18 Phase 5.2 — Checksum + Statistics
-- =====================================================================

-- Step 1: Add checksum column to schema state
ALTER TABLE e01_676_02_tb ADD COLUMN checksum TEXT;
ALTER TABLE e01_676_02_tb ADD COLUMN counted_tables INTEGER;
ALTER TABLE e01_676_02_tb ADD COLUMN counted_triggers INTEGER;
ALTER TABLE e01_676_02_tb ADD COLUMN counted_views INTEGER;

-- Step 2: Compute checksum from DDL
UPDATE e01_676_02_tb
SET 
    checksum = (
        SELECT lower(hex(sha3(
            group_concat(sql, '|||'), 
            256
        )))
        FROM (
            SELECT sql FROM sqlite_master 
            WHERE type IN ('table','trigger','view','index')
              AND name NOT LIKE 'sqlite_%'
              AND name NOT LIKE '%_data'
              AND name NOT LIKE '%_idx'
              AND name NOT LIKE '%_content'
              AND name NOT LIKE '%_docsize'
              AND name NOT LIKE '%_config'
            ORDER BY type, name
        )
    ),
    counted_tables = (SELECT COUNT(*) FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%' AND name NOT LIKE 'e02_404_01_ft%'),
    counted_triggers = (SELECT COUNT(*) FROM sqlite_master WHERE type='trigger'),
    counted_views = (SELECT COUNT(*) FROM sqlite_master WHERE type='view'),
    last_scan_at = datetime('now')
WHERE id = 1;

-- Step 3: Verify (if sha3() is not available, use md5 or fallback)
-- If sha3 not available, use a simpler checksum
UPDATE e01_676_02_tb
SET checksum = (
    SELECT 'v1:' || CAST(SUM(LENGTH(sql)) AS TEXT) || ':' || CAST(COUNT(*) AS TEXT)
    FROM sqlite_master 
    WHERE type IN ('table','trigger','view','index')
      AND name NOT LIKE 'sqlite_%'
)
WHERE checksum IS NULL AND id = 1;

-- Step 4: ANALYZE for statistics
ANALYZE;
ANALYZE e01_222_01_tb;
ANALYZE e01_200_03_tb;
ANALYZE e01_506_02_tb;
ANALYZE e01_506_04_tb;
ANALYZE e01_778_02_tb;
ANALYZE e01_120_01_tb;

-- Log
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v27.18_phase5_2', 'Checksum + ANALYZE statistics');

-- Bump
UPDATE e01_676_02_tb SET schema_ver = 58 WHERE id = 1;
