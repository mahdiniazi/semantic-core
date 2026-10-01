-- v113 — ساخت دروازه ارگانیک + ثبت ۵ view یتیم
.mode column
.headers on

BEGIN;

-- ═══════════════════════════════════════════════════════
-- بخش ۱ — ثبت ۵ view یتیم در registry
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_506_03_tb 
  (element_name, element_layer, element_kind, element_level, need_uid)
VALUES
  ('v_full_hierarchy',    'M', 'vw', 4, 'N70'),
  ('v_has_part_transitive','M','vw', 4, 'N30'),
  ('v_instance_parts',    'M', 'vw', 4, 'N70'),
  ('v_pride_ancestors',   'M', 'vw', 4, 'N71'),
  ('v_vehicle_tree',      'M', 'vw', 4, 'N70');

-- ═══════════════════════════════════════════════════════
-- بخش ۲ — anchor در matrix
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_778_02_tb (element_name, need_uid, is_primary, is_driving, role)
VALUES
  ('v_full_hierarchy',    'N70', 0, 0, 'serves'),
  ('v_has_part_transitive','N30', 0, 0, 'serves'),
  ('v_instance_parts',    'N70', 0, 0, 'serves'),
  ('v_pride_ancestors',   'N71', 0, 0, 'serves'),
  ('v_vehicle_tree',      'N70', 0, 0, 'serves');

-- ═══════════════════════════════════════════════════════
-- بخش ۳ — anchor در policy bridge
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_778_05_tb 
  (element_name, need_uid, policy_kind, exec_name, rationale, is_mandatory)
VALUES
  ('v_full_hierarchy',    'N70', 'audit', 'v_full_hierarchy',    'Audit view: whole hierarchy',   1),
  ('v_has_part_transitive','N30','audit', 'v_has_part_transitive','Audit view: transitive closure', 1),
  ('v_instance_parts',    'N70', 'audit', 'v_instance_parts',    'Audit view: instance parts',    1),
  ('v_pride_ancestors',   'N71', 'audit', 'v_pride_ancestors',   'Audit view: ancestors',         1),
  ('v_vehicle_tree',      'N70', 'audit', 'v_vehicle_tree',      'Audit view: vehicle tree',      1);

-- ═══════════════════════════════════════════════════════
-- بخش ۴ — ساخت دروازه (Gate) — view که orphanها را می‌شمارد
-- ═══════════════════════════════════════════════════════
DROP VIEW IF EXISTS v_orphan_gate;
CREATE VIEW v_orphan_gate AS
SELECT 'view_not_in_registry' AS orphan_kind, sm.name AS orphan_name
FROM sqlite_master sm
WHERE sm.type IN ('view','trigger','table')
  AND sm.name LIKE 'v_%' OR sm.name LIKE 'e03_%' OR sm.name LIKE 'e01_%'
  AND sm.name NOT LIKE 'sqlite_%'
  AND NOT EXISTS (
    SELECT 1 FROM e01_506_03_tb r WHERE r.element_name = sm.name
  );

-- ═══════════════════════════════════════════════════════
-- بخش ۵ — trigger جدید: چک قبل از COMMIT در migration بعدی
-- ═══════════════════════════════════════════════════════
-- (trigger روی جدول نمی‌شود چون DDL رویداد است — نیاز به چک دستی)
-- راه‌حل: در هر migration بعدی، اول از v_orphan_gate SELECT کنیم

-- ═══════════════════════════════════════════════════════
-- بخش ۶ — آمار
-- ═══════════════════════════════════════════════════════
SELECT 'after: registry' AS metric, COUNT(*) AS n FROM e01_506_03_tb
UNION ALL
SELECT 'after: matrix', COUNT(*) FROM e01_778_02_tb
UNION ALL
SELECT 'after: policy', COUNT(*) FROM e01_778_05_tb;

INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v113_organic_gate','Registered 5 orphan views + created v_orphan_gate');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- ═══════════════════════════════════════════════════════
-- گزارش نهایی
-- ═══════════════════════════════════════════════════════
SELECT '' AS x;
SELECT '═══ دروازه — orphanهای باقی‌مانده ═══' AS section;
SELECT * FROM v_orphan_gate LIMIT 20;
