DROP TRIGGER IF EXISTS e03_778_11_tr;
CREATE TRIGGER e03_778_11_tr BEFORE INSERT ON e01_778_05_tb
BEGIN
    SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM e01_506_03_tb WHERE element_name = NEW.element_name)
        THEN RAISE(ABORT, 'policy: element not registered') END;
    SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM e01_506_01_tb WHERE need_uid = NEW.need_uid AND status = 'active')
        THEN RAISE(ABORT, 'policy: need not active') END;
    SELECT CASE WHEN NEW.exec_name IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sqlite_master WHERE name = NEW.exec_name)
        THEN RAISE(ABORT, 'policy: exec_name not in schema') END;
    SELECT CASE WHEN NEW.fk_ref_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_378_01_tb WHERE ref_id = NEW.fk_ref_id)
        THEN RAISE(ABORT, 'policy: fk_ref_id not in catalog') END;
END;

DROP TRIGGER IF EXISTS e03_778_13_tr;
CREATE TRIGGER e03_778_13_tr BEFORE DELETE ON e01_778_05_tb
WHEN OLD.is_mandatory = 1
BEGIN
    SELECT CASE WHEN EXISTS (SELECT 1 FROM e01_778_02_tb m WHERE m.element_name = OLD.element_name AND m.need_uid = OLD.need_uid AND m.is_primary = 1 AND m.is_driving = 1)
        THEN RAISE(ABORT, 'policy: cannot delete mandatory policy of driving element') END;
END;

DROP TRIGGER IF EXISTS e03_778_14_tr;
CREATE TRIGGER e03_778_14_tr BEFORE DELETE ON e01_778_02_tb
BEGIN
    SELECT CASE WHEN EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.element_name = OLD.element_name AND p.need_uid = OLD.need_uid AND p.is_mandatory = 1)
        THEN RAISE(ABORT, 'matrix: cannot delete row with mandatory policies') END;
END;

INSERT OR IGNORE INTO e01_506_03_tb (element_name, element_layer, element_kind, element_level, element_code) VALUES
('e03_778_11_tr','M','tr',3,'e03_778_11_tr'),
('e03_778_13_tr','M','tr',3,'e03_778_13_tr'),
('e03_778_14_tr','M','tr',3,'e03_778_14_tr');

INSERT OR IGNORE INTO e01_778_01_tb (need_uid, code, code_kind, label) VALUES
('N70','INV:policy','invariant','Policy validation invariant'),
('N30','INV:del','invariant','Delete protection invariant');

INSERT OR IGNORE INTO e01_778_05_tb (element_name, need_uid, policy_kind, exec_name, rationale, is_mandatory) VALUES
('e03_778_11_tr','N70','guard','e03_778_11_tr','Validate policy insert',1),
('e03_778_13_tr','N70','guard','e03_778_13_tr','Protect mandatory policy',1),
('e03_778_14_tr','N70','guard','e03_778_14_tr','Protect matrix rows',1);

INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes) VALUES
('v27.0_phase2_policy', 'Phase 2 - 3 enforce triggers');

UPDATE e01_676_02_tb SET schema_ver = 29, last_scan_at = datetime('now') WHERE id = 1;
