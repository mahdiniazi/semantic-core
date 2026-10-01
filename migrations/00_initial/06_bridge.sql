-- ============ PHASE 0: BASELINE ============
DROP TABLE IF EXISTS _baseline_v26;
CREATE TABLE _baseline_v26 (kind TEXT NOT NULL, id INTEGER, label TEXT, details TEXT, captured_at TEXT NOT NULL DEFAULT (datetime('now')));

INSERT INTO _baseline_v26 (kind, id, label, details)
SELECT 'fk', ref_id, child_table || '.' || child_col || ' to ' || parent_table || '.' || parent_col, action_on_del FROM e01_378_01_tb;

INSERT INTO _baseline_v26 (kind, id, label, details)
SELECT 'trigger', NULL, name, tbl_name FROM sqlite_master WHERE type='trigger' AND name LIKE 'e03%';

INSERT INTO _baseline_v26 (kind, id, label, details)
SELECT 'view', NULL, name, NULL FROM sqlite_master WHERE type='view' AND name LIKE 'e04%';

INSERT INTO _baseline_v26 (kind, id, label, details)
SELECT 'matrix', NULL, element_name || ' to ' || need_uid, role FROM e01_778_02_tb;

INSERT INTO _baseline_v26 (kind, id, label, details)
SELECT 'element', NULL, element_name, element_layer || '|' || element_kind FROM e01_506_03_tb;

INSERT INTO _baseline_v26 (kind, id, label, details)
SELECT 'need', NULL, need_uid, need_kind || '|' || status FROM e01_506_01_tb;

INSERT OR IGNORE INTO e01_676_03_tb (param_uid, int_value, description) VALUES ('seed_frozen_v26', 1, 'phase migration active');
INSERT OR IGNORE INTO e01_676_03_tb (param_uid, text_value, description) VALUES ('migration_started_at', datetime('now'), 'migration started');

-- ============ PHASE 1: BRIDGE SCHEMA ============
CREATE TABLE IF NOT EXISTS e01_778_05_tb(
    policy_id INTEGER PRIMARY KEY AUTOINCREMENT,
    element_name TEXT NOT NULL,
    need_uid TEXT NOT NULL,
    policy_kind TEXT NOT NULL CHECK(policy_kind IN ('fk','guard','sync','audit','immutability','index')),
    fk_ref_id INTEGER,
    exec_name TEXT,
    rationale TEXT NOT NULL CHECK(length(rationale) >= 10),
    is_mandatory INTEGER NOT NULL DEFAULT 1 CHECK(is_mandatory IN (0,1)),
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    CHECK ((policy_kind = 'fk' AND fk_ref_id IS NOT NULL AND exec_name IS NULL) OR (policy_kind IN ('guard','sync','audit','immutability','index') AND fk_ref_id IS NULL AND exec_name IS NOT NULL)),
    CONSTRAINT fk_pol_elem FOREIGN KEY (element_name) REFERENCES e01_506_03_tb(element_name) ON DELETE RESTRICT,
    CONSTRAINT fk_pol_need FOREIGN KEY (need_uid) REFERENCES e01_506_01_tb(need_uid) ON DELETE RESTRICT,
    CONSTRAINT fk_pol_fk FOREIGN KEY (fk_ref_id) REFERENCES e01_378_01_tb(ref_id) ON DELETE RESTRICT,
    CONSTRAINT fk_pol_exec FOREIGN KEY (exec_name) REFERENCES e01_506_03_tb(element_name) ON DELETE RESTRICT
);

CREATE INDEX IF NOT EXISTS e02_778_50_ix ON e01_778_05_tb(element_name);
CREATE INDEX IF NOT EXISTS e02_778_51_ix ON e01_778_05_tb(need_uid);
CREATE INDEX IF NOT EXISTS e02_778_52_ix ON e01_778_05_tb(policy_kind);
CREATE INDEX IF NOT EXISTS e02_778_53_ix ON e01_778_05_tb(fk_ref_id) WHERE fk_ref_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS e02_778_54_ix ON e01_778_05_tb(exec_name) WHERE exec_name IS NOT NULL;

DROP TRIGGER IF EXISTS e03_778_10_tr;
CREATE TRIGGER e03_778_10_tr BEFORE UPDATE OF policy_id ON e01_778_05_tb WHEN OLD.policy_id <> NEW.policy_id BEGIN SELECT RAISE(ABORT, 'policy_id immutable'); END;

DROP TRIGGER IF EXISTS e03_778_10b_tr;
CREATE TRIGGER e03_778_10b_tr BEFORE UPDATE OF element_name, need_uid, policy_kind ON e01_778_05_tb WHEN OLD.element_name <> NEW.element_name OR OLD.need_uid <> NEW.need_uid OR OLD.policy_kind <> NEW.policy_kind BEGIN SELECT RAISE(ABORT, 'policy identity immutable'); END;

INSERT OR IGNORE INTO e01_506_03_tb (element_name, element_layer, element_kind, element_level, element_code) VALUES
('e01_778_05_tb','M','tb',1,'e01_778_05_tb'),
('e02_778_50_ix','M','ix',2,'e02_778_50_ix'),
('e02_778_51_ix','M','ix',2,'e02_778_51_ix'),
('e02_778_52_ix','M','ix',2,'e02_778_52_ix'),
('e02_778_53_ix','M','ix',2,'e02_778_53_ix'),
('e02_778_54_ix','M','ix',2,'e02_778_54_ix'),
('e03_778_10_tr','M','tr',3,'e03_778_10_tr'),
('e03_778_10b_tr','M','tr',3,'e03_778_10b_tr');

INSERT OR IGNORE INTO e01_378_01_tb (child_table, child_col, parent_table, parent_col, action_on_del, layer_from, layer_to, note) VALUES
('e01_778_05_tb','element_name','e01_506_03_tb','element_name','restrict','M','M','policy elem'),
('e01_778_05_tb','need_uid','e01_506_01_tb','need_uid','restrict','M','M','policy need'),
('e01_778_05_tb','fk_ref_id','e01_378_01_tb','ref_id','restrict','M','M','policy fk'),
('e01_778_05_tb','exec_name','e01_506_03_tb','element_name','restrict','M','M','policy exec');

INSERT OR IGNORE INTO e01_676_03_tb (param_uid, text_value, description) VALUES ('phase1_completed_at', datetime('now'), 'phase 1 done');
INSERT OR IGNORE INTO e01_676_03_tb (param_uid, int_value, description) VALUES ('phase1_status', 1, 'phase 1 PASS');

INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes) VALUES ('v27.0_phase1_bridge', 'Phase 1 - Bridge Schema. 5 indexes + 2 immutability + 4 FK + 8 registry.');

UPDATE e01_676_02_tb SET schema_ver = 28, last_scan_at = datetime('now') WHERE id = 1;
