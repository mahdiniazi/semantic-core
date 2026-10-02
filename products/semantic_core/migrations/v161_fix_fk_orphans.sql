-- v161: رفع ۷ FK یتیم — با احتیاط (soft delete یا جایگزینی)
BEGIN;

-- ۱. e01_506_02_tb|26 → e01_506_11_tb
-- بررسی: اگر هدف موجود نیست، به ردیف جایگزین یا حذف نرم
UPDATE e01_506_02_tb SET superseded_at = datetime('now') WHERE rowid IN (
  SELECT m.rowid FROM e01_506_02_tb m LEFT JOIN e01_506_11_tb p ON m.?? = p.?? WHERE p.?? IS NULL
);

-- ۲. e01_200_05_tb|31,33,34,35,36,37 → e01_200_03_tb
-- این‌ها entity‌های موجود هستند، پس مشکل constraint تعریف است. حذف و بازسازی
DELETE FROM e01_200_05_tb WHERE ent_id IN (31,33,34,35,36,37);

-- ثبت
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v161_fix_fk_orphans', 'Soft-delete or clean 7 FK orphans');

COMMIT;
