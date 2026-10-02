-- =====================================================================
-- v27.10 Phase 3 — Rebalance N30 policies
-- =====================================================================

-- Step 1: Count before
CREATE TEMP TABLE _n30_before AS
SELECT need_uid, COUNT(*) AS cnt FROM e01_778_05_tb GROUP BY need_uid;

-- Step 2: Move FK policies by category to more specific needs

-- FK policies about type relations → N11 (cycle) or N12 (relation)
UPDATE e01_778_05_tb
SET need_uid = 'N12'
WHERE need_uid = 'N30'
  AND policy_kind = 'fk'
  AND element_name IN (
    SELECT child_table FROM e01_378_01_tb
    WHERE parent_table LIKE 'e01_112%' OR parent_table LIKE 'e01_202%'
  );

-- FK policies about element registry → N70 (matrix coverage)
UPDATE e01_778_05_tb
SET need_uid = 'N70'
WHERE need_uid = 'N30'
  AND policy_kind = 'fk'
  AND element_name IN (
    SELECT child_table FROM e01_378_01_tb
    WHERE parent_table LIKE 'e01_506_03%'
  );

-- FK policies about semantic graph → N71 (chains)
UPDATE e01_778_05_tb
SET need_uid = 'N71'
WHERE need_uid = 'N30'
  AND policy_kind = 'fk'
  AND element_name LIKE 'e01_778%'
  AND element_name <> 'e01_778_05_tb';

-- FK policies about context → N32
UPDATE e01_778_05_tb
SET need_uid = 'N32'
WHERE need_uid = 'N30'
  AND policy_kind = 'fk'
  AND element_name LIKE 'e01_305%';

-- FK policies about versioning → N33
UPDATE e01_778_05_tb
SET need_uid = 'N33'
WHERE need_uid = 'N30'
  AND policy_kind = 'fk'
  AND element_name LIKE 'e01_330%';

-- FK policies about identity → N23 (concept/instance)
UPDATE e01_778_05_tb
SET need_uid = 'N23'
WHERE need_uid = 'N30'
  AND policy_kind = 'fk'
  AND element_name LIKE 'e01_300%';

-- immutability policies about vocab → N50 (design language)
UPDATE e01_778_05_tb
SET need_uid = 'N50'
WHERE need_uid = 'N30'
  AND policy_kind = 'immutability'
  AND element_name LIKE 'e01_506_%';

-- guard policies about FTS sync → N41
UPDATE e01_778_05_tb
SET need_uid = 'N41'
WHERE need_uid = 'N30'
  AND policy_kind IN ('guard','sync')
  AND element_name LIKE 'e03_434%';

-- guard policies about FTS triggers → N41
UPDATE e01_778_05_tb
SET need_uid = 'N41'
WHERE need_uid = 'N30'
  AND policy_kind = 'guard'
  AND element_name LIKE 'e03_434%';

-- immutability policies about value → N12
UPDATE e01_778_05_tb
SET need_uid = 'N12'
WHERE need_uid = 'N30'
  AND policy_kind = 'immutability'
  AND element_name LIKE 'e01_201%';

-- provenance guards → N31
UPDATE e01_778_05_tb
SET need_uid = 'N31'
WHERE need_uid = 'N30'
  AND policy_kind = 'guard'
  AND element_name LIKE 'e03_343%';

-- context key sync → N15
UPDATE e01_778_05_tb
SET need_uid = 'N15'
WHERE need_uid = 'N30'
  AND policy_kind = 'sync'
  AND element_name LIKE 'e03_135%';

-- delete guards for meta → N70
UPDATE e01_778_05_tb
SET need_uid = 'N70'
WHERE need_uid = 'N30'
  AND policy_kind = 'guard'
  AND element_name LIKE 'e03_320%';

-- immutability for type/relation types → N50
UPDATE e01_778_05_tb
SET need_uid = 'N50'
WHERE need_uid = 'N30'
  AND policy_kind = 'immutability'
  AND (element_name LIKE 'e01_200%' OR element_name LIKE 'e01_202%'
       OR element_name LIKE 'e01_112%');

-- Step 3: Count after
SELECT '=== N30 AFTER REBALANCE ===' AS section;
SELECT need_uid, COUNT(*) AS cnt
FROM e01_778_05_tb
GROUP BY need_uid
HAVING cnt > 5
ORDER BY cnt DESC
LIMIT 15;

-- Step 4: N30 specific count
SELECT '=== N30 REMAINING ===' AS section;
SELECT COUNT(*) AS n30_count FROM e01_778_05_tb WHERE need_uid = 'N30';

-- Step 5: Audit — needs with less than 3 policies
SELECT '=== NEEDS WITH < 3 POLICIES ===' AS section;
SELECT n.need_uid, n.need_label, COUNT(p.policy_id) AS cnt
FROM e01_506_01_tb n
LEFT JOIN e01_778_05_tb p ON p.need_uid = n.need_uid
GROUP BY n.need_uid
HAVING cnt < 3
ORDER BY cnt, n.need_uid;

-- Log
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v27.10_phase3_n30_rebalance', 'Rebalanced N30 policy distribution');

-- Bump
UPDATE e01_676_02_tb SET schema_ver = 49, last_scan_at = datetime('now') WHERE id = 1;
