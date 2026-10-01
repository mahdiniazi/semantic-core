-- Auto-add policy for every primary element that lacks one
INSERT OR IGNORE INTO e01_778_05_tb (element_name, need_uid, policy_kind, exec_name, rationale, is_mandatory)
SELECT m.element_name, m.need_uid,
       CASE
         WHEN m.element_name LIKE 'e03%_tr' THEN 'guard'
         WHEN m.element_name LIKE 'e04%_vw' THEN 'audit'
         WHEN m.element_name LIKE 'e02%_ft' THEN 'sync'
         WHEN m.element_name LIKE 'e01%_tb' THEN 'guard'
         ELSE 'guard'
       END,
       m.element_name,
       'Auto-anchor primary element ' || m.element_name,
       1
FROM e01_778_02_tb m
WHERE m.is_primary = 1
  AND NOT EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.element_name = m.element_name AND p.need_uid = m.need_uid);
