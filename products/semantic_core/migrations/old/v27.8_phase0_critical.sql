-- =====================================================================
-- v27.8 Phase 0 — Restore 6 missing critical triggers
-- =====================================================================

-- 1. e03_120_02_tr: type closure insert
DROP TRIGGER IF EXISTS e03_120_02_tr;
CREATE TRIGGER e03_120_02_tr AFTER INSERT ON e01_200_01_tb
BEGIN
    INSERT INTO e01_120_01_tb (desc_id, anc_id, depth)
    VALUES (NEW.type_id, NEW.type_id, 0);
    INSERT INTO e01_120_01_tb (desc_id, anc_id, depth)
    SELECT NEW.type_id, anc_id, depth + 1
    FROM e01_120_01_tb
    WHERE desc_id = NEW.parent_id
      AND NEW.parent_id IS NOT NULL
      AND depth < (SELECT int_value FROM e01_676_03_tb WHERE param_uid='max_depth');
END;

-- 2. e03_120_03_tr: type closure update
DROP TRIGGER IF EXISTS e03_120_03_tr;
CREATE TRIGGER e03_120_03_tr AFTER UPDATE OF parent_id ON e01_200_01_tb
WHEN OLD.parent_id IS NOT NEW.parent_id
BEGIN
    DELETE FROM e01_120_01_tb;
    INSERT INTO e01_120_01_tb (desc_id, anc_id, depth)
    WITH RECURSIVE walk(desc_id, anc_id, depth) AS (
        SELECT t.type_id, t.type_id, 0 FROM e01_200_01_tb t
        UNION
        SELECT w.desc_id, p.parent_id, w.depth + 1
        FROM walk w
        JOIN e01_200_01_tb p ON p.type_id = w.anc_id
        WHERE p.parent_id IS NOT NULL
          AND w.depth < (SELECT int_value FROM e01_676_03_tb WHERE param_uid='max_depth')
    )
    SELECT desc_id, anc_id, depth FROM walk;
END;

-- 3. e03_434_02_tr: FTS delete sync
DROP TRIGGER IF EXISTS e03_434_02_tr;
CREATE TRIGGER e03_434_02_tr AFTER DELETE ON e01_200_03_tb
BEGIN
    INSERT INTO e02_404_01_ft(e02_404_01_ft, rowid, label_norm, desc_norm)
    VALUES ('delete', OLD.ent_id,
            COALESCE(OLD.label_norm, lower(trim(OLD.label))),
            OLD.desc_norm);
END;

-- 4. e03_434_03_tr: FTS update sync
DROP TRIGGER IF EXISTS e03_434_03_tr;
CREATE TRIGGER e03_434_03_tr
AFTER UPDATE OF label_norm, desc_norm, label ON e01_200_03_tb
WHEN NEW.label_norm IS NOT OLD.label_norm
  OR NEW.desc_norm IS NOT OLD.desc_norm
  OR NEW.label IS NOT OLD.label
BEGIN
    INSERT INTO e02_404_01_ft(e02_404_01_ft, rowid, label_norm, desc_norm)
    VALUES ('delete', OLD.ent_id,
            COALESCE(OLD.label_norm, lower(trim(OLD.label))),
            OLD.desc_norm);
    INSERT INTO e02_404_01_ft(rowid, label_norm, desc_norm)
    VALUES (NEW.ent_id,
            COALESCE(NEW.label_norm, lower(trim(NEW.label))),
            NEW.desc_norm);
END;

-- 5. e03_434_04_tr: label_norm insert sync
DROP TRIGGER IF EXISTS e03_434_04_tr;
CREATE TRIGGER e03_434_04_tr AFTER INSERT ON e01_200_03_tb
WHEN NEW.label_norm IS NULL
BEGIN
    UPDATE e01_200_03_tb SET label_norm = lower(trim(NEW.label))
    WHERE ent_id = NEW.ent_id;
END;

-- 6. e03_434_05_tr: label_norm update sync
DROP TRIGGER IF EXISTS e03_434_05_tr;
CREATE TRIGGER e03_434_05_tr AFTER UPDATE OF label ON e01_200_03_tb
WHEN NEW.label IS NOT OLD.label AND NEW.label_norm IS NULL
BEGIN
    UPDATE e01_200_03_tb SET label_norm = lower(trim(NEW.label))
    WHERE ent_id = NEW.ent_id;
END;

-- Register in element registry
INSERT OR IGNORE INTO e01_506_03_tb (element_name, element_layer, element_kind, element_level)
VALUES
  ('e03_120_02_tr','M','tr',3),
  ('e03_120_03_tr','M','tr',3),
  ('e03_434_02_tr','M','tr',3),
  ('e03_434_03_tr','M','tr',3),
  ('e03_434_04_tr','M','tr',3),
  ('e03_434_05_tr','M','tr',3);

-- Rebuild type closure from scratch
DELETE FROM e01_120_01_tb;
INSERT INTO e01_120_01_tb (desc_id, anc_id, depth)
WITH RECURSIVE walk(desc_id, anc_id, depth) AS (
    SELECT t.type_id, t.type_id, 0 FROM e01_200_01_tb t
    UNION
    SELECT w.desc_id, p.parent_id, w.depth + 1
    FROM walk w
    JOIN e01_200_01_tb p ON p.type_id = w.anc_id
    WHERE p.parent_id IS NOT NULL AND w.depth < 100
)
SELECT desc_id, anc_id, depth FROM walk;

-- Rebuild FTS from scratch
INSERT INTO e02_404_01_ft(e02_404_01_ft) VALUES('rebuild');

-- Log
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v27.8_phase0_critical', 'Restored 6 missing triggers + rebuilt closure + FTS');

-- Bump
UPDATE e01_676_02_tb SET schema_ver = 44, last_scan_at = datetime('now') WHERE id = 1;
