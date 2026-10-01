.mode column
.headers on

BEGIN;

-- ثبت e01_202_02_tb در registry
INSERT OR IGNORE INTO e01_506_03_tb 
  (element_name, element_layer, element_kind, element_level, need_uid)
VALUES 
  ('e01_202_02_tb', 'M', 'tb', 1, 'N50');

-- anchor در matrix
INSERT OR IGNORE INTO e01_778_02_tb 
  (element_name, need_uid, is_primary, is_driving, role)
VALUES 
  ('e01_202_02_tb', 'N50', 0, 0, 'serves');

-- anchor در policy bridge
INSERT OR IGNORE INTO e01_778_05_tb 
  (element_name, need_uid, policy_kind, exec_name, rationale, is_mandatory)
VALUES 
  ('e01_202_02_tb', 'N50', 'audit', 'e01_202_02_tb',
   'Reification rules table - documentation', 1);

-- لاگ
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v117_register_reification','Registered e01_202_02_tb in registry + matrix + policy');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- ═══ گزارش ═══
SELECT '═══ GATE نهایی ═══' AS section;
SELECT 'GATE' AS gate_status, 
  (SELECT COUNT(*) FROM e04_978_01_vw WHERE has_violation=1) AS self_fails,
  (SELECT COUNT(*) FROM v_orphan_gate) AS orphans;

SELECT '' AS x;
SELECT '═══ orphan باقی‌مانده ═══' AS section;
SELECT orphan_kind, orphan_name FROM v_orphan_gate;
