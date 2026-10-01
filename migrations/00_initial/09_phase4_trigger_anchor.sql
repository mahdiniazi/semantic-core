-- =====================================================================
-- PHASE 4 — Trigger Anchor Migration
-- =====================================================================

-- 4.1 — Type hierarchy guards → N11
INSERT OR IGNORE INTO e01_778_05_tb (element_name, need_uid, policy_kind, exec_name, rationale, is_mandatory)
SELECT sm.name, 'N11', 'guard', sm.name, 'Type hierarchy guard ' || sm.name, 1
FROM sqlite_master sm
WHERE sm.type='trigger' AND sm.name LIKE 'e03_120%'
  AND NOT EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.exec_name=sm.name);

-- 4.2 — Entity guards → N10
INSERT OR IGNORE INTO e01_778_05_tb (element_name, need_uid, policy_kind, exec_name, rationale, is_mandatory)
SELECT sm.name, 'N10', 'guard', sm.name, 'Entity guard ' || sm.name, 1
FROM sqlite_master sm
WHERE sm.type='trigger' AND sm.name IN ('e03_120_04_tr','e03_120_05_tr')
  AND NOT EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.exec_name=sm.name);

-- 4.3 — is_a guards → N11
INSERT OR IGNORE INTO e01_778_05_tb (element_name, need_uid, policy_kind, exec_name, rationale, is_mandatory)
SELECT sm.name, 'N11', 'guard', sm.name, 'is_a guard ' || sm.name, 1
FROM sqlite_master sm
WHERE sm.type='trigger' AND sm.name LIKE 'e03_122%'
  AND NOT EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.exec_name=sm.name);

-- 4.4 — Relation validation → N12
INSERT OR IGNORE INTO e01_778_05_tb (element_name, need_uid, policy_kind, exec_name, rationale, is_mandatory)
SELECT sm.name, 'N12', 'guard', sm.name, 'Relation guard ' || sm.name, 1
FROM sqlite_master sm
WHERE sm.type='trigger' AND (sm.name LIKE 'e03_312%' OR sm.name LIKE 'e03_112%')
  AND NOT EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.exec_name=sm.name);

-- 4.5 — FTS sync → N41
INSERT OR IGNORE INTO e01_778_05_tb (element_name, need_uid, policy_kind, exec_name, rationale, is_mandatory)
SELECT sm.name, 'N41', 'sync', sm.name, 'FTS sync ' || sm.name, 1
FROM sqlite_master sm
WHERE sm.type='trigger' AND sm.name LIKE 'e03_434%'
  AND NOT EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.exec_name=sm.name);

-- 4.6 — Provenance fallback → N31
INSERT OR IGNORE INTO e01_778_05_tb (element_name, need_uid, policy_kind, exec_name, rationale, is_mandatory)
SELECT sm.name, 'N31', 'guard', sm.name, 'Provenance guard ' || sm.name, 1
FROM sqlite_master sm
WHERE sm.type='trigger' AND sm.name LIKE 'e03_343%'
  AND NOT EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.exec_name=sm.name);

-- 4.7 — Context sync → N15
INSERT OR IGNORE INTO e01_778_05_tb (element_name, need_uid, policy_kind, exec_name, rationale, is_mandatory)
SELECT sm.name, 'N15', 'sync', sm.name, 'Context sync ' || sm.name, 1
FROM sqlite_master sm
WHERE sm.type='trigger' AND sm.name LIKE 'e03_135%'
  AND NOT EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.exec_name=sm.name);

-- 4.8 — Text normalization + value member cycle → N11
INSERT OR IGNORE INTO e01_778_05_tb (element_name, need_uid, policy_kind, exec_name, rationale, is_mandatory)
SELECT sm.name, 'N11', 'guard', sm.name, 'Value guard ' || sm.name, 1
FROM sqlite_master sm
WHERE sm.type='trigger' AND sm.name LIKE 'e03_311%'
  AND NOT EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.exec_name=sm.name);

-- 4.9 — Node guards → N11
INSERT OR IGNORE INTO e01_778_05_tb (element_name, need_uid, policy_kind, exec_name, rationale, is_mandatory)
SELECT sm.name, 'N11', 'guard', sm.name, 'Node guard ' || sm.name, 1
FROM sqlite_master sm
WHERE sm.type='trigger' AND sm.name LIKE 'e03_516%'
  AND NOT EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.exec_name=sm.name);

