-- Fix e03_120_01_tr
DROP TRIGGER IF EXISTS e03_120_01_tr;
CREATE TRIGGER e03_120_01_tr
BEFORE UPDATE OF parent_id ON e01_200_01_tb
WHEN NEW.parent_id IS NOT NULL AND NEW.parent_id <> NEW.type_id
BEGIN
    SELECT CASE WHEN EXISTS (
        SELECT 1 FROM e01_120_01_tb
        WHERE desc_id = NEW.parent_id AND anc_id = NEW.type_id
    ) THEN RAISE(ABORT, 'type hierarchy: cycle detected') END;
END;

-- Fix e03_120_04_tr
DROP TRIGGER IF EXISTS e03_120_04_tr;
CREATE TRIGGER e03_120_04_tr
BEFORE INSERT ON e01_200_03_tb
BEGIN
    SELECT CASE WHEN (SELECT type_id FROM e01_200_01_tb WHERE type_id=NEW.type_id) IS NULL
        THEN RAISE(ABORT, 'entity type does not exist') END;
    SELECT CASE WHEN NEW.nature = 'instance'
             AND (SELECT is_abstract FROM e01_200_01_tb WHERE type_id = NEW.type_id) = 1
        THEN RAISE(ABORT, 'cannot instantiate abstract type') END;
END;

-- Fix e03_120_05_tr
DROP TRIGGER IF EXISTS e03_120_05_tr;
CREATE TRIGGER e03_120_05_tr
BEFORE UPDATE OF type_id, nature ON e01_200_03_tb
BEGIN
    SELECT CASE WHEN (SELECT type_id FROM e01_200_01_tb WHERE type_id=NEW.type_id) IS NULL
        THEN RAISE(ABORT, 'entity type does not exist (upd)') END;
    SELECT CASE WHEN NEW.nature = 'instance'
             AND (SELECT is_abstract FROM e01_200_01_tb WHERE type_id = NEW.type_id) = 1
        THEN RAISE(ABORT, 'cannot reassign to abstract type') END;
END;

-- Fix e03_122_01_tr — CRITICAL
DROP TRIGGER IF EXISTS e03_122_01_tr;
CREATE TRIGGER e03_122_01_tr
BEFORE INSERT ON e01_222_01_tb
WHEN NEW.reltype_id = (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a')
 AND NEW.superseded_at IS NULL AND NEW.status = 'asserted'
BEGIN
    SELECT CASE WHEN NEW.subj_ent_id = NEW.obj_ent_id
        THEN RAISE(ABORT, 'is_a: self-reference not allowed') END;
    SELECT CASE WHEN EXISTS (
        WITH RECURSIVE anc(id, depth) AS (
            SELECT NEW.obj_ent_id, 0
            UNION ALL
            SELECT r.obj_ent_id, anc.depth + 1
            FROM e01_222_01_tb r
            JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id
            JOIN anc ON r.subj_ent_id = anc.id
            WHERE rt.type_uid = 'is_a'
              AND r.superseded_at IS NULL AND r.status = 'asserted'
              AND anc.depth < 50
        )
        SELECT 1 FROM anc WHERE id = NEW.subj_ent_id
    ) THEN RAISE(ABORT, 'is_a: cycle detected') END;
END;

-- Fix e03_122_02_tr — CRITICAL
DROP TRIGGER IF EXISTS e03_122_02_tr;
CREATE TRIGGER e03_122_02_tr
BEFORE UPDATE OF subj_ent_id, obj_ent_id, reltype_id, status, superseded_at
ON e01_222_01_tb
WHEN NEW.reltype_id = (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a')
 AND NEW.superseded_at IS NULL AND NEW.status = 'asserted'
BEGIN
    SELECT CASE WHEN NEW.subj_ent_id = NEW.obj_ent_id
        THEN RAISE(ABORT, 'is_a: self-reference (upd)') END;
    SELECT CASE WHEN EXISTS (
        WITH RECURSIVE anc(id, depth) AS (
            SELECT NEW.obj_ent_id, 0
            UNION ALL
            SELECT r.obj_ent_id, anc.depth + 1
            FROM e01_222_01_tb r
            JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id
            JOIN anc ON r.subj_ent_id = anc.id
            WHERE rt.type_uid = 'is_a'
              AND r.superseded_at IS NULL AND r.status = 'asserted'
              AND r.rel_id <> NEW.rel_id
              AND anc.depth < 50
        )
        SELECT 1 FROM anc WHERE id = NEW.subj_ent_id
    ) THEN RAISE(ABORT, 'is_a: cycle detected (upd)') END;
END;

-- Fix e03_434_01_tr (full version)
DROP TRIGGER IF EXISTS e03_434_01_tr;
CREATE TRIGGER e03_434_01_tr
AFTER INSERT ON e01_200_03_tb
BEGIN
    INSERT INTO e02_404_01_ft(rowid, label_norm, desc_norm)
    VALUES (NEW.ent_id,
            COALESCE(NEW.label_norm, lower(trim(NEW.label))),
            NEW.desc_norm);
END;

-- Fix e03_778_11_tr (restore full policy validation)
DROP TRIGGER IF EXISTS e03_778_11_tr;
CREATE TRIGGER e03_778_11_tr
BEFORE INSERT ON e01_778_05_tb
BEGIN
    SELECT CASE WHEN NOT EXISTS (
        SELECT 1 FROM e01_506_03_tb WHERE element_name = NEW.element_name)
    THEN RAISE(ABORT, 'policy: element not registered') END;
    SELECT CASE WHEN NOT EXISTS (
        SELECT 1 FROM e01_506_01_tb
        WHERE need_uid = NEW.need_uid AND status = 'active')
    THEN RAISE(ABORT, 'policy: need not active') END;
END;

-- Migration log
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v27.0.1_placeholder_fix', 'Restored placeholder triggers to full logic');

-- Bump schema_ver to 36
UPDATE e01_676_02_tb SET schema_ver = 36, last_scan_at = datetime('now') WHERE id = 1;
