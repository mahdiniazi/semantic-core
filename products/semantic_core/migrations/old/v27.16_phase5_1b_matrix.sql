-- =====================================================================
-- v27.16 Phase 5.1b — WITHOUT ROWID for e01_778_02_tb
-- =====================================================================

-- Step 1: Save data
CREATE TEMP TABLE _tmp_matrix AS SELECT * FROM e01_778_02_tb;

-- Step 2: Drop old
DROP TABLE e01_778_02_tb;

-- Step 3: Create WITHOUT ROWID
CREATE TABLE e01_778_02_tb (
    element_name    TEXT NOT NULL,
    need_uid        TEXT NOT NULL,
    code            TEXT,
    is_primary      INTEGER NOT NULL DEFAULT 0 CHECK(is_primary IN (0,1)),
    is_driving      INTEGER NOT NULL DEFAULT 0 CHECK(is_driving IN (0,1)),
    role            TEXT NOT NULL DEFAULT 'serves'
                    CHECK(role IN
                       ('defines','serves','verifies','constrains',
                        'observes','maintains')),
    note            TEXT,
    PRIMARY KEY (element_name, need_uid, role),
    CONSTRAINT fk_er_elem FOREIGN KEY (element_name)
        REFERENCES e01_506_03_tb(element_name) ON DELETE RESTRICT,
    CONSTRAINT fk_er_need FOREIGN KEY (need_uid)
        REFERENCES e01_506_01_tb(need_uid) ON DELETE RESTRICT,
    CONSTRAINT fk_er_code FOREIGN KEY (code)
        REFERENCES e01_778_01_tb(code) ON DELETE RESTRICT
) WITHOUT ROWID;

-- Step 4: Restore data
INSERT INTO e01_778_02_tb SELECT * FROM _tmp_matrix;
DROP TABLE _tmp_matrix;

-- Step 5: Recreate indexes
CREATE INDEX e02_778_20_ix ON e01_778_02_tb(need_uid);
CREATE INDEX e02_778_21_ix ON e01_778_02_tb(code) WHERE code IS NOT NULL;
CREATE INDEX e02_778_22_ix ON e01_778_02_tb(is_primary) WHERE is_primary = 1;
CREATE INDEX e02_778_23_ix ON e01_778_02_tb(is_driving) WHERE is_driving = 1;

-- Step 6: Recreate triggers
DROP TRIGGER IF EXISTS e03_370_33_tr;
CREATE TRIGGER e03_370_33_tr 
BEFORE UPDATE OF element_name, need_uid, role ON e01_778_02_tb
WHEN OLD.element_name <> NEW.element_name 
  OR OLD.need_uid <> NEW.need_uid
  OR OLD.role <> NEW.role
BEGIN SELECT RAISE(ABORT, 'e01_778_02_tb PK is immutable'); END;

DROP TRIGGER IF EXISTS e03_370_14_tr;
CREATE TRIGGER e03_370_14_tr BEFORE INSERT ON e01_778_02_tb
BEGIN
    SELECT CASE WHEN NOT EXISTS (
        SELECT 1 FROM e01_506_03_tb WHERE element_name = NEW.element_name)
    THEN RAISE(ABORT, 'matrix: element not registered') END;
    SELECT CASE WHEN NOT EXISTS (
        SELECT 1 FROM e01_506_01_tb WHERE need_uid = NEW.need_uid)
    THEN RAISE(ABORT, 'matrix: need does not exist') END;
END;

-- Step 7: Bump
UPDATE e01_676_02_tb SET schema_ver = 55, last_scan_at = datetime('now') WHERE id = 1;

-- Log
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v27.16_phase5_1b', 'WITHOUT ROWID for e01_778_02_tb');
