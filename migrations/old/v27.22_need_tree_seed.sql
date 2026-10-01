-- ============================================================
-- v27.22 — کاشت درخت نیاز + زنده کردن cache
-- ============================================================

.mode column
.headers on
PRAGMA foreign_keys = ON;

BEGIN;

-- ============================================
-- PRE-CHECK 1: questions table must be seeded
-- ============================================
SELECT '--- PRE 1: questions count ---' AS section;
SELECT COUNT(*) AS q_count FROM e01_506_05_tb;

SELECT '--- PRE 2: questions list ---' AS section;
SELECT question_uid FROM e01_506_05_tb ORDER BY question_uid;

-- ============================================
-- STEP 1: register cache in registry
-- ============================================
INSERT OR IGNORE INTO e01_506_03_tb
  (element_name, element_layer, element_kind, description)
VALUES
  ('e01_506_12_tb', 'M', 'tb', 'Need tree materialized cache');

-- ============================================
-- STEP 2: anchor cache to N70 (semantic graph)
-- ============================================
INSERT OR IGNORE INTO e01_778_02_tb
  (element_name, need_uid, is_primary, is_driving, role)
VALUES
  ('e01_506_12_tb', 'N70', 0, 0, 'serves');

-- ============================================
-- STEP 3: seed the need tree (14-step chain)
-- ============================================

-- Q00 = root for each active need
INSERT INTO e01_506_06_tb
  (need_uid, parent_id, question_uid, ordinal, answer_text, answer_source, status)
SELECT need_uid, NULL, 'Q00', 1, '', 'not_recorded', 'open'
FROM e01_506_01_tb WHERE status = 'active';

-- Q01 under Q00
INSERT INTO e01_506_06_tb
  (need_uid, parent_id, question_uid, ordinal, answer_text, answer_source, status)
SELECT p.need_uid, p.node_id, 'Q01', 1, '', 'not_recorded', 'open'
FROM e01_506_06_tb p WHERE p.question_uid = 'Q00';

-- Q02 under Q01
INSERT INTO e01_506_06_tb
  (need_uid, parent_id, question_uid, ordinal, answer_text, answer_source, status)
SELECT p.need_uid, p.node_id, 'Q02', 1, '', 'not_recorded', 'open'
FROM e01_506_06_tb p WHERE p.question_uid = 'Q01';

-- Q03 under Q02
INSERT INTO e01_506_06_tb
  (need_uid, parent_id, question_uid, ordinal, answer_text, answer_source, status)
SELECT p.need_uid, p.node_id, 'Q03', 1, '', 'not_recorded', 'open'
FROM e01_506_06_tb p WHERE p.question_uid = 'Q02';

-- Q04 under Q03
INSERT INTO e01_506_06_tb
  (need_uid, parent_id, question_uid, ordinal, answer_text, answer_source, status)
SELECT p.need_uid, p.node_id, 'Q04', 1, '', 'not_recorded', 'open'
FROM e01_506_06_tb p WHERE p.question_uid = 'Q03';

-- Q05 under Q04
INSERT INTO e01_506_06_tb
  (need_uid, parent_id, question_uid, ordinal, answer_text, answer_source, status)
SELECT p.need_uid, p.node_id, 'Q05', 1, '', 'not_recorded', 'open'
FROM e01_506_06_tb p WHERE p.question_uid = 'Q04';

-- Q06 under Q05
INSERT INTO e01_506_06_tb
  (need_uid, parent_id, question_uid, ordinal, answer_text, answer_source, status)
SELECT p.need_uid, p.node_id, 'Q06', 1, '', 'not_recorded', 'open'
FROM e01_506_06_tb p WHERE p.question_uid = 'Q05';

-- Q07 under Q06
INSERT INTO e01_506_06_tb
  (need_uid, parent_id, question_uid, ordinal, answer_text, answer_source, status)
SELECT p.need_uid, p.node_id, 'Q07', 1, '', 'not_recorded', 'open'
FROM e01_506_06_tb p WHERE p.question_uid = 'Q06';

-- Q08 under Q07
INSERT INTO e01_506_06_tb
  (need_uid, parent_id, question_uid, ordinal, answer_text, answer_source, status)
SELECT p.need_uid, p.node_id, 'Q08', 1, '', 'not_recorded', 'open'
FROM e01_506_06_tb p WHERE p.question_uid = 'Q07';

-- Q09 under Q08
INSERT INTO e01_506_06_tb
  (need_uid, parent_id, question_uid, ordinal, answer_text, answer_source, status)
SELECT p.need_uid, p.node_id, 'Q09', 1, '', 'not_recorded', 'open'
FROM e01_506_06_tb p WHERE p.question_uid = 'Q08';

-- Q10 under Q09
INSERT INTO e01_506_06_tb
  (need_uid, parent_id, question_uid, ordinal, answer_text, answer_source, status)
SELECT p.need_uid, p.node_id, 'Q10', 1, '', 'not_recorded', 'open'
FROM e01_506_06_tb p WHERE p.question_uid = 'Q09';

-- Q11 under Q10
INSERT INTO e01_506_06_tb
  (need_uid, parent_id, question_uid, ordinal, answer_text, answer_source, status)
SELECT p.need_uid, p.node_id, 'Q11', 1, '', 'not_recorded', 'open'
FROM e01_506_06_tb p WHERE p.question_uid = 'Q10';

-- Q12 under Q11
INSERT INTO e01_506_06_tb
  (need_uid, parent_id, question_uid, ordinal, answer_text, answer_source, status)
SELECT p.need_uid, p.node_id, 'Q12', 1, '', 'not_recorded', 'open'
FROM e01_506_06_tb p WHERE p.question_uid = 'Q11';

