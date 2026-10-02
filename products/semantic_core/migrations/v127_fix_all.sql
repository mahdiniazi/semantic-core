.mode column
.headers on

BEGIN;

-- ═══ ۱. رفع trace I02 → e04_978_01_vw ═══
DELETE FROM e01_506_04_tb 
WHERE atom_uid = 'I02' AND element_name = 'e04_978_01_vw';

-- ═══ ۲. پاک کردن e04_978_01_vw از همه جا ═══
DELETE FROM e01_778_02_tb WHERE element_name = 'e04_978_01_vw';
DELETE FROM e01_778_05_tb WHERE element_name = 'e04_978_01_vw';
DELETE FROM e01_506_03_tb WHERE element_name = 'e04_978_01_vw';

-- ═══ ۳. رفع N99 (بدون سیاست) — placeholder audit ═══
INSERT OR IGNORE INTO e01_506_03_tb 
  (element_name, element_layer, element_kind, element_level)
VALUES 
  ('POLICY:N99', 'M', 'vw', 4);

INSERT OR IGNORE INTO e01_778_02_tb 
  (element_name, need_uid, is_primary, is_driving, role)
VALUES 
  ('POLICY:N99', 'N99', 0, 0, 'serves');

INSERT OR IGNORE INTO e01_778_05_tb 
  (element_name, need_uid, policy_kind, exec_name, rationale, is_mandatory)
VALUES 
  ('POLICY:N99', 'N99', 'audit', 'POLICY:N99',
   'Placeholder audit policy for N99 (Design phase end)', 1);

-- ═══ لاگ ═══
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v127_fix_all','Removed e04_978_01_vw completely + added N99 policy');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- ═══ تست ═══
SELECT severity, COUNT(*) AS n FROM e04_900_02_vw GROUP BY severity;

SELECT '' AS x;
SELECT kind, item, issue FROM e04_900_02_vw WHERE severity='critical';
