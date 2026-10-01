-- v135 — رفع anchor تریگرهای cache (3 critical)
.mode column
.headers on

BEGIN;

INSERT OR IGNORE INTO e01_778_05_tb
  (element_name, need_uid, policy_kind, exec_name, rationale, is_mandatory)
VALUES
  ('e03_506_12_ai_tr', 'N70', 'guard', 'e03_506_12_ai_tr',
   'Cache insert sync (materialized need tree)', 1),
  ('e03_506_12_au_tr', 'N70', 'guard', 'e03_506_12_au_tr',
   'Cache update sync (materialized need tree)', 1),
  ('e03_506_12_ad_tr', 'N70', 'guard', 'e03_506_12_ad_tr',
   'Cache delete sync (materialized need tree)', 1);

INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v135_fix_policy_anchors',
        'Fixed: anchored 3 cache triggers to N70 policy');

UPDATE e01_676_02_tb
SET schema_ver = schema_ver + 1
WHERE id = 1;

COMMIT;

SELECT '=== health ===' AS section;
SELECT severity, COUNT(*) AS n FROM e04_900_02_vw GROUP BY severity;

SELECT '=== critical (اگر خالی باشد = موفق) ===' AS section;
SELECT kind, item, issue FROM e04_900_02_vw WHERE severity='critical';
