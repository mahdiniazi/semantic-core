-- Relax gap10: element has any mandatory policy
DROP VIEW IF EXISTS e04_778_10_vw;
CREATE VIEW e04_778_10_vw AS
SELECT m.element_name, m.need_uid, m.role, m.is_primary, m.is_driving,
       'no_mandatory_policy' AS gap_kind
FROM e01_778_02_tb m
WHERE m.is_primary = 1
  AND NOT EXISTS (
      SELECT 1 FROM e01_778_05_tb p
      WHERE p.element_name = m.element_name
        AND p.is_mandatory = 1);

-- Auto-generate matrix rows for orphan policies
INSERT OR IGNORE INTO e01_778_02_tb (element_name, need_uid, is_primary, is_driving, role)
SELECT DISTINCT p.element_name, p.need_uid, 0, 0, 'serves'
FROM e01_778_05_tb p
WHERE NOT EXISTS (
    SELECT 1 FROM e01_778_02_tb m
    WHERE m.element_name = p.element_name
      AND m.need_uid = p.need_uid);
