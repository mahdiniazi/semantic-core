-- ============================================================
-- v134 — کاشت درخت نیاز (نسخه اصلاح‌شده v27.22)
-- اصلاحات:
--   * q_code → question_uid
--   * parent_uid → node_id
--   * افزودن slot و status به cache
-- ============================================================

.mode column
.headers on
PRAGMA foreign_keys = ON;

BEGIN;

-- ═══ STEP 1: ثبت cache در registry ═══
INSERT OR IGNORE INTO e01_506_03_tb
  (element_name, element_layer, element_kind, element_level)
VALUES ('e01_506_12_tb', 'M', 'tb', 1);

INSERT OR IGNORE INTO e01_778_02_tb
  (element_name, need_uid, is_primary, is_driving, role)
VALUES ('e01_506_12_tb', 'N70', 0, 0, 'serves');

-- ═══ STEP 2: کاشت درخت Q00..Q13 برای هر نیاز فعال ═══
-- فقط اگر tree خالی باشد
INSERT INTO e01_506_06_tb
  (need_uid, parent_id, question_uid, ordinal, answer_text, answer_source, status)
SELECT need_uid, NULL, 'Q00', 1, '', 'not_recorded', 'open'
FROM e01_506_01_tb
WHERE status = 'active'
  AND NOT EXISTS (SELECT 1 FROM e01_506_06_tb WHERE question_uid = 'Q00');

INSERT INTO e01_506_06_tb
  (need_uid, parent_id, question_uid, ordinal, answer_text, answer_source, status)
SELECT p.need_uid, p.node_id, 'Q01', 1, '', 'not_recorded', 'open'
FROM e01_506_06_tb p
WHERE p.question_uid = 'Q00'
  AND NOT EXISTS (SELECT 1 FROM e01_506_06_tb WHERE question_uid = 'Q01');

INSERT INTO e01_506_06_tb
  (need_uid, parent_id, question_uid, ordinal, answer_text, answer_source, status)
SELECT p.need_uid, p.node_id, 'Q02', 1, '', 'not_recorded', 'open'
FROM e01_506_06_tb p
WHERE p.question_uid = 'Q01'
  AND NOT EXISTS (SELECT 1 FROM e01_506_06_tb WHERE question_uid = 'Q02');

INSERT INTO e01_506_06_tb
  (need_uid, parent_id, question_uid, ordinal, answer_text, answer_source, status)
SELECT p.need_uid, p.node_id, 'Q03', 1, '', 'not_recorded', 'open'
FROM e01_506_06_tb p
WHERE p.question_uid = 'Q02'
  AND NOT EXISTS (SELECT 1 FROM e01_506_06_tb WHERE question_uid = 'Q03');

INSERT INTO e01_506_06_tb
  (need_uid, parent_id, question_uid, ordinal, answer_text, answer_source, status)
SELECT p.need_uid, p.node_id, 'Q04', 1, '', 'not_recorded', 'open'
FROM e01_506_06_tb p
WHERE p.question_uid = 'Q03'
  AND NOT EXISTS (SELECT 1 FROM e01_506_06_tb WHERE question_uid = 'Q04');

INSERT INTO e01_506_06_tb
  (need_uid, parent_id, question_uid, ordinal, answer_text, answer_source, status)
SELECT p.need_uid, p.node_id, 'Q05', 1, '', 'not_recorded', 'open'
FROM e01_506_06_tb p
WHERE p.question_uid = 'Q04'
  AND NOT EXISTS (SELECT 1 FROM e01_506_06_tb WHERE question_uid = 'Q05');

INSERT INTO e01_506_06_tb
  (need_uid, parent_id, question_uid, ordinal, answer_text, answer_source, status)
SELECT p.need_uid, p.node_id, 'Q06', 1, '', 'not_recorded', 'open'
FROM e01_506_06_tb p
WHERE p.question_uid = 'Q05'
  AND NOT EXISTS (SELECT 1 FROM e01_506_06_tb WHERE question_uid = 'Q06');

