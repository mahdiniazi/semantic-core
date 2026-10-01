-- v118 — تشخیص علت دو watch
.mode column
.headers on

-- ═══ ۱. وضعیت داشبورد ═══
SELECT '═══ داشبورد ═══' AS section;
SELECT domain, declared, realized, coverage_pct, missing, orphan, status
FROM e04_900_01_vw
WHERE status IN ('watch','critical');

SELECT '' AS x;

-- ═══ ۲. عناصری که در matrix نیستند ═══
SELECT '═══ elements_without_matrix ═══' AS section;
SELECT e.element_name, e.element_kind, e.element_layer
FROM e01_506_03_tb e
WHERE e.element_name NOT LIKE 'POLICY:%'
  AND e.element_kind IN ('tb','tr','vw','ft')
  AND NOT EXISTS (
    SELECT 1 FROM e01_778_02_tb m WHERE m.element_name = e.element_name
  )
ORDER BY e.element_name;

SELECT '' AS x;

-- ═══ ۳. عناصری که در schema نیستند (orphan) ═══
SELECT '═══ schema_orphans (e0*) ═══' AS section;
SELECT sm.type, sm.name
FROM sqlite_master sm
WHERE sm.type IN ('table','trigger','view')
  AND sm.name LIKE 'e0%'
  AND sm.name NOT LIKE '%_data'
  AND sm.name NOT LIKE '%_idx'
  AND sm.name NOT LIKE '%_docsize'
  AND sm.name NOT LIKE '%_config'
  AND NOT EXISTS (
    SELECT 1 FROM e01_506_03_tb r WHERE r.element_name = sm.name
  )
ORDER BY sm.name;

SELECT '' AS x;

-- ═══ ۴. عناصری که در registry هستند ولی در schema نیستند ═══
SELECT '═══ registry_ghosts ═══' AS section;
SELECT e.element_name, e.element_kind, e.element_layer
FROM e01_506_03_tb e
WHERE e.element_name LIKE 'e0%'
  AND e.element_kind IN ('tb','tr','vw','ft')
  AND NOT EXISTS (
    SELECT 1 FROM sqlite_master sm WHERE sm.name = e.element_name
  )
ORDER BY e.element_name;
