.mode column
.headers on

BEGIN;

-- ═══ Context 1: ولتاژ باتری 12.0V در هوای گرم ═══
INSERT OR IGNORE INTO e01_305_02_tb (val_id, ctx_ent_id, role, prv_id)
SELECT 
  (SELECT val_id FROM e01_201_02_tb WHERE num_val=12.0 AND unit='V' LIMIT 1),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='env:hot-weather'),
  'environment', 2
WHERE EXISTS (SELECT 1 FROM e01_201_02_tb WHERE num_val=12.0 AND unit='V')
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='env:hot-weather');

-- ═══ Context 2: ولتاژ دینام 14.5V در cold-start ═══
INSERT OR IGNORE INTO e01_305_02_tb (val_id, ctx_ent_id, role, prv_id)
SELECT 
  (SELECT val_id FROM e01_201_02_tb WHERE num_val=14.5 AND unit='V' LIMIT 1),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='cond:cold-start'),
  'condition', 2
WHERE EXISTS (SELECT 1 FROM e01_201_02_tb WHERE num_val=14.5 AND unit='V')
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='cond:cold-start');

-- ═══ Context 3: مقاومت کوئل 0.8Ω در cold-start ═══
INSERT OR IGNORE INTO e01_305_02_tb (val_id, ctx_ent_id, role, prv_id)
SELECT 
  (SELECT val_id FROM e01_201_02_tb WHERE num_val=0.8 AND unit='O' LIMIT 1),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='cond:cold-start'),
  'condition', 2
WHERE EXISTS (SELECT 1 FROM e01_201_02_tb WHERE num_val=0.8 AND unit='O')
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='cond:cold-start');

-- ═══ Context 4: فشار سوخت 3.5bar در هوای گرم ═══
INSERT OR IGNORE INTO e01_305_02_tb (val_id, ctx_ent_id, role, prv_id)
SELECT 
  (SELECT val_id FROM e01_201_02_tb WHERE num_val=3.5 AND unit='bar' LIMIT 1),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='env:hot-weather'),
  'environment', 2
WHERE EXISTS (SELECT 1 FROM e01_201_02_tb WHERE num_val=3.5 AND unit='bar')
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='env:hot-weather');

-- ═══ Context 5: دمای آب 90C در cold-start ═══
INSERT OR IGNORE INTO e01_305_02_tb (val_id, ctx_ent_id, role, prv_id)
SELECT 
  (SELECT val_id FROM e01_201_02_tb WHERE num_val=90.0 AND unit='C' LIMIT 1),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='cond:cold-start'),
  'condition', 2
WHERE EXISTS (SELECT 1 FROM e01_201_02_tb WHERE num_val=90.0 AND unit='C')
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='cond:cold-start');

-- ═══ Context 6: ولتاژ مرجع 4.5V در cold-start ═══
INSERT OR IGNORE INTO e01_305_02_tb (val_id, ctx_ent_id, role, prv_id)
SELECT 
  (SELECT val_id FROM e01_201_02_tb WHERE num_val=4.5 AND unit='V' LIMIT 1),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='cond:cold-start'),
  'condition', 2
WHERE EXISTS (SELECT 1 FROM e01_201_02_tb WHERE num_val=4.5 AND unit='V')
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='cond:cold-start');

-- ═══ Log + bump ═══
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v152_context_on_values', 'Seeded 6 value-level contexts');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- ═══ POST-CHECK ═══
SELECT '═══ ۱. Context Layer کامل (سه‌ضلعی) ═══' AS section;
SELECT 'entity_context' AS tbl, COUNT(*) AS n FROM e01_305_01_tb
UNION ALL SELECT 'value_context', COUNT(*) FROM e01_305_02_tb
UNION ALL SELECT 'relation_context', COUNT(*) FROM e01_305_03_tb;

SELECT '' AS x;
SELECT '═══ ۲. نمونه context بر value ═══' AS section;
SELECT v.num_val AS value, v.unit AS unit, c.ent_uid AS context, ctx.role
FROM e01_305_02_tb ctx
JOIN e01_201_02_tb v ON v.val_id = ctx.val_id
JOIN e01_200_03_tb c ON c.ent_id = ctx.ctx_ent_id
ORDER BY v.val_id;

SELECT '' AS x;
SELECT '═══ ۳. سلامت ═══' AS section;
SELECT severity, COUNT(*) AS n FROM e04_900_02_vw GROUP BY severity;