INSERT INTO e01_506_06_tb
  (need_uid, parent_id, question_uid, ordinal, answer_text, answer_source, status)
SELECT p.need_uid, p.node_id, 'Q07', 1, '', 'not_recorded', 'open'
FROM e01_506_06_tb p
WHERE p.question_uid = 'Q06'
  AND NOT EXISTS (SELECT 1 FROM e01_506_06_tb WHERE question_uid = 'Q07');

INSERT INTO e01_506_06_tb
  (need_uid, parent_id, question_uid, ordinal, answer_text, answer_source, status)
SELECT p.need_uid, p.node_id, 'Q08', 1, '', 'not_recorded', 'open'
FROM e01_506_06_tb p
WHERE p.question_uid = 'Q07'
  AND NOT EXISTS (SELECT 1 FROM e01_506_06_tb WHERE question_uid = 'Q08');

INSERT INTO e01_506_06_tb
  (need_uid, parent_id, question_uid, ordinal, answer_text, answer_source, status)
SELECT p.need_uid, p.node_id, 'Q09', 1, '', 'not_recorded', 'open'
FROM e01_506_06_tb p
WHERE p.question_uid = 'Q08'
  AND NOT EXISTS (SELECT 1 FROM e01_506_06_tb WHERE question_uid = 'Q09');

INSERT INTO e01_506_06_tb
  (need_uid, parent_id, question_uid, ordinal, answer_text, answer_source, status)
SELECT p.need_uid, p.node_id, 'Q10', 1, '', 'not_recorded', 'open'
FROM e01_506_06_tb p
WHERE p.question_uid = 'Q09'
  AND NOT EXISTS (SELECT 1 FROM e01_506_06_tb WHERE question_uid = 'Q10');

INSERT INTO e01_506_06_tb
  (need_uid, parent_id, question_uid, ordinal, answer_text, answer_source, status)
SELECT p.need_uid, p.node_id, 'Q11', 1, '', 'not_recorded', 'open'
FROM e01_506_06_tb p
WHERE p.question_uid = 'Q10'
  AND NOT EXISTS (SELECT 1 FROM e01_506_06_tb WHERE question_uid = 'Q11');

INSERT INTO e01_506_06_tb
  (need_uid, parent_id, question_uid, ordinal, answer_text, answer_source, status)
SELECT p.need_uid, p.node_id, 'Q12', 1, '', 'not_recorded', 'open'
FROM e01_506_06_tb p
WHERE p.question_uid = 'Q11'
  AND NOT EXISTS (SELECT 1 FROM e01_506_06_tb WHERE question_uid = 'Q12');

INSERT INTO e01_506_06_tb
  (need_uid, parent_id, question_uid, ordinal, answer_text, answer_source, status)
SELECT p.need_uid, p.node_id, 'Q13', 1, '', 'not_recorded', 'open'
FROM e01_506_06_tb p
WHERE p.question_uid = 'Q12'
  AND NOT EXISTS (SELECT 1 FROM e01_506_06_tb WHERE question_uid = 'Q13');

-- ═══ STEP 3: پر کردن cache از روی tree (با CTE بازگشتی) ═══
INSERT OR REPLACE INTO e01_506_12_tb
  (need_uid, node_id, question_uid, slot, answer_text, status, depth, path)
WITH RECURSIVE tree_path(need_uid, node_id, parent_id, question_uid, answer_text, status, depth, path) AS (
  SELECT need_uid, node_id, parent_id, question_uid, answer_text, status, 0,
         question_uid
  FROM e01_506_06_tb
  WHERE parent_id IS NULL
  UNION ALL
  SELECT t.need_uid, t.node_id, t.parent_id, t.question_uid, t.answer_text, t.status,
         tp.depth + 1,
         tp.path || '/' || t.question_uid
  FROM e01_506_06_tb t
  JOIN tree_path tp ON t.parent_id = tp.node_id
)
SELECT need_uid, node_id, question_uid, NULL, answer_text, status, depth, path
FROM tree_path;

