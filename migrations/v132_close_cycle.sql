-- v132 — تکمیل چرخه ارگانیک
.mode column
.headers on

BEGIN;

-- ═══════════════════════════════════════════════════════
-- Trigger: وقتی قاعده‌ی جدید اضافه شد، pendingها را resolve کن
-- ═══════════════════════════════════════════════════════
DROP TRIGGER IF EXISTS e03_200_04_resolve_pending;
CREATE TRIGGER e03_200_04_resolve_pending
AFTER INSERT ON e01_200_04_tb
WHEN NEW.is_default = 1
BEGIN
  -- گام ۱: رابطه را برای همه pendingهای این نوع بساز
  INSERT OR IGNORE INTO e01_222_01_tb 
    (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
  SELECT 
    'r:auto-' || REPLACE(p.ent_uid, ':', '-') || '-' || REPLACE(NEW.target_uid, ':', '-'),
    (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid = NEW.placement_kind),
    (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid = NEW.target_uid),
    (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid = p.ent_uid),
    'asserted',
    2
  FROM e01_200_05_tb p
  WHERE p.type_id = NEW.type_id
    AND p.status = 'pending';

  -- گام ۲: pendingها را resolved کن
  UPDATE e01_200_05_tb
  SET status = 'resolved',
      note = COALESCE(note, '') || ' | resolved by rule ' || CAST(NEW.rule_id AS TEXT)
  WHERE type_id = NEW.type_id
    AND status = 'pending';
END;

-- ═══════════════════════════════════════════════════════
-- ثبت trigger
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_506_03_tb 
  (element_name, element_layer, element_kind, element_level, need_uid)
VALUES 
  ('e03_200_04_resolve_pending', 'T', 'tr', 3, 'N50');

INSERT OR IGNORE INTO e01_778_02_tb (element_name, need_uid, role)
VALUES 
  ('e03_200_04_resolve_pending', 'N50', 'serves');

INSERT OR IGNORE INTO e01_778_05_tb 
  (element_name, need_uid, policy_kind, exec_name, rationale, is_mandatory)
VALUES 
  ('e03_200_04_resolve_pending', 'N50', 'guard', 'e03_200_04_resolve_pending',
   'Auto-resolve pending entities when placement rule is added', 1);

INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v132_close_cycle','Trigger to resolve pending entities when rule added');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- ═══════════════════════════════════════════════════════
-- تست کامل چرخه
-- ═══════════════════════════════════════════════════════

-- گام ۱: entity از نوع ناشناخته
INSERT INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id)
VALUES ('test:cycle-entity',
  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Make'),
  'concept', 'تست چرخه', 'test', 2);

SELECT '═══ گام ۱: بعد از ساخت entity ═══' AS section;
SELECT p.ent_uid, t.type_uid, p.status
FROM e01_200_05_tb p
JOIN e01_200_01_tb t ON t.type_id = p.type_id
WHERE p.ent_uid = 'test:cycle-entity';

-- گام ۲: کاربر قاعده اضافه می‌کند
INSERT INTO e01_200_04_tb (type_id, target_uid, placement_kind, note)
VALUES (
  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Make'),
  'concept:body-domain',
  'may_have_direct_part',
  'User-defined rule: Make goes to body-domain'
);

SELECT '' AS x;
SELECT '═══ گام ۲: بعد از اضافه قاعده ═══' AS section;

SELECT '--- pending ---' AS sub;
SELECT p.ent_uid, t.type_uid, p.status
FROM e01_200_05_tb p
JOIN e01_200_01_tb t ON t.type_id = p.type_id
WHERE p.ent_uid = 'test:cycle-entity';

SELECT '--- relation ---' AS sub;
SELECT subj.label AS parent, obj.label AS entity, rt.type_uid AS kind
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id
JOIN e01_200_03_tb subj ON subj.ent_id = r.subj_ent_id
JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
WHERE obj.ent_uid = 'test:cycle-entity';

-- پاک‌سازی
DELETE FROM e01_222_01_tb WHERE obj_ent_id = (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='test:cycle-entity');
DELETE FROM e01_200_05_tb WHERE ent_uid='test:cycle-entity';
DELETE FROM e01_200_03_tb WHERE ent_uid='test:cycle-entity';
DELETE FROM e01_200_04_tb WHERE note LIKE 'User-defined rule%';
