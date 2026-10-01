-- v114 — اصلاح e04_978_01_vw با ستون نام‌دار
.mode column
.headers on

BEGIN;

DROP VIEW IF EXISTS e04_978_01_vw;

CREATE VIEW e04_978_01_vw AS

-- ═══ ۱. M_fk — همه FKها anchor دارند ═══
SELECT 
  'M_fk' AS check_name,
  CASE WHEN (
    SELECT COUNT(*) FROM e01_378_01_tb f
    WHERE NOT EXISTS (
      SELECT 1 FROM e01_778_05_tb p 
      WHERE p.fk_ref_id = f.ref_id AND p.policy_kind='fk'
    )
  ) > 0 THEN 1 ELSE 0 END AS has_violation,
  COALESCE(
    (SELECT GROUP_CONCAT(f.child_table || '.' || f.child_col, ', ')
     FROM e01_378_01_tb f
     WHERE NOT EXISTS (
       SELECT 1 FROM e01_778_05_tb p 
       WHERE p.fk_ref_id = f.ref_id AND p.policy_kind='fk'
     )),
    '—'
  ) AS violating_entities,
  'healthy' AS expectation

UNION ALL

-- ═══ ۲. T_semantic — هیچ نقض نوع ═══
SELECT 
  'T_semantic',
  CASE WHEN EXISTS(SELECT 1 FROM e04_110_02_vw) THEN 1 ELSE 0 END,
  COALESCE(
    (SELECT GROUP_CONCAT(violation_kind || ':' || CAST(object_id AS TEXT), ', ')
     FROM e04_110_02_vw),
    '—'
  ),
  'healthy'

UNION ALL

-- ═══ ۳. C_orphan — هیچ یتیم Core ═══
SELECT 
  'C_orphan',
  CASE WHEN EXISTS(SELECT 1 FROM e04_310_02_vw) THEN 1 ELSE 0 END,
  COALESCE(
    (SELECT GROUP_CONCAT(violation_kind || ':' || uid, ', ')
     FROM e04_310_02_vw),
    '—'
  ),
  'healthy'

UNION ALL

-- ═══ ۴. M_primary_unguarded — هر primary سیاست دارد ═══
SELECT 
  'M_primary_unguarded',
  CASE WHEN (
    SELECT COUNT(*) FROM e01_778_02_tb m
    WHERE m.is_primary = 1
      AND NOT EXISTS (
        SELECT 1 FROM e01_778_05_tb p
        WHERE p.element_name = m.element_name
          AND p.need_uid = m.need_uid
          AND p.is_mandatory = 1
      )
  ) > 0 THEN 1 ELSE 0 END,
  COALESCE(
    (SELECT GROUP_CONCAT(m.element_name || '→' || m.need_uid, ', ')
     FROM e01_778_02_tb m
     WHERE m.is_primary = 1
       AND NOT EXISTS (
         SELECT 1 FROM e01_778_05_tb p
         WHERE p.element_name = m.element_name
           AND p.need_uid = m.need_uid
           AND p.is_mandatory = 1
       )),
    '—'
  ),
  'healthy'

UNION ALL

-- ═══ ۵. M_fk_unanchored — همه FK در catalog anchor دارند ═══
SELECT 
  'M_fk_unanchored',
  CASE WHEN (
    SELECT COUNT(*) FROM e01_378_01_tb f
    WHERE NOT EXISTS (
      SELECT 1 FROM e01_778_05_tb p
      WHERE p.fk_ref_id = f.ref_id AND p.policy_kind='fk'
    )
  ) > 0 THEN 1 ELSE 0 END,
  COALESCE(
    (SELECT GROUP_CONCAT(child_table || '.' || child_col, ', ')
     FROM e01_378_01_tb f
     WHERE NOT EXISTS (
       SELECT 1 FROM e01_778_05_tb p
       WHERE p.fk_ref_id = f.ref_id AND p.policy_kind='fk'
     )),
    '—'
  ),
  'healthy'

UNION ALL

-- ═══ ۶. M_trigger_unanchored — همه trigger anchor دارند ═══
SELECT 
  'M_trigger_unanchored',
  CASE WHEN (
    SELECT COUNT(*) FROM sqlite_master sm
    WHERE sm.type='trigger' AND sm.name LIKE 'e03\_%' ESCAPE '\'
      AND sm.name NOT LIKE 'e03\_778\_%' ESCAPE '\'
      AND NOT EXISTS (
        SELECT 1 FROM e01_778_05_tb p WHERE p.exec_name = sm.name
      )
  ) > 0 THEN 1 ELSE 0 END,
  COALESCE(
    (SELECT GROUP_CONCAT(sm.name, ', ')
     FROM sqlite_master sm
     WHERE sm.type='trigger' AND sm.name LIKE 'e03\_%' ESCAPE '\'
       AND sm.name NOT LIKE 'e03\_778\_%' ESCAPE '\'
       AND NOT EXISTS (
         SELECT 1 FROM e01_778_05_tb p WHERE p.exec_name = sm.name
       )),
    '—'
  ),
  'healthy'

UNION ALL

-- ═══ ۷. M_policy_orphan — هیچ سیاست بدون matrix ═══
SELECT 
  'M_policy_orphan',
  CASE WHEN (
    SELECT COUNT(*) FROM e01_778_05_tb p
    WHERE NOT EXISTS (
      SELECT 1 FROM e01_778_02_tb m
      WHERE m.element_name = p.element_name AND m.need_uid = p.need_uid
    )
  ) > 0 THEN 1 ELSE 0 END,
  COALESCE(
    (SELECT GROUP_CONCAT(p.element_name || '→' || p.need_uid, ', ')
     FROM e01_778_05_tb p
     WHERE NOT EXISTS (
       SELECT 1 FROM e01_778_02_tb m
       WHERE m.element_name = p.element_name AND m.need_uid = p.need_uid
     )),
    '—'
  ),
  'healthy'

UNION ALL

-- ═══ ۸. M_ver — نسخه ≥ ۳۲ ═══
SELECT 
  'M_ver',
  CASE WHEN (SELECT schema_ver FROM e01_676_02_tb WHERE id=1) >= 32 
       THEN 0 ELSE 1 END,
  'ver=' || CAST((SELECT schema_ver FROM e01_676_02_tb WHERE id=1) AS TEXT),
  'ver>=32'

UNION ALL

-- ═══ ۹. M_policy_count — حداقل ۱۷۰ سیاست ═══
SELECT 
  'M_policy_count',
  CASE WHEN (SELECT COUNT(*) FROM e01_778_05_tb) >= 170 
       THEN 0 ELSE 1 END,
  'count=' || CAST((SELECT COUNT(*) FROM e01_778_05_tb) AS TEXT),
  'count>=170';

INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v114_fix_health_view','Added violating_entities names to e04_978_01_vw');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- ═══ گزارش ═══
SELECT '═══ Self-check جدید با نام‌ها ═══' AS section;
SELECT * FROM e04_978_01_vw;
