SELECT 'shell' AS component, 'رخدادها — 7 روز اخیر' AS title, 'fa' AS lang, 'rtl' AS direction;
SELECT 'table' AS component, 'تایم‌لاین' AS title;
SELECT src, project_id, at, type, summary FROM v_unified_timeline ORDER BY at DESC LIMIT 40;
