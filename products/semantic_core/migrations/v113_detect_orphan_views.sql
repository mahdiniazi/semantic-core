.mode column
.headers on

-- ═══════════════════════════════════════════════════════
-- ۱. همه viewها در sqlite_master
-- ═══════════════════════════════════════════════════════
SELECT '═══ ۱. همه viewها ═══' AS section;
SELECT name
FROM sqlite_master
WHERE type='view' AND name LIKE 'v_%'
ORDER BY name;

-- ═══════════════════════════════════════════════════════
-- ۲. کدام view در registry ثبت نشده؟
-- ═══════════════════════════════════════════════════════
SELECT '' AS x;
SELECT '═══ ۲. ثبت‌نشده در registry ═══' AS section;
SELECT sm.name AS view_name
FROM sqlite_master sm
WHERE sm.type='view' AND sm.name LIKE 'v_%'
  AND NOT EXISTS (
    SELECT 1 FROM e01_506_03_tb r
    WHERE r.element_name = sm.name
  )
ORDER BY sm.name;

-- ═══════════════════════════════════════════════════════
-- ۳. کدام view در matrix ثبت نشده؟
-- ═══════════════════════════════════════════════════════
SELECT '' AS x;
SELECT '═══ ۳. ثبت‌نشده در matrix ═══' AS section;
SELECT sm.name AS view_name
FROM sqlite_master sm
WHERE sm.type='view' AND sm.name LIKE 'v_%'
  AND NOT EXISTS (
    SELECT 1 FROM e01_778_02_tb m
    WHERE m.element_name = sm.name
  )
ORDER BY sm.name;

-- ═══════════════════════════════════════════════════════
-- ۴. کدام view در policy bridge anchor نشده؟
-- ═══════════════════════════════════════════════════════
SELECT '' AS x;
SELECT '═══ ۴. anchor نشده در policy ═══' AS section;
SELECT sm.name AS view_name
FROM sqlite_master sm
WHERE sm.type='view' AND sm.name LIKE 'v_%'
  AND NOT EXISTS (
    SELECT 1 FROM e01_778_05_tb p
    WHERE p.element_name = sm.name
  )
ORDER BY sm.name;

-- ═══════════════════════════════════════════════════════
-- ۵. کدام view به کدام نیاز وصل شود؟
-- ═══════════════════════════════════════════════════════
SELECT '' AS x;
SELECT '═══ ۵. نیازهای مرتبط با view ═══' AS section;
SELECT need_uid, need_label FROM e01_506_01_tb 
WHERE need_uid IN ('N70','N50','N71','N30','N51','N52','N42')
ORDER BY need_uid;
