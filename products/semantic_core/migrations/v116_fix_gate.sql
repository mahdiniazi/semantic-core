.mode column
.headers on

DROP VIEW IF EXISTS v_orphan_gate;

CREATE VIEW v_orphan_gate AS
SELECT 
  CASE sm.type 
    WHEN 'view' THEN 'view_not_in_registry'
    WHEN 'trigger' THEN 'trigger_not_in_registry'
    WHEN 'table' THEN 'table_not_in_registry'
    ELSE 'other_not_in_registry'
  END AS orphan_kind,
  sm.name AS orphan_name
FROM sqlite_master sm
WHERE sm.type IN ('view','trigger','table')
  AND (
    sm.name LIKE 'v_%'
    OR sm.name LIKE 'e01_%'
    OR sm.name LIKE 'e02_%'
    OR sm.name LIKE 'e03_%'
    OR sm.name LIKE 'e04_%'
  )
  AND sm.name NOT LIKE 'sqlite_%'
  AND sm.name NOT LIKE '%_data'
  AND sm.name NOT LIKE '%_idx'
  AND sm.name NOT LIKE '%_docsize'
  AND sm.name NOT LIKE '%_config'
  AND sm.name NOT LIKE '_baseline%'
  AND NOT EXISTS (
    SELECT 1 FROM e01_506_03_tb r 
    WHERE r.element_name = sm.name
  );

SELECT '═══ orphan_kind آمار ═══' AS section;
SELECT orphan_kind, COUNT(*) AS n
FROM v_orphan_gate
GROUP BY orphan_kind
ORDER BY n DESC;

SELECT '' AS x;
SELECT '═══ نمونه orphanها ═══' AS section;
SELECT orphan_kind, orphan_name
FROM v_orphan_gate
LIMIT 20;

SELECT '' AS x;
SELECT '═══ GATE نهایی ═══' AS section;
SELECT 'GATE' AS gate_status, 
  (SELECT COUNT(*) FROM e04_978_01_vw WHERE has_violation=1) AS self_fails,
  (SELECT COUNT(*) FROM v_orphan_gate) AS orphans;
