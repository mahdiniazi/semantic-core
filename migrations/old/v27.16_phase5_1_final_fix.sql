-- =====================================================================
-- v27.16 Phase 5.1 Final Fix — restore 3 lost triggers + fix overwrite
-- =====================================================================

-- Fix 1: Drop the incorrect e03_370_14_tr (my mistake) that overwrote dim update guard
DROP TRIGGER IF EXISTS e03_370_14_tr;

-- Fix 2: Restore original e03_370_14_tr (dim_uid update guard) from v26
CREATE TRIGGER e03_370_14_tr
BEFORE UPDATE OF dim_uid ON e01_506_08_tb
BEGIN
    SELECT CASE WHEN NOT EXISTS (
        SELECT 1 FROM e01_506_07_tb WHERE dim_uid = NEW.dim_uid)
    THEN RAISE(ABORT, 'dim_val.upd: dim does not exist') END;
END;

-- Fix 3: Restore e03_328_03_tr (PK immutability of e01_516_01_tb)
DROP TRIGGER IF EXISTS e03_328_03_tr;
CREATE TRIGGER e03_328_03_tr
BEFORE UPDATE OF need_uid, atom_uid, kind ON e01_516_01_tb
WHEN OLD.need_uid <> NEW.need_uid 
  OR OLD.atom_uid <> NEW.atom_uid
  OR OLD.kind <> NEW.kind
BEGIN SELECT RAISE(ABORT, 'e01_516_01_tb PK is immutable'); END;

-- Fix 4: Restore e03_778_14_tr (delete guard on matrix)
DROP TRIGGER IF EXISTS e03_778_14_tr;
CREATE TRIGGER e03_778_14_tr
BEFORE DELETE ON e01_778_02_tb
BEGIN
    SELECT CASE WHEN EXISTS (
        SELECT 1 FROM e01_778_05_tb p
        WHERE p.element_name = OLD.element_name
          AND p.need_uid = OLD.need_uid
          AND p.is_mandatory = 1)
    THEN RAISE(ABORT, 'matrix: cannot delete row with mandatory policies') END;
END;

-- Fix 5: Add a correct insert guard for matrix (proper naming)
DROP TRIGGER IF EXISTS e03_778_02_ins_tr;
CREATE TRIGGER e03_778_02_ins_tr
BEFORE INSERT ON e01_778_02_tb
BEGIN
    SELECT CASE WHEN NOT EXISTS (
        SELECT 1 FROM e01_506_03_tb WHERE element_name = NEW.element_name)
    THEN RAISE(ABORT, 'matrix: element not registered') END;
    SELECT CASE WHEN NOT EXISTS (
        SELECT 1 FROM e01_506_01_tb WHERE need_uid = NEW.need_uid)
    THEN RAISE(ABORT, 'matrix: need does not exist') END;
END;

-- Register new trigger
INSERT OR IGNORE INTO e01_506_03_tb 
(element_name, element_layer, element_kind, element_level)
VALUES ('e03_778_02_ins_tr', 'M', 'tr', 3);

-- Log
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v27.16_phase5_1_final_fix', 'Restored 3 lost triggers + fixed overwrite + proper insert guard');

-- Bump
UPDATE e01_676_02_tb SET schema_ver = 56, last_scan_at = datetime('now') WHERE id = 1;
