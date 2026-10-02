-- v122 — گزارش سلامت مستقل و بهینه
-- بدون وابستگی به e04_978_01_vw
.mode column
.headers on

BEGIN;

DROP VIEW IF EXISTS e04_978_01_vw;
DROP VIEW IF EXISTS e04_900_01_vw;

-- ═══════════════════════════════════════════════════════
-- گزارش سلامت مستقل — تنها view سلامت
-- ═══════════════════════════════════════════════════════
CREATE VIEW e04_900_01_vw AS
WITH
  -- ═══ CTE ۱: شمارش‌های پایه (یک بار محاسبه) ═══
  base_counts AS (
    SELECT
      (SELECT COUNT(*) FROM e01_506_01_tb) AS needs_total,
      (SELECT COUNT(DISTINCT need_uid) FROM e01_778_05_tb) AS needs_policy,
      (SELECT COUNT(*) FROM e01_506_02_tb) AS atoms_total,
      (SELECT COUNT(DISTINCT atom_uid) FROM e01_516_01_tb) AS atoms_linked,
      (SELECT COUNT(DISTINCT atom_uid) FROM e01_506_04_tb) AS atoms_traced,
      (SELECT COUNT(*) FROM e01_378_01_tb) AS fk_total,
      (SELECT COUNT(*) FROM e01_778_02_tb) AS matrix_total,
      (SELECT COUNT(*) FROM e01_778_05_tb) AS policy_total,
      (SELECT COUNT(*) FROM sqlite_master WHERE type='trigger' AND name LIKE 'e03%') AS trigger_total,
      (SELECT COUNT(*) FROM e01_200_01_tb) AS etypes_total,
      (SELECT COUNT(DISTINCT type_id) FROM e01_200_03_tb) AS etypes_used,
      (SELECT COUNT(*) FROM e01_202_01_tb) AS rtypes_total,
      (SELECT COUNT(DISTINCT reltype_id) FROM e01_222_01_tb) AS rtypes_used
  ),

  -- ═══ CTE ۲: عناصر ═══
  elements_counts AS (
    SELECT
      COUNT(*) AS total,
      SUM(CASE WHEN EXISTS (SELECT 1 FROM sqlite_master sm WHERE sm.name = e.element_name) THEN 1 ELSE 0 END) AS in_schema,
      SUM(CASE WHEN EXISTS (SELECT 1 FROM e01_778_02_tb m WHERE m.element_name = e.element_name) THEN 1 ELSE 0 END) AS in_matrix
    FROM e01_506_03_tb e
    WHERE e.element_kind IN ('tb','tr','vw','ft')
      AND e.element_name NOT LIKE 'POLICY:%'
  ),

  -- ═══ CTE ۳: اتصال‌های شکسته (نام‌دار) ═══
  violations AS (
    SELECT
      -- نیازهای بدون سیاست
      COALESCE((SELECT GROUP_CONCAT(n.need_uid, ', ')
        FROM e01_506_01_tb n
        WHERE NOT EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.need_uid = n.need_uid)), '—') AS needs_no_policy,

      -- اتم‌های بدون لینک
      COALESCE((SELECT GROUP_CONCAT(a.atom_uid, ', ')
        FROM e01_506_02_tb a
        WHERE NOT EXISTS (SELECT 1 FROM e01_516_01_tb l WHERE l.atom_uid = a.atom_uid)), '—') AS atoms_no_link,

      -- اتم‌های بدون trace
      COALESCE((SELECT GROUP_CONCAT(a.atom_uid, ', ')
        FROM e01_506_02_tb a
        WHERE NOT EXISTS (SELECT 1 FROM e01_506_04_tb t WHERE t.atom_uid = a.atom_uid)), '—') AS atoms_no_trace,

      -- عناصر بدون schema
      COALESCE((SELECT GROUP_CONCAT(e.element_name, ', ')
        FROM e01_506_03_tb e
        WHERE e.element_kind IN ('tb','tr','vw','ft') AND e.element_name NOT LIKE 'POLICY:%'
          AND NOT EXISTS (SELECT 1 FROM sqlite_master sm WHERE sm.name = e.element_name)), '—') AS elems_no_schema,

      -- عناصر بدون matrix
      COALESCE((SELECT GROUP_CONCAT(e.element_name, ', ')
        FROM e01_506_03_tb e
        WHERE e.element_kind IN ('tb','tr','vw','ft') AND e.element_name NOT LIKE 'POLICY:%'
          AND NOT EXISTS (SELECT 1 FROM e01_778_02_tb m WHERE m.element_name = e.element_name)), '—') AS elems_no_matrix,

      -- FK بدون anchor
      COALESCE((SELECT GROUP_CONCAT(f.child_table || '.' || f.child_col, ', ')
        FROM e01_378_01_tb f
        WHERE NOT EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.fk_ref_id = f.ref_id AND p.policy_kind='fk')), '—') AS fks_no_anchor,

      -- triggerهای بدون registry
      COALESCE((SELECT GROUP_CONCAT(sm.name, ', ')
        FROM sqlite_master sm
        WHERE sm.type='trigger' AND sm.name LIKE 'e03%'
          AND NOT EXISTS (SELECT 1 FROM e01_506_03_tb e WHERE e.element_name = sm.name)), '—') AS triggers_no_registry,

      -- triggerهای بدون anchor
      COALESCE((SELECT GROUP_CONCAT(sm.name, ', ')
        FROM sqlite_master sm
        WHERE sm.type='trigger' AND sm.name LIKE 'e03%'
          AND NOT EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.exec_name = sm.name)), '—') AS triggers_no_anchor,

      -- policy بدون matrix
      COALESCE((SELECT GROUP_CONCAT(p.element_name || '→' || p.need_uid, ', ')
        FROM e01_778_05_tb p
        WHERE NOT EXISTS (SELECT 1 FROM e01_778_02_tb m 
          WHERE m.element_name = p.element_name AND m.need_uid = p.need_uid)), '—') AS policies_no_matrix,

      -- primary بدون سیاست
      COALESCE((SELECT GROUP_CONCAT(m.element_name || '→' || m.need_uid, ', ')
        FROM e01_778_02_tb m
        WHERE m.is_primary = 1
          AND NOT EXISTS (SELECT 1 FROM e01_778_05_tb p
            WHERE p.element_name = m.element_name
              AND p.need_uid = m.need_uid
              AND p.is_mandatory = 1)), '—') AS primary_no_policy,

      -- matrix بدون need
      COALESCE((SELECT GROUP_CONCAT(m.element_name || '→' || m.need_uid, ', ')
        FROM e01_778_02_tb m
        WHERE NOT EXISTS (SELECT 1 FROM e01_506_01_tb n WHERE n.need_uid = m.need_uid)), '—') AS matrix_no_need,

      -- entity types بدون instance
      COALESCE((SELECT GROUP_CONCAT(t.type_uid, ', ')
        FROM e01_200_01_tb t
        WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb e WHERE e.type_id = t.type_id)), '—') AS etypes_no_instance,

      -- relation types بدون relation
      COALESCE((SELECT GROUP_CONCAT(t.type_uid, ', ')
        FROM e01_202_01_tb t
        WHERE NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.reltype_id = t.reltype_id)), '—') AS rtypes_no_relation
  ),

  -- ═══ CTE ۴: چک‌های T/C از viewهای سرویس ═══
  semantic_checks AS (
    SELECT
      (SELECT COUNT(*) FROM e04_110_02_vw) AS t_violations,
      (SELECT COUNT(*) FROM e04_310_02_vw) AS c_orphans,
      COALESCE((SELECT GROUP_CONCAT(violation_kind || ':' || CAST(object_id AS TEXT), ', ') 
        FROM e04_110_02_vw), '—') AS t_items,
      COALESCE((SELECT GROUP_CONCAT(violation_kind || ':' || uid, ', ') 
        FROM e04_310_02_vw), '—') AS c_items
  )

