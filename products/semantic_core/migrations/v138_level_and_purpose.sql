-- v138 — level=4 برای POLICY + purpose برای 20 عنصر کلیدی
.mode column
.headers on

BEGIN;

-- ═══ بخش ۱: level=4 برای ۳۲ POLICY:XXx ═══
UPDATE e01_506_03_tb
SET element_level = 4
WHERE element_name LIKE 'POLICY:%' AND element_level IS NULL;

-- ═══ بخش ۲: purpose برای ۲۰ عنصر کلیدی ═══

-- لایه T — Type
UPDATE e01_506_03_tb SET purpose='انواع entity — هستی‌شناسی اصلی' WHERE element_name='e01_200_01_tb';
UPDATE e01_506_03_tb SET purpose='انواع رابطه — زبان ارتباطات معنایی' WHERE element_name='e01_202_01_tb';
UPDATE e01_506_03_tb SET purpose='enum domain — دامنه‌های بسته مقدار' WHERE element_name='e01_200_02_tb';
UPDATE e01_506_03_tb SET purpose='قواعد جای‌گذاری — مغز سیستم auto_place' WHERE element_name='e01_200_04_tb';
UPDATE e01_506_03_tb SET purpose='صف انتظار pending — entity بدون قاعده' WHERE element_name='e01_200_05_tb';
UPDATE e01_506_03_tb SET purpose='constraint — محدودیت‌های ساختاری' WHERE element_name='e01_112_01_tb';
UPDATE e01_506_03_tb SET purpose='closure — بستار transitive نوع‌ها' WHERE element_name='e01_120_01_tb';
UPDATE e01_506_03_tb SET purpose='جای‌گذاری خودکار entity جدید بر اساس نوع' WHERE element_name='e03_200_04_auto_place';
UPDATE e01_506_03_tb SET purpose='حل خودکار pending پس از افزودن قاعده' WHERE element_name='e03_200_04_resolve_pending';
UPDATE e01_506_03_tb SET purpose='ثبت entity بدون قاعده در صف انتظار' WHERE element_name='e03_200_05_pending';

-- لایه C — Core
UPDATE e01_506_03_tb SET purpose='entity‌ها — هسته‌ی داده معنایی' WHERE element_name='e01_200_03_tb';
UPDATE e01_506_03_tb SET purpose='رابطه‌ها — هسته‌ی ارتباطات' WHERE element_name='e01_222_01_tb';
UPDATE e01_506_03_tb SET purpose='مقادیر عدد/متن/بولی/تاریخ' WHERE element_name='e01_201_02_tb';
UPDATE e01_506_03_tb SET purpose='membership مقادیر ترکیبی' WHERE element_name='e01_201_03_tb';
UPDATE e01_506_03_tb SET purpose='تبار entity — از کجا آمده' WHERE element_name='e01_302_01_tb';
UPDATE e01_506_03_tb SET purpose='منبع دانش — provenance' WHERE element_name='e01_303_01_tb';

-- لایه X — Context
UPDATE e01_506_03_tb SET purpose='context entity — زمینه‌ی entity' WHERE element_name='e01_305_01_tb';
UPDATE e01_506_03_tb SET purpose='context value — زمینه‌ی مقدار' WHERE element_name='e01_305_02_tb';
UPDATE e01_506_03_tb SET purpose='context relation — زمینه‌ی رابطه' WHERE element_name='e01_305_03_tb';

-- حاکمیت
UPDATE e01_506_03_tb SET purpose='registry — کاتالوگ عناصر schema' WHERE element_name='e01_506_03_tb';
UPDATE e01_506_03_tb SET purpose='matrix — ماتریس element↔need' WHERE element_name='e01_778_02_tb';
UPDATE e01_506_03_tb SET purpose='policy — سیاست محافظت عناصر' WHERE element_name='e01_778_05_tb';
UPDATE e01_506_03_tb SET purpose='migration log — تاریخ تغییرات' WHERE element_name='e01_676_01_tb';
UPDATE e01_506_03_tb SET purpose='schema version — شمارنده‌ی نسخه' WHERE element_name='e01_676_02_tb';

-- گزارش سلامت (سه‌گانه)
UPDATE e01_506_03_tb SET purpose='گزارش سلامت — ۱۷ چک ساختاری در سه سطح' WHERE element_name='e04_900_02_vw';

-- log + bump
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v138_level_and_purpose', 
        'Set level=4 for POLICY:*, filled purpose for 25 key elements');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- ═══ POST-CHECK ═══
SELECT '═══ ۱. POLICYها با level ═══' AS section;
SELECT element_level, COUNT(*) AS n 
FROM e01_506_03_tb WHERE element_name LIKE 'POLICY:%' 
GROUP BY element_level;

SELECT '' AS x;
SELECT '═══ ۲. چند عنصر purpose دارند ═══' AS section;
SELECT 
  COUNT(*) AS total,
  SUM(CASE WHEN purpose IS NOT NULL AND purpose != '' THEN 1 ELSE 0 END) AS with_purpose
FROM e01_506_03_tb;

SELECT '' AS x;
SELECT '═══ ۳. بی‌level باقی‌مانده (باید ۰ باشد) ═══' AS section;
SELECT COUNT(*) AS n FROM e01_506_03_tb WHERE element_level IS NULL;

SELECT '' AS x;
SELECT '═══ ۴. health ═══' AS section;
SELECT severity, COUNT(*) AS n FROM e04_900_02_vw GROUP BY severity;
