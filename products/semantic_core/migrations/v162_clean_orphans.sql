-- v162: پاک‌سازی قطعی ردیف‌های یتیم e01_200_05_tb
BEGIN;
DELETE FROM e01_200_05_tb WHERE ent_uid NOT IN (SELECT ent_uid FROM e01_200_03_tb);
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v162_clean_orphans','Clean orphan rows from e01_200_05_tb per Law 12');
COMMIT;