-- ═══════════════════════════════════════════════════════
-- ردیف‌های گزارش (۲۱ ردیف)
-- ═══════════════════════════════════════════════════════
SELECT 'self_check' AS category, 'M_fk' AS domain,
  (SELECT COUNT(*) FROM e01_378_01_tb f
    WHERE NOT EXISTS (SELECT 1 FROM e01_778_05_tb p 
      WHERE p.fk_ref_id = f.ref_id AND p.policy_kind='fk')) AS issues,
  CASE WHEN (SELECT COUNT(*) FROM e01_378_01_tb f
    WHERE NOT EXISTS (SELECT 1 FROM e01_778_05_tb p 
      WHERE p.fk_ref_id = f.ref_id AND p.policy_kind='fk')) = 0 
    THEN 100.0 ELSE 0.0 END AS coverage_pct,
  v.fks_no_anchor AS details,
  CASE WHEN (SELECT COUNT(*) FROM e01_378_01_tb f
    WHERE NOT EXISTS (SELECT 1 FROM e01_778_05_tb p 
      WHERE p.fk_ref_id = f.ref_id AND p.policy_kind='fk')) = 0 
    THEN 'healthy' ELSE 'critical' END AS status
FROM violations v

UNION ALL SELECT 'self_check', 'T_semantic',
  sc.t_violations,
  CASE WHEN sc.t_violations = 0 THEN 100.0 ELSE 0.0 END,
  sc.t_items,
  CASE WHEN sc.t_violations = 0 THEN 'healthy' ELSE 'critical' END