-- ═══ STEP 4: تریگرها (اصلاح‌شده با ستون‌های درست) ═══
DROP TRIGGER IF EXISTS e03_506_12_ai_tr;
CREATE TRIGGER e03_506_12_ai_tr
AFTER INSERT ON e01_506_06_tb
BEGIN
  INSERT OR REPLACE INTO e01_506_12_tb
    (need_uid, node_id, question_uid, answer_text, status, depth, path)
  VALUES (
    NEW.need_uid,
    NEW.node_id,
    NEW.question_uid,
    NEW.answer_text,
    NEW.status,
    COALESCE((SELECT depth + 1 FROM e01_506_12_tb
              WHERE need_uid = NEW.need_uid
                AND node_id = NEW.parent_id), 0),
    COALESCE((SELECT path || '/' || NEW.question_uid FROM e01_506_12_tb
              WHERE need_uid = NEW.need_uid
                AND node_id = NEW.parent_id),
             NEW.question_uid)
  );
END;

DROP TRIGGER IF EXISTS e03_506_12_au_tr;
CREATE TRIGGER e03_506_12_au_tr
AFTER UPDATE OF answer_text ON e01_506_06_tb
BEGIN
  UPDATE e01_506_12_tb
  SET answer_text = NEW.answer_text,
      status      = NEW.status
  WHERE need_uid = NEW.need_uid
    AND node_id  = NEW.node_id;
END;

DROP TRIGGER IF EXISTS e03_506_12_ad_tr;
CREATE TRIGGER e03_506_12_ad_tr
AFTER DELETE ON e01_506_06_tb
BEGIN
  DELETE FROM e01_506_12_tb
  WHERE need_uid = OLD.need_uid
    AND node_id  = OLD.node_id;
END;

-- ═══ STEP 5: ثبت تریگرها در حاکمیت ═══
INSERT OR IGNORE INTO e01_506_03_tb (element_name, element_layer, element_kind, element_level)
VALUES
  ('e03_506_12_ai_tr', 'M', 'tr', 2),
  ('e03_506_12_au_tr', 'M', 'tr', 2),
  ('e03_506_12_ad_tr', 'M', 'tr', 2);

INSERT OR IGNORE INTO e01_778_02_tb (element_name, need_uid, is_primary, is_driving, role)
VALUES
  ('e03_506_12_ai_tr', 'N70', 0, 0, 'serves'),
  ('e03_506_12_au_tr', 'N70', 0, 0, 'serves'),
  ('e03_506_12_ad_tr', 'N70', 0, 0, 'serves');

-- ═══ STEP 6: ثبت migration و bump ═══
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v134_need_tree_seed_fixed',
        'Fixed v27.22: q_code→question_uid, parent_uid→node_id');

UPDATE e01_676_02_tb
SET schema_ver = schema_ver + 1
WHERE id = 1;

COMMIT;

-- ═══ گزارش ═══
SELECT '=== ۱. tree nodes ===' AS section;
SELECT COUNT(*) AS total_nodes FROM e01_506_06_tb;

SELECT '=== ۲. cache rows ===' AS section;
SELECT COUNT(*) AS cache_rows FROM e01_506_12_tb;

SELECT '=== ۳. توزیع عمق در cache ===' AS section;
SELECT depth, COUNT(*) AS n FROM e01_506_12_tb GROUP BY depth ORDER BY depth;

SELECT '=== ۴. نمونه از نیاز N11 ===' AS section;
SELECT depth, question_uid, path FROM e01_506_12_tb
WHERE need_uid = 'N11' ORDER BY depth;

SELECT '=== ۵. health ===' AS section;
SELECT severity, COUNT(*) AS n FROM e04_900_02_vw GROUP BY severity;
