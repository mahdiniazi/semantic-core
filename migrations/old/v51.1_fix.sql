.mode column
.headers on

BEGIN;

-- رفع تست shock-bounce (اگر ساخته نشده)
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id)
VALUES ('test:shock-bounce',
        (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Test'),
        'instance','تست جهش کمک‌فنر','فشار دادن و رها کردن',2);

-- ببینیم چند تا از تست‌ها ساخته شده
SELECT 'tests_created' AS k, COUNT(*) AS n FROM e01_200_03_tb WHERE ent_uid LIKE 'test:%' AND ent_uid IN (
  'test:shock-bounce','test:shock-leak-visual','test:spring-height',
  'test:balljoint-play','test:bushing-visual','test:wheel-alignment','test:road-test'
);

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;
COMMIT;

SELECT 'entities' AS k, COUNT(*) AS n FROM e01_200_03_tb
UNION ALL SELECT 'relations', COUNT(*) FROM e01_222_01_tb
UNION ALL SELECT 'susp_diagnoses', COUNT(*) FROM e01_200_03_tb WHERE ent_uid IN (
  'diagnosis:shock-failed','diagnosis:spring-failed','diagnosis:balljoint-failed',
  'diagnosis:bushing-failed','diagnosis:align-failed'
);