FROM semantic_checks sc

UNION ALL SELECT 'self_check', 'C_orphan',
  sc.c_orphans,
  CASE WHEN sc.c_orphans = 0 THEN 100.0 ELSE 0.0 END,
  sc.c_items,
  CASE WHEN sc.c_orphans = 0 THEN 'healthy' ELSE 'critical' END
FROM semantic_checks sc

UNION ALL SELECT 'self_check', 'M_primary_unguarded',
  (SELECT COUNT(*) FROM e01_778_02_tb m
    WHERE m.is_primary = 1
      AND NOT EXISTS (SELECT 1 FROM e01_778_05_tb p
        WHERE p.element_name = m.element_name
          AND p.need_uid = m.need_uid
          AND p.is_mandatory = 1)),
  CASE WHEN (SELECT COUNT(*) FROM e01_778_02_tb m
    WHERE m.is_primary = 1
      AND NOT EXISTS (SELECT 1 FROM e01_778_05_tb p
        WHERE p.element_name = m.element_name
          AND p.need_uid = m.need_uid
          AND p.is_mandatory = 1)) = 0 
    THEN 100.0 ELSE 0.0 END,
  v.primary_no_policy,
  CASE WHEN (SELECT COUNT(*) FROM e01_778_02_tb m
    WHERE m.is_primary = 1
      AND NOT EXISTS (SELECT 1 FROM e01_778_05_tb p
        WHERE p.element_name = m.element_name
          AND p.need_uid = m.need_uid
          AND p.is_mandatory = 1)) = 0 
    THEN 'healthy' ELSE 'critical' END
FROM violations v

UNION ALL SELECT 'self_check', 'M_fk_unanchored',
  (SELECT COUNT(*) FROM e01_378_01_tb f
    WHERE NOT EXISTS (SELECT 1 FROM e01_778_05_tb p 
      WHERE p.fk_ref_id = f.ref_id AND p.policy_kind='fk')),
  CASE WHEN (SELECT COUNT(*) FROM e01_378_01_tb f
    WHERE NOT EXISTS (SELECT 1 FROM e01_778_05_tb p 
      WHERE p.fk_ref_id = f.ref_id AND p.policy_kind='fk')) = 0 
    THEN 100.0 ELSE 0.0 END,
  v.fks_no_anchor,
  CASE WHEN (SELECT COUNT(*) FROM e01_378_01_tb f
    WHERE NOT EXISTS (SELECT 1 FROM e01_778_05_tb p 
      WHERE p.fk_ref_id = f.ref_id AND p.policy_kind='fk')) = 0 
    THEN 'healthy' ELSE 'critical' END
