-- =====================================================================
-- v27.16 Phase 5.1 Last Fix — matrix + anchor for e03_778_02_ins_tr
-- =====================================================================

-- Add to matrix
INSERT OR IGNORE INTO e01_778_02_tb 
(element_name, need_uid, is_primary, is_driving, role)
VALUES ('e03_778_02_ins_tr','N70',0,0,'serves');

-- Add to policy bridge
INSERT OR IGNORE INTO e01_778_05_tb 
(element_name, need_uid, policy_kind, exec_name, rationale, is_mandatory)
VALUES ('e03_778_02_ins_tr','N70','guard','e03_778_02_ins_tr',
        'Matrix insert guard for element and need validation',1);

-- Log
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v27.16_phase5_1_last_fix', 'Anchored e03_778_02_ins_tr');

-- Bump
UPDATE e01_676_02_tb SET schema_ver = 57, last_scan_at = datetime('now') WHERE id = 1;
