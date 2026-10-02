-- v88 — مدل چهار-رابطه‌ای: فیزیکی، مستقیم، نوع-به-نوع، کارکردی
.mode column
.headers on

BEGIN;

-- ═══════════════════════════════════════════════════════
-- ۱. اصلاح خواص has_part و part_of (گذرا شوند)
-- ═══════════════════════════════════════════════════════
UPDATE e01_202_01_tb SET is_transitive=1 WHERE type_uid='has_part';
UPDATE e01_202_01_tb SET is_transitive=1 WHERE type_uid='part_of';

-- ═══════════════════════════════════════════════════════
-- ۲. افزودن has_direct_part + part_of_directly
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_202_01_tb
  (type_uid, label, description, object_kind, is_symmetric, is_transitive, is_functional, inverse_uid)
VALUES
  ('has_direct_part','دارد بخش مستقیم','بخش بلافاصله — بدون واسطه','entity',0,0,0,'part_of_directly'),
  ('part_of_directly','بخشی از (مستقیم)','بخش بلافاصله — بدون واسطه','entity',0,0,0,'has_direct_part');

-- ═══════════════════════════════════════════════════════
-- ۳. افزودن plays_role_in (کارکردی)
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_202_01_tb
  (type_uid, label, description, object_kind, is_symmetric, is_transitive, is_functional, inverse_uid)
VALUES
  ('plays_role_in','نقش دارد در','رابطه کارکردی — نه فیزیکی','entity',0,0,0,NULL);

-- ═══════════════════════════════════════════════════════
-- ۴. افزودن inherent_to (نوع-به-نوع)
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_202_01_tb
  (type_uid, label, description, object_kind, is_symmetric, is_transitive, is_functional, inverse_uid)
VALUES
  ('inherent_to','ذاتاً دارد','رابطه نوع-به-نوع (universal)','entity',0,1,0,NULL);

-- ═══════════════════════════════════════════════════════
-- ۵. قواعد چیزسازی
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_202_02_tb (reltype_id, reify_rule, category, reason)
SELECT rt.reltype_id, p.rule, 'structural', p.reason
FROM (
  SELECT 'has_direct_part' AS rt_uid, 'never' AS rule, 'ساختار مستقیم — بدون داده' AS reason
  UNION ALL SELECT 'part_of_directly', 'never', 'ساختار مستقیم — بدون داده'
  UNION ALL SELECT 'inherent_to', 'never', 'رابطه نوع-به-نوع — بدون داده'
  UNION ALL SELECT 'plays_role_in', 'when_data', 'نقش کارکردی — چیزسازی اگر شرایط دارد'
) p
JOIN e01_202_01_tb rt ON rt.type_uid = p.rt_uid;

-- ═══════════════════════════════════════════════════════
-- ۶. لاگ
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v88_relationship_model','4-relation model: part_of, part_of_directly, inherent_to, plays_role_in');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- ═══════════════════════════════════════════════════════
-- گزارش
-- ═══════════════════════════════════════════════════════
SELECT '=== مدل نهایی روابط ساختاری/کارکردی ===' AS section;
SELECT 
  type_uid,
  label,
  is_transitive AS trans,
  COALESCE(inverse_uid,'—') AS inverse
FROM e01_202_01_tb
WHERE type_uid IN (
  'has_part','part_of',
  'has_direct_part','part_of_directly',
  'inherent_to','plays_role_in'
)
ORDER BY type_uid;

SELECT '=== شمارش کل reltypes ===' AS section;
SELECT COUNT(*) AS n FROM e01_202_01_tb;