FROM violations v

UNION ALL SELECT 'self_check', 'M_trigger_unanchored',
  (SELECT COUNT(*) FROM sqlite_master sm
    WHERE sm.type='trigger' AND sm.name LIKE 'e03%'
      AND NOT EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.exec_name = sm.name)),
  CASE WHEN (SELECT COUNT(*) FROM sqlite_master sm
    WHERE sm.type='trigger' AND sm.name LIKE 'e03%'
      AND NOT EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.exec_name = sm.name)) = 0 
    THEN 100.0 ELSE 0.0 END,
  v.triggers_no_anchor,
  CASE WHEN (SELECT COUNT(*) FROM sqlite_master sm
    WHERE sm.type='trigger' AND sm.name LIKE 'e03%'
      AND NOT EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.exec_name = sm.name)) = 0 
    THEN 'healthy' ELSE 'critical' END
FROM violations v

UNION ALL SELECT 'self_check', 'M_policy_orphan',
  (SELECT COUNT(*) FROM e01_778_05_tb p
    WHERE NOT EXISTS (SELECT 1 FROM e01_778_02_tb m
      WHERE m.element_name = p.element_name AND m.need_uid = p.need_uid)),
  CASE WHEN (SELECT COUNT(*) FROM e01_778_05_tb p
    WHERE NOT EXISTS (SELECT 1 FROM e01_778_02_tb m
      WHERE m.element_name = p.element_name AND m.need_uid = p.need_uid)) = 0 
    THEN 100.0 ELSE 0.0 END,
  v.policies_no_matrix,
  CASE WHEN (SELECT COUNT(*) FROM e01_778_05_tb p
    WHERE NOT EXISTS (SELECT 1 FROM e01_778_02_tb m
      WHERE m.element_name = p.element_name AND m.need_uid = p.need_uid)) = 0 
    THEN 'healthy' ELSE 'critical' END
FROM violations v

UNION ALL SELECT 'self_check', 'M_ver',
  CASE WHEN (SELECT schema_ver FROM e01_676_02_tb WHERE id=1) >= 32 THEN 0 ELSE 1 END,
  CASE WHEN (SELECT schema_ver FROM e01_676_02_tb WHERE id=1) >= 32 THEN 100.0 ELSE 0.0 END,
  'ver=' || CAST((SELECT schema_ver FROM e01_676_02_tb WHERE id=1) AS TEXT),
  CASE WHEN (SELECT schema_ver FROM e01_676_02_tb WHERE id=1) >= 32 THEN 'healthy' ELSE 'critical' END

UNION ALL SELECT 'self_check', 'M_policy_count',
  CASE WHEN (SELECT COUNT(*) FROM e01_778_05_tb) >= 170 THEN 0 ELSE 1 END,
  CASE WHEN (SELECT COUNT(*) FROM e01_778_05_tb) >= 170 THEN 100.0 ELSE 0.0 END,
  'count=' || CAST((SELECT COUNT(*) FROM e01_778_05_tb) AS TEXT),
  CASE WHEN (SELECT COUNT(*) FROM e01_778_05_tb) >= 170 THEN 'healthy' ELSE 'critical' END

-- ═══ coverage ═══
UNION ALL SELECT 'coverage', 'needs_to_policy',
  bc.needs_total - bc.needs_policy,
  ROUND(100.0 * bc.needs_policy / NULLIF(bc.needs_total, 0), 1),
  'missing: ' || v.needs_no_policy,
  CASE WHEN bc.needs_policy >= bc.needs_total THEN 'healthy' ELSE 'watch' END
FROM base_counts bc, violations v

UNION ALL SELECT 'coverage', 'atoms_to_link',
  bc.atoms_total - bc.atoms_linked,
  ROUND(100.0 * bc.atoms_linked / NULLIF(bc.atoms_total, 0), 1),
  'missing: ' || v.atoms_no_link,
  CASE WHEN bc.atoms_linked >= bc.atoms_total THEN 'healthy' ELSE 'watch' END
