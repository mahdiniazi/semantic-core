-- v84 — رفع ignition-switch + کوئری تشخیص درست
.mode column
.headers on

BEGIN;

-- ═══════════════════════════════════════════════════════
-- ۱. ساخت ignition-switch
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('concept:ignition-switch',
 (SELECT type_id FROM e01_200_01_tb WHERE type_uid='IgnitionSwitch'),
 'concept','سوئیچ ignition','سوئیچ استارت خودرو',2);

-- اتصال به starting-subsystem
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
VALUES
('r:starting-subsystem-has-switch',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_part'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:starting-subsystem'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:ignition-switch'),'asserted',2);

INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v84_final_fix','Added ignition-switch to starting-subsystem');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- ═══════════════════════════════════════════════════════
-- گزارش
-- ═══════════════════════════════════════════════════════
SELECT 'entities' AS k, COUNT(*) AS n FROM e01_200_03_tb
UNION ALL SELECT 'relations', COUNT(*) FROM e01_222_01_tb;

SELECT '=== زیرسیستم‌ها ===' AS section;
SELECT 
  sub.label AS subsystem,
  COUNT(*) AS n
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='has_part'
JOIN e01_200_03_tb sub ON sub.ent_id = r.subj_ent_id
WHERE sub.ent_uid LIKE 'concept:%-subsystem'
  AND r.status='asserted' AND r.superseded_at IS NULL
GROUP BY sub.ent_uid
ORDER BY n ASC;
