.mode column
.headers on

BEGIN;

-- ═══ Context 1: supports فقط در cold-start معتبر است ═══
INSERT OR IGNORE INTO e01_305_03_tb (rel_id, ctx_ent_id, role, prv_id)
SELECT 
  (SELECT rel_id FROM e01_222_01_tb WHERE rel_uid='r:evidence-p0301-supports-hypothesis'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='cond:cold-start'),
  'condition', 2
WHERE EXISTS (SELECT 1 FROM e01_222_01_tb WHERE rel_uid='r:evidence-p0301-supports-hypothesis')
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='cond:cold-start');

-- ═══ Context 2: contradicts فقط در high-humidity معتبر است ═══
INSERT OR IGNORE INTO e01_305_03_tb (rel_id, ctx_ent_id, role, prv_id)
SELECT 
  (SELECT rel_id FROM e01_222_01_tb WHERE rel_uid='r:evidence-p0301-spark-contradicts-coil-open'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='env:high-humidity'),
  'environment', 2
WHERE EXISTS (SELECT 1 FROM e01_222_01_tb WHERE rel_uid='r:evidence-p0301-spark-contradicts-coil-open')
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='env:high-humidity');

-- ═══ Context 3: measures در cold-start ═══
INSERT OR IGNORE INTO e01_305_03_tb (rel_id, ctx_ent_id, role, prv_id)
SELECT 
  (SELECT rel_id FROM e01_222_01_tb WHERE rel_uid='r:obs-p0301-measures-resistance'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='cond:cold-start'),
  'condition', 2
WHERE EXISTS (SELECT 1 FROM e01_222_01_tb WHERE rel_uid='r:obs-p0301-measures-resistance')
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='cond:cold-start');

-- ═══ Context 4: suspects در cold-start ═══
INSERT OR IGNORE INTO e01_305_03_tb (rel_id, ctx_ent_id, role, prv_id)
SELECT 
  (SELECT rel_id FROM e01_222_01_tb WHERE rel_uid='r:hypothesis-p0301-suspects-coil-open'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='cond:cold-start'),
  'condition', 2
WHERE EXISTS (SELECT 1 FROM e01_222_01_tb WHERE rel_uid='r:hypothesis-p0301-suspects-coil-open')
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='cond:cold-start');

-- ═══ Log + bump ═══
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v151_context_on_relations', 'Seeded 4 relation-level contexts for P0301 chain');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- ═══ POST-CHECK ═══
SELECT '═══ ۱. Context Layer کامل ═══' AS section;
SELECT 'entity_context (305_01)' AS tbl, COUNT(*) AS n FROM e01_305_01_tb
UNION ALL SELECT 'value_context (305_02)', COUNT(*) FROM e01_305_02_tb
UNION ALL SELECT 'relation_context (305_03)', COUNT(*) FROM e01_305_03_tb;

SELECT '' AS x;
SELECT '═══ ۲. نمونه context بر relation ═══' AS section;
SELECT r.rel_uid AS relation, c.ent_uid AS context, ctx.role
FROM e01_305_03_tb ctx
JOIN e01_222_01_tb r ON r.rel_id = ctx.rel_id
JOIN e01_200_03_tb c ON c.ent_id = ctx.ctx_ent_id
ORDER BY r.rel_uid;

SELECT '' AS x;
SELECT '═══ ۳. سلامت ═══' AS section;
SELECT severity, COUNT(*) AS n FROM e04_900_02_vw GROUP BY severity;