FROM base_counts bc, violations v

UNION ALL SELECT 'coverage', 'atoms_to_trace',
  bc.atoms_total - bc.atoms_traced,
  ROUND(100.0 * bc.atoms_traced / NULLIF(bc.atoms_total, 0), 1),
  'missing: ' || v.atoms_no_trace,
  CASE WHEN bc.atoms_traced >= bc.atoms_total THEN 'healthy' ELSE 'watch' END
FROM base_counts bc, violations v

UNION ALL SELECT 'coverage', 'elements_to_schema',
  ec.total - ec.in_schema,
  ROUND(100.0 * ec.in_schema / NULLIF(ec.total, 0), 1),
  'missing: ' || v.elems_no_schema,
  CASE WHEN ec.in_schema >= ec.total THEN 'healthy' ELSE 'watch' END
FROM elements_counts ec, violations v

UNION ALL SELECT 'coverage', 'elements_to_matrix',
  ec.total - ec.in_matrix,
  ROUND(100.0 * ec.in_matrix / NULLIF(ec.total, 0), 1),
  'missing: ' || v.elems_no_matrix,
  CASE WHEN ec.in_matrix >= ec.total THEN 'healthy' ELSE 'watch' END
FROM elements_counts ec, violations v

UNION ALL SELECT 'coverage', 'fk_to_anchor',
  bc.fk_total - (SELECT COUNT(*) FROM e01_378_01_tb f 
    WHERE EXISTS (SELECT 1 FROM e01_778_05_tb p 
      WHERE p.fk_ref_id = f.ref_id AND p.policy_kind='fk')),
  ROUND(100.0 * (SELECT COUNT(*) FROM e01_378_01_tb f 
    WHERE EXISTS (SELECT 1 FROM e01_778_05_tb p 
      WHERE p.fk_ref_id = f.ref_id AND p.policy_kind='fk')) / NULLIF(bc.fk_total, 0), 1),
  'missing: ' || v.fks_no_anchor,
  CASE WHEN (SELECT COUNT(*) FROM e01_378_01_tb f 
    WHERE EXISTS (SELECT 1 FROM e01_778_05_tb p 
      WHERE p.fk_ref_id = f.ref_id AND p.policy_kind='fk')) >= bc.fk_total 
    THEN 'healthy' ELSE 'watch' END
FROM base_counts bc, violations v

UNION ALL SELECT 'coverage', 'matrix_to_needs',
  bc.matrix_total - (SELECT COUNT(*) FROM e01_778_02_tb m 
    WHERE EXISTS (SELECT 1 FROM e01_506_01_tb n WHERE n.need_uid = m.need_uid)),
  ROUND(100.0 * (SELECT COUNT(*) FROM e01_778_02_tb m 
    WHERE EXISTS (SELECT 1 FROM e01_506_01_tb n WHERE n.need_uid = m.need_uid)) 
    / NULLIF(bc.matrix_total, 0), 1),
  'missing: ' || v.matrix_no_need,
  CASE WHEN (SELECT COUNT(*) FROM e01_778_02_tb m 
    WHERE EXISTS (SELECT 1 FROM e01_506_01_tb n WHERE n.need_uid = m.need_uid)) >= bc.matrix_total 
    THEN 'healthy' ELSE 'watch' END
FROM base_counts bc, violations v

UNION ALL SELECT 'coverage', 'policies_to_elements',
  bc.policy_total - (SELECT COUNT(*) FROM e01_778_05_tb p 
    WHERE EXISTS (SELECT 1 FROM e01_506_03_tb e WHERE e.element_name = p.element_name)),
  ROUND(100.0 * (SELECT COUNT(*) FROM e01_778_05_tb p 
    WHERE EXISTS (SELECT 1 FROM e01_506_03_tb e WHERE e.element_name = p.element_name)) 
    / NULLIF(bc.policy_total, 0), 1),
  '—',
  CASE WHEN (SELECT COUNT(*) FROM e01_778_05_tb p 
    WHERE EXISTS (SELECT 1 FROM e01_506_03_tb e WHERE e.element_name = p.element_name)) >= bc.policy_total 
    THEN 'healthy' ELSE 'watch' END
