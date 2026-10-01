.mode column
.headers on

SELECT '═══ ۱. typeهای Knowledge Layer ═══' AS section;
SELECT t.type_uid, COUNT(e.ent_id) AS entities
FROM e01_200_01_tb t
LEFT JOIN e01_200_03_tb e ON e.type_id = t.type_id
WHERE t.type_uid IN ('Hypothesis','Evidence','Observation','Measurement','Signal','Configuration','Role','Context','Reference','Prediction','Provenance')
GROUP BY t.type_uid
ORDER BY t.type_uid;

SELECT '' AS x;
SELECT '═══ ۲. جدول‌های Knowledge Layer ═══' AS section;
SELECT 'e01_300_01_tb (Identity)' AS table_name, COUNT(*) AS rows FROM e01_300_01_tb
UNION ALL SELECT 'e01_302_01_tb (Lineage)', COUNT(*) FROM e01_302_01_tb
UNION ALL SELECT 'e01_303_01_tb (Provenance)', COUNT(*) FROM e01_303_01_tb
UNION ALL SELECT 'e01_305_01_tb (Context entity)', COUNT(*) FROM e01_305_01_tb
UNION ALL SELECT 'e01_305_02_tb (Context value)', COUNT(*) FROM e01_305_02_tb
UNION ALL SELECT 'e01_305_03_tb (Context relation)', COUNT(*) FROM e01_305_03_tb
UNION ALL SELECT 'e01_330_01_tb (Version)', COUNT(*) FROM e01_330_01_tb
UNION ALL SELECT 'e01_330_02_tb (Snapshot)', COUNT(*) FROM e01_330_02_tb;

SELECT '' AS x;
SELECT '═══ ۳. ساختار e01_300_01_tb (Identity) ═══' AS section;
SELECT sql FROM sqlite_master WHERE name='e01_300_01_tb';

SELECT '' AS x;
SELECT '═══ ۴. ساختار e01_305_01_tb (Context entity) ═══' AS section;
SELECT sql FROM sqlite_master WHERE name='e01_305_01_tb';

SELECT '' AS x;
SELECT '═══ ۵. ساختار e01_305_02_tb (Context value) ═══' AS section;
SELECT sql FROM sqlite_master WHERE name='e01_305_02_tb';

SELECT '' AS x;
SELECT '═══ ۶. ساختار e01_305_03_tb (Context relation) ═══' AS section;
SELECT sql FROM sqlite_master WHERE name='e01_305_03_tb';

SELECT '' AS x;
SELECT '═══ ۷. ساختار e01_303_01_tb (Provenance) ═══' AS section;
SELECT sql FROM sqlite_master WHERE name='e01_303_01_tb';

SELECT '' AS x;
SELECT '═══ ۸. ساختار e01_330_01_tb (Version) ═══' AS section;
SELECT sql FROM sqlite_master WHERE name='e01_330_01_tb';

SELECT '' AS x;
SELECT '═══ ۹. روابط Knowledge Layer که صفر هستند ═══' AS section;
SELECT rt.type_uid, COUNT(r.rel_id) AS n
FROM e01_202_01_tb rt
LEFT JOIN e01_222_01_tb r ON r.reltype_id = rt.reltype_id
WHERE rt.type_uid IN ('supports','contradicts','derived_from','attributed_to','verified_by','ruled_out','observed_value','measures','has_state','has_severity','detectable_by','detected_by')
GROUP BY rt.type_uid
ORDER BY n DESC, rt.type_uid;
