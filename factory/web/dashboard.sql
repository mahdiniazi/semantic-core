-- dashboard.sql — نمای کلی پایگاه دانش خودرو
SELECT 'shell' AS component,
       'پایگاه دانش برق خودرو — داشبورد' AS title,
       'fa' AS lang,
       'rtl' AS direction;

SELECT 'table' AS component, 'آمار کلی' AS title;
SELECT 'انواع (Type)' AS متریک, COUNT(*) AS مقدار FROM e01_200_01_tb
UNION ALL SELECT 'موجودیت (Entity)', COUNT(*) FROM e01_200_03_tb
UNION ALL SELECT 'رابطه (Relation)', COUNT(*) FROM e01_222_01_tb
UNION ALL SELECT 'Context entity', COUNT(*) FROM e01_305_01_tb
UNION ALL SELECT 'Claim', COUNT(*) FROM e01_200_03_tb WHERE ent_uid LIKE 'claim:%'
UNION ALL SELECT 'Evidence', COUNT(*) FROM e01_200_03_tb WHERE ent_uid LIKE 'evidence:%';
