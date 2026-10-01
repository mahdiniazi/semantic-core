-- =====================================================================
-- v27.16 Phase 5.1a — WITHOUT ROWID for e01_516_01_tb
-- =====================================================================

-- Step 1: Save current data to temp
CREATE TEMP TABLE _tmp_nea AS SELECT * FROM e01_516_01_tb;

-- Step 2: Drop old table (auto-drops triggers and indexes)
DROP TABLE e01_516_01_tb;

-- Step 3: Create new with WITHOUT ROWID
CREATE TABLE e01_516_01_tb (
    need_uid  TEXT NOT NULL,
    atom_uid  TEXT NOT NULL,
    kind      TEXT NOT NULL DEFAULT 'derived'
              CHECK(kind IN ('derived','refined','satisfies')),
    origin    TEXT NOT NULL DEFAULT 'design'
              CHECK(origin IN ('design','inferred','observed','derived')),
    PRIMARY KEY (need_uid, atom_uid, kind),
    CONSTRAINT fk_nea_need FOREIGN KEY (need_uid)
        REFERENCES e01_506_01_tb(need_uid) ON DELETE RESTRICT,
    CONSTRAINT fk_nea_atom FOREIGN KEY (atom_uid)
        REFERENCES e01_506_02_tb(atom_uid) ON DELETE RESTRICT
) WITHOUT ROWID;

-- Step 4: Restore data
INSERT INTO e01_516_01_tb SELECT * FROM _tmp_nea;
DROP TABLE _tmp_nea;

-- Step 5: Recreate indexes
CREATE INDEX e02_516_10_ix ON e01_516_01_tb(atom_uid);
CREATE INDEX e02_516_11_ix ON e01_516_01_tb(origin);

-- Step 6: Recreate triggers
DROP TRIGGER IF EXISTS e03_370_01_tr;
CREATE TRIGGER e03_370_01_tr BEFORE INSERT ON e01_516_01_tb
BEGIN
    SELECT CASE WHEN NOT EXISTS (
        SELECT 1 FROM e01_506_01_tb WHERE need_uid = NEW.need_uid)
    THEN RAISE(ABORT, 'nee_atom: need does not exist') END;
    SELECT CASE WHEN NOT EXISTS (
        SELECT 1 FROM e01_506_02_tb WHERE atom_uid = NEW.atom_uid)
    THEN RAISE(ABORT, 'nee_atom: atom does not exist') END;
END;

DROP TRIGGER IF EXISTS e03_370_11_tr;
CREATE TRIGGER e03_370_11_tr BEFORE UPDATE OF need_uid, atom_uid ON e01_516_01_tb
BEGIN
    SELECT CASE WHEN NOT EXISTS (
        SELECT 1 FROM e01_506_01_tb WHERE need_uid = NEW.need_uid)
    THEN RAISE(ABORT, 'nee_atom.upd: need does not exist') END;
    SELECT CASE WHEN NOT EXISTS (
        SELECT 1 FROM e01_506_02_tb WHERE atom_uid = NEW.atom_uid)
    THEN RAISE(ABORT, 'nee_atom.upd: atom does not exist') END;
END;

-- Step 7: Register in schema_ver
UPDATE e01_676_02_tb SET schema_ver = 54, last_scan_at = datetime('now') WHERE id = 1;

-- Log
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v27.16_phase5_1a', 'WITHOUT ROWID for e01_516_01_tb');