FROM base_counts bc

UNION ALL SELECT 'coverage', 'triggers_to_registry',
  bc.trigger_total - (SELECT COUNT(*) FROM sqlite_master sm 
    WHERE sm.type='trigger' AND sm.name LIKE 'e03%'
      AND EXISTS (SELECT 1 FROM e01_506_03_tb e WHERE e.element_name = sm.name)),
  ROUND(100.0 * (SELECT COUNT(*) FROM sqlite_master sm 
    WHERE sm.type='trigger' AND sm.name LIKE 'e03%'
      AND EXISTS (SELECT 1 FROM e01_506_03_tb e WHERE e.element_name = sm.name)) 
    / NULLIF(bc.trigger_total, 0), 1),
  'missing: ' || v.triggers_no_registry,
  CASE WHEN (SELECT COUNT(*) FROM sqlite_master sm 
    WHERE sm.type='trigger' AND sm.name LIKE 'e03%'
      AND EXISTS (SELECT 1 FROM e01_506_03_tb e WHERE e.element_name = sm.name)) >= bc.trigger_total 
    THEN 'healthy' ELSE 'watch' END
FROM base_counts bc, violations v

UNION ALL SELECT 'coverage', 'triggers_to_anchor',
  bc.trigger_total - (SELECT COUNT(*) FROM sqlite_master sm 
    WHERE sm.type='trigger' AND sm.name LIKE 'e03%'
      AND EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.exec_name = sm.name)),
  ROUND(100.0 * (SELECT COUNT(*) FROM sqlite_master sm 
    WHERE sm.type='trigger' AND sm.name LIKE 'e03%'
      AND EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.exec_name = sm.name)) 
    / NULLIF(bc.trigger_total, 0), 1),
  'missing: ' || v.triggers_no_anchor,
  CASE WHEN (SELECT COUNT(*) FROM sqlite_master sm 
    WHERE sm.type='trigger' AND sm.name LIKE 'e03%'
      AND EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.exec_name = sm.name)) >= bc.trigger_total 
    THEN 'healthy' ELSE 'watch' END
FROM base_counts bc, violations v

UNION ALL SELECT 'coverage', 'entity_types_to_instances',
  bc.etypes_total - bc.etypes_used,
  ROUND(100.0 * bc.etypes_used / NULLIF(bc.etypes_total, 0), 1),
  'missing: ' || v.etypes_no_instance,
  CASE WHEN bc.etypes_used >= bc.etypes_total THEN 'healthy' ELSE 'info' END
FROM base_counts bc, violations v

UNION ALL SELECT 'coverage', 'relation_types_to_relations',
  bc.rtypes_total - bc.rtypes_used,
  ROUND(100.0 * bc.rtypes_used / NULLIF(bc.rtypes_total, 0), 1),
  'missing: ' || v.rtypes_no_relation,
  CASE WHEN bc.rtypes_used >= bc.rtypes_total THEN 'healthy' ELSE 'info' END
FROM base_counts bc, violations v;

INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v122_standalone_health','Standalone health view: no dep on e04_978_01_vw, optimized with CTEs');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- ═══ گزارش ═══
SELECT '═══ گزارش سلامت مستقل ═══' AS section;
SELECT category, domain, issues, coverage_pct, status
FROM e04_900_01_vw
ORDER BY 
  CASE status WHEN 'critical' THEN 1 WHEN 'watch' THEN 2 
              WHEN 'healthy' THEN 3 ELSE 4 END,
  category, domain;

SELECT '' AS x;
SELECT '═══ آمار ═══' AS section;
SELECT status, COUNT(*) AS n FROM e04_900_01_vw GROUP BY status;
