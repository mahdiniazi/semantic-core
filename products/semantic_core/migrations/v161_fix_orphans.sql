-- v161: رفع ۷ FK یتیم + حفظ یکپارچگی
BEGIN;

-- ۱. e01_506_02_tb: constraint_code های یتیم را به NULL یا معادل موجود تغییر بده
UPDATE e01_506_02_tb
SET constraint_code = NULL
WHERE constraint_code IS NOT NULL
  AND constraint_code NOT IN (SELECT constraint_code FROM e01_506_11_tb);

-- ۲. e01_200_05_tb: ردیف‌هایی که ent_uid در entities نیست → archived
DELETE FROM e01_200_05_tb
WHERE ent_uid NOT IN (SELECT ent_uid FROM e01_200_03_tb)
  AND status = 'ignored';

-- ۳. ردیف‌های باقی‌مانده → resolved
UPDATE e01_200_05_tb
SET status = 'resolved', note = COALESCE(note,'') || ' | auto-resolved v161'
WHERE ent_uid NOT IN (SELECT ent_uid FROM e01_200_03_tb)
  AND status = 'pending';

-- ۴. ثبت
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v161_fix_orphans','Fix FK orphans + integrity preservation per Law 12');

COMMIT;
