.mode column
.headers on

BEGIN;

-- حذف viewهای اضافی
DROP VIEW IF EXISTS e04_900_01_vw;
DROP VIEW IF EXISTS v_orphan_gate;
DROP VIEW IF EXISTS v_pride_ancestors;
DROP VIEW IF EXISTS v_vehicle_tree;
DROP VIEW IF EXISTS v_full_hierarchy;

-- پاک کردن از registry
DELETE FROM e01_506_03_tb WHERE element_name IN (
  'e04_900_01_vw','v_orphan_gate','v_pride_ancestors',
  'v_vehicle_tree','v_full_hierarchy'
);
DELETE FROM e01_778_02_tb WHERE element_name IN (
  'e04_900_01_vw','v_orphan_gate','v_pride_ancestors',
  'v_vehicle_tree','v_full_hierarchy'
);
DELETE FROM e01_778_05_tb WHERE element_name IN (
  'e04_900_01_vw','v_orphan_gate','v_pride_ancestors',
  'v_vehicle_tree','v_full_hierarchy'
);

INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v128_cleanup','Dropped 5 extra views, kept only health + 2 services');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- ═══ گزارش ═══
SELECT '═══ viewهای باقی‌مانده ═══' AS section;
SELECT name FROM sqlite_master WHERE type='view' AND name LIKE 'v_%' OR name LIKE 'e04_%'
ORDER BY name;

SELECT '' AS x;
SELECT '═══ وضعیت سلامت ═══' AS section;
SELECT severity, COUNT(*) AS n FROM e04_900_02_vw GROUP BY severity;
