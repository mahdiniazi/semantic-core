-- ============================================================
-- v27.21 — تشخیص درخت نیاز، triggerها، و watch
-- ============================================================

.mode column
.headers on

-- ۱. آیا e01_506_06_tb اصلاً ساختار درست دارد؟
SELECT '--- 1. schema of e01_506_06_tb ---' AS section;
SELECT sql FROM sqlite_master WHERE name = 'e01_506_06_tb';

-- ۲. چند ردیف دارد؟
SELECT '--- 2. row count ---' AS section;
SELECT COUNT(*) AS total_nodes FROM e01_506_06_tb;

-- ۳. ستون‌ها چه نام دارند؟
SELECT '--- 3. columns ---' AS section;
SELECT name, type, "notnull" FROM pragma_table_info('e01_506_06_tb');

-- ۴. توزیع ریشه و فرزند
SELECT '--- 4. tree distribution ---' AS section;
SELECT
  SUM(CASE WHEN parent_id IS NULL THEN 1 ELSE 0 END) AS roots,
  SUM(CASE WHEN parent_id IS NOT NULL THEN 1 ELSE 0 END) AS children,
  COUNT(DISTINCT parent_id) AS distinct_parents,
  COUNT(DISTINCT need_uid) AS needs_covered
FROM e01_506_06_tb;

-- ۵. کدام needها گره دارند؟
SELECT '--- 5. nodes per need (top 10) ---' AS section;
SELECT need_uid, COUNT(*) AS n
FROM e01_506_06_tb
GROUP BY need_uid
ORDER BY n DESC
LIMIT 10;

-- ۶. نمونه ردیف‌ها
SELECT '--- 6. sample rows ---' AS section;
SELECT * FROM e01_506_06_tb LIMIT 10;

-- ۷. watch فعلی کدام domain است؟
SELECT '--- 7. current watch ---' AS section;
SELECT domain, declared, realized, coverage_pct, severity_class, status
FROM e04_900_01_vw
WHERE status = 'watch';

-- ۸. کدام element در matrix نیست؟
SELECT '--- 8. unanchored elements ---' AS section;
SELECT e.element_name, e.element_kind, e.element_layer
FROM e01_506_03_tb e
WHERE e.element_kind IN ('tb','tr','vw','ft')
  AND e.element_name NOT LIKE 'POLICY:%'
  AND NOT EXISTS (SELECT 1 FROM e01_778_02_tb m WHERE m.element_name = e.element_name)
ORDER BY e.element_name;

-- ۹. triggerها روی جداول WITHOUT ROWID
SELECT '--- 9. triggers on WITHOUT ROWID tables ---' AS section;
SELECT
  sm.name AS tbl,
  (SELECT COUNT(*) FROM sqlite_master t
   WHERE t.type='trigger' AND t.tbl_name = sm.name) AS triggers
FROM sqlite_master sm
WHERE sm.type='table'
  AND sm.sql LIKE '%WITHOUT ROWID%'
  AND sm.name NOT LIKE 'sqlite_%';

-- ۱۰. e03_370_14_tr واقعاً کجاست؟
SELECT '--- 10. e03_370_14_tr location ---' AS section;
SELECT name, tbl_name FROM sqlite_master
WHERE name IN ('e03_370_14_tr','e03_778_02_ins_tr','e03_778_14_tr','e03_328_03_tr');

-- ۱۱. e01_676_02_tb ساختار و محتوا
SELECT '--- 11. schema state ---' AS section;
SELECT * FROM e01_676_02_tb;