-- 4.10 — Question guards → N11
INSERT OR IGNORE INTO e01_778_05_tb (element_name, need_uid, policy_kind, exec_name, rationale, is_mandatory)
SELECT sm.name, 'N11', 'guard', sm.name, 'Question guard ' || sm.name, 1
FROM sqlite_master sm
WHERE sm.type='trigger' AND sm.name LIKE 'e03_126%'
  AND NOT EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.exec_name=sm.name);

-- 4.11 — Delete guards → N30
INSERT OR IGNORE INTO e01_778_05_tb (element_name, need_uid, policy_kind, exec_name, rationale, is_mandatory)
SELECT sm.name, 'N30', 'guard', sm.name, 'Delete guard ' || sm.name, 1
FROM sqlite_master sm
WHERE sm.type='trigger' AND sm.name LIKE 'e03_320%'
  AND NOT EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.exec_name=sm.name);

-- 4.12 — Value guards → N12
INSERT OR IGNORE INTO e01_778_05_tb (element_name, need_uid, policy_kind, exec_name, rationale, is_mandatory)
SELECT sm.name, 'N12', 'guard', sm.name, 'Value guard ' || sm.name, 1
FROM sqlite_master sm
WHERE sm.type='trigger' AND sm.name LIKE 'e03_310%'
  AND NOT EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.exec_name=sm.name);

-- 4.13 — Immutability → N30
INSERT OR IGNORE INTO e01_778_05_tb (element_name, need_uid, policy_kind, exec_name, rationale, is_mandatory)
SELECT sm.name, 'N30', 'immutability', sm.name, 'Immutability ' || sm.name, 1
FROM sqlite_master sm
WHERE sm.type='trigger' AND sm.name LIKE 'e03_328%'
  AND NOT EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.exec_name=sm.name);

-- 4.14 — Semantic graph guards → N30
INSERT OR IGNORE INTO e01_778_05_tb (element_name, need_uid, policy_kind, exec_name, rationale, is_mandatory)
SELECT sm.name, 'N30', 'guard', sm.name, 'Semantic guard ' || sm.name, 1
FROM sqlite_master sm
WHERE sm.type='trigger' AND sm.name LIKE 'e03_370%'
  AND NOT EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.exec_name=sm.name);

-- 4.15 — Reification archive → N22
INSERT OR IGNORE INTO e01_778_05_tb (element_name, need_uid, policy_kind, exec_name, rationale, is_mandatory)
SELECT sm.name, 'N22', 'sync', sm.name, 'Reification archive ' || sm.name, 1
FROM sqlite_master sm
WHERE sm.type='trigger' AND sm.name LIKE 'e03_360%'
  AND NOT EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.exec_name=sm.name);

-- 4.16 — Field update tracker → N33
INSERT OR IGNORE INTO e01_778_05_tb (element_name, need_uid, policy_kind, exec_name, rationale, is_mandatory)
SELECT sm.name, 'N33', 'sync', sm.name, 'Field tracker ' || sm.name, 1
FROM sqlite_master sm
WHERE sm.type='trigger' AND sm.name LIKE 'e03_340%'
  AND NOT EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.exec_name=sm.name);

-- 4.17 — Phase 2 triggers stay with N70
INSERT OR IGNORE INTO e01_778_05_tb (element_name, need_uid, policy_kind, exec_name, rationale, is_mandatory)
SELECT sm.name, 'N70', 'guard', sm.name, 'Phase2 guard ' || sm.name, 1
FROM sqlite_master sm
WHERE sm.type='trigger' AND sm.name IN ('e03_778_11_tr','e03_778_13_tr','e03_778_14_tr')
  AND NOT EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.exec_name=sm.name);

-- 4.18 — Bridge immutability
INSERT OR IGNORE INTO e01_778_05_tb (element_name, need_uid, policy_kind, exec_name, rationale, is_mandatory)
SELECT sm.name, 'N50', 'immutability', sm.name, 'Bridge immutability ' || sm.name, 1
FROM sqlite_master sm
WHERE sm.type='trigger' AND sm.name IN ('e03_778_10_tr','e03_778_10b_tr')
  AND NOT EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.exec_name=sm.name);

-- 4.19 — Migration log
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes) VALUES
('v27.0_phase4_trigger_anchor', 'Phase 4 - Trigger anchor migration');

-- 4.20 — Bump schema_ver
UPDATE e01_676_02_tb SET schema_ver = 31, last_scan_at = datetime('now') WHERE id = 1;
