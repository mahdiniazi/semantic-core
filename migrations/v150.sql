.mode column
.headers on

BEGIN;

-- Context 1: hypothesis has condition "cold start"
INSERT OR IGNORE INTO e01_305_01_tb (ent_id, ctx_ent_id, role, prv_id)
SELECT 
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='hypothesis:p0301-coil-open'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='cond:cold-start'),
  'condition', 2
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='hypothesis:p0301-coil-open')
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='cond:cold-start');

-- Context 2: evidence has environment "hot weather"
INSERT OR IGNORE INTO e01_305_01_tb (ent_id, ctx_ent_id, role, prv_id)
SELECT 
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='evidence:p0301-resistance'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='env:hot-weather'),
  'environment', 2
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='evidence:p0301-resistance')
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='env:hot-weather');

-- Context 3: contradictory evidence has environment "high humidity"
INSERT OR IGNORE INTO e01_305_01_tb (ent_id, ctx_ent_id, role, prv_id)
SELECT 
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='evidence:p0301-spark-ok'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='env:high-humidity'),
  'environment', 2
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='evidence:p0301-spark-ok')
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='env:high-humidity');

-- Context 4: observation has condition "cold start"
INSERT OR IGNORE INTO e01_305_01_tb (ent_id, ctx_ent_id, role, prv_id)
SELECT 
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='observation:p0301-infinite'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='cond:cold-start'),
  'condition', 2
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='observation:p0301-infinite')
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='cond:cold-start');

-- Log + bump
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v150_context_seed', 'Seeded 4 entity contexts for P0301 chain');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- POST-CHECK
SELECT '═══ ۱. تعداد context relations ═══' AS section;
SELECT role, COUNT(*) AS n FROM e01_305_01_tb GROUP BY role;

SELECT '' AS x;
SELECT '═══ ۲. نمونه contextها ═══' AS section;
SELECT e.ent_uid AS entity, c.ent_uid AS context, ctx.role
FROM e01_305_01_tb ctx
JOIN e01_200_03_tb e ON e.ent_id=ctx.ent_id
JOIN e01_200_03_tb c ON c.ent_id=ctx.ctx_ent_id
ORDER BY e.ent_uid;

SELECT '' AS x;
SELECT '═══ ۳. Context Layer بعد از v150 ═══' AS section;
SELECT 'e01_305_01_tb' AS tbl, COUNT(*) AS n FROM e01_305_01_tb
UNION ALL SELECT 'e01_305_02_tb', COUNT(*) FROM e01_305_02_tb
UNION ALL SELECT 'e01_305_03_tb', COUNT(*) FROM e01_305_03_tb;

SELECT '' AS x;
SELECT '═══ ۴. وضعیت سلامت ═══' AS section;
SELECT severity, COUNT(*) AS n FROM e04_900_02_vw GROUP BY severity;
