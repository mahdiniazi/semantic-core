.mode column
.headers on

BEGIN;

-- حذف e04_978_01_vw از registry (چون دیگر وجود ندارد)
DELETE FROM e01_778_02_tb WHERE element_name = 'e04_978_01_vw';
DELETE FROM e01_778_05_tb WHERE element_name = 'e04_978_01_vw';
DELETE FROM e01_506_03_tb WHERE element_name = 'e04_978_01_vw';

INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v126_fix_one','Removed e04_978_01_vw from registry (view dropped in v122)');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- تست
SELECT severity, COUNT(*) AS n FROM e04_900_02_vw GROUP BY severity;
