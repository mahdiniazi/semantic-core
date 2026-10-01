DROP VIEW IF EXISTS e04_778_10_vw;
CREATE VIEW e04_778_10_vw AS
SELECT m.element_name, m.need_uid, m.role, m.is_primary, m.is_driving,
       'no_mandatory_policy' AS gap_kind
FROM e01_778_02_tb m
WHERE m.is_primary = 1
  AND NOT EXISTS (
      SELECT 1 FROM e01_778_05_tb p
      WHERE p.element_name = m.element_name
        AND p.need_uid = m.need_uid
        AND p.is_mandatory = 1);

DROP VIEW IF EXISTS e04_778_11_vw;
CREATE VIEW e04_778_11_vw AS
SELECT f.ref_id, f.child_table, f.child_col,
       f.parent_table, f.parent_col,
       'fk_without_matrix_anchor' AS gap_kind
FROM e01_378_01_tb f
WHERE NOT EXISTS (
    SELECT 1 FROM e01_778_05_tb p
    WHERE p.fk_ref_id = f.ref_id AND p.policy_kind = 'fk');

DROP VIEW IF EXISTS e04_778_12_vw;
CREATE VIEW e04_778_12_vw AS
SELECT sm.name AS trigger_name,
       'trigger_without_matrix_anchor' AS gap_kind
FROM sqlite_master sm
WHERE sm.type = 'trigger'
  AND sm.name LIKE 'e03\_%' ESCAPE '\'
  AND sm.name NOT LIKE 'e03\_778\_%' ESCAPE '\'
  AND NOT EXISTS (
      SELECT 1 FROM e01_778_05_tb p WHERE p.exec_name = sm.name);

DROP VIEW IF EXISTS e04_778_13_vw;
CREATE VIEW e04_778_13_vw AS
SELECT p.policy_id, p.element_name, p.need_uid, p.policy_kind,
       'policy_without_matrix' AS gap_kind
FROM e01_778_05_tb p
WHERE NOT EXISTS (
    SELECT 1 FROM e01_778_02_tb m
    WHERE m.element_name = p.element_name
      AND m.need_uid = p.need_uid);

INSERT OR IGNORE INTO e01_506_03_tb (element_name, element_layer, element_kind, element_level, element_code) VALUES
('e04_778_10_vw','M','vw',4,'e04_778_10_vw'),
('e04_778_11_vw','M','vw',4,'e04_778_11_vw'),
('e04_778_12_vw','M','vw',4,'e04_778_12_vw'),
('e04_778_13_vw','M','vw',4,'e04_778_13_vw');

INSERT OR IGNORE INTO e01_778_05_tb (element_name, need_uid, policy_kind, exec_name, rationale, is_mandatory) VALUES
('e04_778_10_vw','N70','audit','e04_778_10_vw','Audit primary policy',1),
('e04_778_11_vw','N30','audit','e04_778_11_vw','Audit FK anchor',1),
('e04_778_12_vw','N30','audit','e04_778_12_vw','Audit trigger anchor',1),
('e04_778_13_vw','N71','audit','e04_778_13_vw','Audit orphan policy',1);

INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes) VALUES
('v27.0_phase5_audit_views', 'Phase 5 - 4 audit views');

UPDATE e01_676_02_tb SET schema_ver = 32, last_scan_at = datetime('now') WHERE id = 1;
