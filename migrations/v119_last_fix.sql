.mode column
.headers on

BEGIN;

-- ═══ ۱. اتصال e01_506_12_tb به matrix ═══
INSERT OR IGNORE INTO e01_778_02_tb 
  (element_name, need_uid, is_primary, is_driving, role)
VALUES 
  ('e01_506_12_tb', 'N70', 0, 0, 'serves');

-- ═══ ۲. anchor در policy bridge ═══
INSERT OR IGNORE INTO e01_778_05_tb 
  (element_name, need_uid, policy_kind, exec_name, rationale, is_mandatory)
VALUES 
  ('e01_506_12_tb', 'N70', 'audit', 'e01_506_12_tb',
   'Need tree cache — serves element registration', 1);

-- ═══ ۳. لاگ ═══
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v119_last_fix','Anchored e01_506_12_tb in matrix + policy');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- ═══ گزارش نهایی ═══
SELECT '═══ GATE نهایی ═══' AS section;
SELECT 'GATE' AS gate_status, 
  (SELECT COUNT(*) FROM e04_978_01_vw WHERE has_violation=1) AS self_fails,
  (SELECT COUNT(*) FROM v_orphan_gate) AS orphans;

SELECT '' AS x;
SELECT '═══ داشبورد نهایی ═══' AS section;
SELECT domain, declared, realized, coverage_pct, status
FROM e04_900_01_vw
ORDER BY 
  CASE status WHEN 'critical' THEN 1 WHEN 'watch' THEN 2 
              WHEN 'healthy' THEN 3 ELSE 4 END,
  domain;

SELECT '' AS x;
SELECT '═══ وضعیت کلی ═══' AS section;
SELECT status, COUNT(*) AS n
FROM e04_900_01_vw
GROUP BY status;
