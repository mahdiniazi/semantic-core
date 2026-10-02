-- v115 — رفع هر دو نقض Self-check
.mode column
.headers on

BEGIN;

-- ═══════════════════════════════════════════════════════
-- رفع ۱: M_primary_unguarded
-- سیاست اجباری برای e03_320_01_tr→N30
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_778_05_tb 
  (element_name, need_uid, policy_kind, exec_name, rationale, is_mandatory)
VALUES 
  ('e03_320_01_tr', 'N30', 'guard', 'e03_320_01_tr',
   'Delete guard for entity — mandatory policy for primary element', 1);

-- ═══════════════════════════════════════════════════════
-- رفع ۲: M_policy_orphan — همگام‌سازی matrix با policy_bridge
-- هر سیاستی که در matrix نیست، matrix بساز
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_778_02_tb 
  (element_name, need_uid, is_primary, is_driving, role)
SELECT 
  p.element_name, 
  p.need_uid, 
  0, 0, 
  'serves'
FROM e01_778_05_tb p
WHERE NOT EXISTS (
  SELECT 1 FROM e01_778_02_tb m
  WHERE m.element_name = p.element_name 
    AND m.need_uid = p.need_uid
);

-- ═══════════════════════════════════════════════════════
-- لاگ
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v115_fix_self_check','Fixed M_primary_unguarded + synchronized matrix with policy_bridge');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- ═══════════════════════════════════════════════════════
-- گزارش
-- ═══════════════════════════════════════════════════════
SELECT '═══ Self-check بعد از رفع ═══' AS section;
SELECT 
  check_name, 
  has_violation,
  CASE 
    WHEN has_violation = 0 THEN '✅'
    ELSE '❌'
  END AS status
FROM e04_978_01_vw;

SELECT '' AS x;
SELECT '═══ آمار ═══' AS section;
SELECT 'entities' AS k, COUNT(*) AS n FROM e01_200_03_tb
UNION ALL SELECT 'matrix', COUNT(*) FROM e01_778_02_tb
UNION ALL SELECT 'policy', COUNT(*) FROM e01_778_05_tb;
