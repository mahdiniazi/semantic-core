-- =====================================================================
-- v27.10 Phase 3 — Rebalance N30 (fixed: drop immutability on need_uid)
-- =====================================================================

-- Step 1: Drop the trigger that blocks need_uid change
DROP TRIGGER IF EXISTS e03_778_10b_tr;

-- Step 2: Recreate with weakened WHEN (only element_name + policy_kind)
CREATE TRIGGER e03_778_10b_tr
BEFORE UPDATE OF element_name, policy_kind ON e01_778_05_tb
WHEN OLD.element_name <> NEW.element_name
  OR OLD.policy_kind <> NEW.policy_kind
BEGIN SELECT RAISE(ABORT, 'policy identity immutable'); END;

-- Step 3: Now do the rebalance

-- FK about type relations → N12
UPDATE e01_778_05_tb
SET need_uid = 'N12'
WHERE need_uid = 'N30' AND policy_kind = 'fk'
  AND fk_ref_id IN (
    SELECT ref_id FROM e01_378_01_tb
    WHERE parent_table LIKE 'e01_112%' OR parent_table LIKE 'e01_202%'
  );

-- FK about element registry → N70
UPDATE e01_778_05_tb
SET need_uid = 'N70'
WHERE need_uid = 'N30' AND policy_kind = 'fk'
  AND fk_ref_id IN (
    SELECT ref_id FROM e01_378_01_tb
    WHERE parent_table LIKE 'e01_506_03%'
  );

-- FK about semantic graph → N71
UPDATE e01_778_05_tb
SET need_uid = 'N71'
WHERE need_uid = 'N30' AND policy_kind = 'fk'
  AND fk_ref_id IN (
    SELECT ref_id FROM e01_378_01_tb
    WHERE child_table LIKE 'e01_778%' AND child_table <> 'e01_778_05_tb'
  );

-- FK about context → N32
UPDATE e01_778_05_tb
SET need_uid = 'N32'
WHERE need_uid = 'N30' AND policy_kind = 'fk'
  AND fk_ref_id IN (
    SELECT ref_id FROM e01_378_01_tb
    WHERE child_table LIKE 'e01_305%'
  );

-- FK about versioning → N33
UPDATE e01_778_05_tb
SET need_uid = 'N33'
WHERE need_uid = 'N30' AND policy_kind = 'fk'
  AND fk_ref_id IN (
    SELECT ref_id FROM e01_378_01_tb
    WHERE child_table LIKE 'e01_330%'
  );

-- FK about identity → N23
UPDATE e01_778_05_tb
SET need_uid = 'N23'
WHERE need_uid = 'N30' AND policy_kind = 'fk'
  AND fk_ref_id IN (
    SELECT ref_id FROM e01_378_01_tb
    WHERE child_table LIKE 'e01_300%'
  );

-- immutability about vocab → N50
UPDATE e01_778_05_tb
SET need_uid = 'N50'
WHERE need_uid = 'N30' AND policy_kind = 'immutability'
  AND element_name LIKE 'e01_506_%';

-- immutability about type/relation → N50
UPDATE e01_778_05_tb
SET need_uid = 'N50'
WHERE need_uid = 'N30' AND policy_kind = 'immutability'
  AND (element_name LIKE 'e01_200%' OR element_name LIKE 'e01_202%'
       OR element_name LIKE 'e01_112%');

-- immutability about value → N12
UPDATE e01_778_05_tb
SET need_uid = 'N12'
WHERE need_uid = 'N30' AND policy_kind = 'immutability'
  AND element_name LIKE 'e01_201%';

-- FTS guards → N41
UPDATE e01_778_05_tb
SET need_uid = 'N41'
WHERE need_uid = 'N30' AND policy_kind IN ('guard','sync')
  AND element_name LIKE 'e03_434%';

-- provenance guards → N31
UPDATE e01_778_05_tb
SET need_uid = 'N31'
WHERE need_uid = 'N30' AND policy_kind = 'guard'
  AND element_name LIKE 'e03_343%';

-- context key sync → N15
UPDATE e01_778_05_tb
SET need_uid = 'N15'
WHERE need_uid = 'N30' AND policy_kind = 'sync'
  AND element_name LIKE 'e03_135%';

-- delete guards for meta → N70
UPDATE e01_778_05_tb
SET need_uid = 'N70'
WHERE need_uid = 'N30' AND policy_kind = 'guard'
  AND element_name LIKE 'e03_320%';

-- delete guards for meta 370 → N70
UPDATE e01_778_05_tb
SET need_uid = 'N70'
WHERE need_uid = 'N30' AND policy_kind = 'guard'
  AND element_name LIKE 'e03_370%';

-- Step 4: Report
SELECT '=== AFTER REBALANCE ===' AS section;
SELECT need_uid, COUNT(*) AS cnt
FROM e01_778_05_tb
GROUP BY need_uid
ORDER BY cnt DESC
LIMIT 15;

-- Step 5: N30 final count
SELECT '=== N30 FINAL ===' AS section;
SELECT COUNT(*) AS n30_count FROM e01_778_05_tb WHERE need_uid = 'N30';

-- Log
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v27.10_phase3_fixed', 'Rebalanced N30 + weakened immutability to protect only element+kind');

-- Bump
UPDATE e01_676_02_tb SET schema_ver = 49, last_scan_at = datetime('now') WHERE id = 1;