-- Q13 under Q12
INSERT INTO e01_506_06_tb
  (need_uid, parent_id, question_uid, ordinal, answer_text, answer_source, status)
SELECT p.need_uid, p.node_id, 'Q13', 1, '', 'not_recorded', 'open'
FROM e01_506_06_tb p WHERE p.question_uid = 'Q12';

-- ============================================
-- STEP 4: populate cache from tree
-- ============================================
DELETE FROM e01_506_12_tb;

WITH RECURSIVE
  tree_path(node_id, need_uid, question_uid, parent_id, depth, path) AS (
    SELECT node_id, need_uid, question_uid, parent_id, 0, question_uid
    FROM e01_506_06_tb
    WHERE parent_id IS NULL
    UNION ALL
    SELECT t.node_id, t.need_uid, t.question_uid, t.parent_id,
           tp.depth + 1,
           tp.path || '/' || t.question_uid
    FROM e01_506_06_tb t
    JOIN tree_path tp ON tp.node_id = t.parent_id
  )
INSERT INTO e01_506_12_tb (need_uid, q_code, answer_text, depth, parent_uid, path)
SELECT
  tp.need_uid,
  tp.question_uid,
  (SELECT answer_text FROM e01_506_06_tb WHERE node_id = tp.node_id),
  tp.depth,
  (SELECT question_uid FROM e01_506_06_tb WHERE node_id = tp.parent_id),
  tp.path
FROM tree_path tp;

-- ============================================
-- STEP 5: triggers to keep cache in sync
-- ============================================

DROP TRIGGER IF EXISTS e03_506_12_ai_tr;
CREATE TRIGGER e03_506_12_ai_tr
AFTER INSERT ON e01_506_06_tb
BEGIN
  INSERT OR REPLACE INTO e01_506_12_tb
    (need_uid, q_code, answer_text, depth, parent_uid, path)
  SELECT
    NEW.need_uid,
    NEW.question_uid,
    NEW.answer_text,
    COALESCE((SELECT depth + 1 FROM e01_506_12_tb
              WHERE need_uid = NEW.need_uid
                AND q_code = (SELECT question_uid FROM e01_506_06_tb
                              WHERE node_id = NEW.parent_id)), 0),
    (SELECT question_uid FROM e01_506_06_tb WHERE node_id = NEW.parent_id),
    COALESCE((SELECT path || '/' || NEW.question_uid FROM e01_506_12_tb
              WHERE need_uid = NEW.need_uid
                AND q_code = (SELECT question_uid FROM e01_506_06_tb
                              WHERE node_id = NEW.parent_id)),
             NEW.question_uid);
END;

DROP TRIGGER IF EXISTS e03_506_12_au_tr;
CREATE TRIGGER e03_506_12_au_tr
AFTER UPDATE OF answer_text ON e01_506_06_tb
BEGIN
  UPDATE e01_506_12_tb
  SET answer_text = NEW.answer_text
  WHERE need_uid = NEW.need_uid AND q_code = NEW.question_uid;
END;

DROP TRIGGER IF EXISTS e03_506_12_ad_tr;
CREATE TRIGGER e03_506_12_ad_tr
AFTER DELETE ON e01_506_06_tb
BEGIN
  DELETE FROM e01_506_12_tb
  WHERE need_uid = OLD.need_uid AND q_code = OLD.question_uid;
END;

-- ============================================
-- STEP 6: register triggers
-- ============================================
INSERT OR IGNORE INTO e01_506_03_tb
  (element_name, element_layer, element_kind, description)
VALUES
  ('e03_506_12_ai_tr', 'M', 'tr', 'Cache insert sync'),
  ('e03_506_12_au_tr', 'M', 'tr', 'Cache update sync'),
  ('e03_506_12_ad_tr', 'M', 'tr', 'Cache delete sync');

INSERT OR IGNORE INTO e01_778_02_tb
  (element_name, need_uid, is_primary, is_driving, role)
VALUES
  ('e03_506_12_ai_tr', 'N70', 0, 0, 'serves'),
  ('e03_506_12_au_tr', 'N70', 0, 0, 'serves'),
  ('e03_506_12_ad_tr', 'N70', 0, 0, 'serves');

-- ============================================
-- STEP 7: bump schema version
-- ============================================
UPDATE e01_676_02_tb
SET schema_ver = 61,
    last_scan_at = datetime('now')
WHERE id = 1;

INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v27.22_need_tree_seed', 'Need tree seeded, cache registered and populated');

COMMIT;

-- ============================================
-- POST-CHECK
-- ============================================
SELECT '=== POST 1: tree row count ===' AS section;
SELECT COUNT(*) AS nodes FROM e01_506_06_tb;

SELECT '=== POST 2: nodes per need (top 5) ===' AS section;
SELECT need_uid, COUNT(*) AS n
FROM e01_506_06_tb GROUP BY need_uid ORDER BY n DESC LIMIT 5;

SELECT '=== POST 3: cache row count ===' AS section;
SELECT COUNT(*) AS cache_rows FROM e01_506_12_tb;

SELECT '=== POST 4: N11 tree sample ===' AS section;
SELECT node_id, parent_id, question_uid, depth
FROM e01_506_12_tb WHERE need_uid = 'N11' ORDER BY depth;

SELECT '=== POST 5: dashboard ===' AS section;
SELECT domain, coverage_pct, status
FROM e04_900_01_vw
ORDER BY CASE status
  WHEN 'critical' THEN 1 WHEN 'watch' THEN 2
  WHEN 'healthy' THEN 3 ELSE 4 END;
