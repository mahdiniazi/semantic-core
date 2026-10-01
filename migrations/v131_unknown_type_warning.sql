-- v131 — جدول هشدار برای entity بدون قاعده جای‌گذاری
.mode column
.headers on

BEGIN;

-- ═══ جدول انتظار ═══
CREATE TABLE IF NOT EXISTS e01_200_05_tb (
  pending_id INTEGER PRIMARY KEY AUTOINCREMENT,
  ent_uid TEXT NOT NULL,
  type_id INTEGER NOT NULL,
  observed_at TEXT NOT NULL DEFAULT (datetime('now')),
  status TEXT NOT NULL DEFAULT 'pending' 
    CHECK(status IN ('pending','resolved','ignored')),
  note TEXT,
  UNIQUE(ent_uid),
  CONSTRAINT fk_pnd_ent FOREIGN KEY (ent_uid) REFERENCES e01_200_03_tb(ent_uid),
  CONSTRAINT fk_pnd_type FOREIGN KEY (type_id) REFERENCES e01_200_01_tb(type_id)
);

-- ═══ Trigger: entity جدید بدون قاعده → هشدار ═══
DROP TRIGGER IF EXISTS e03_200_05_pending;
CREATE TRIGGER e03_200_05_pending
AFTER INSERT ON e01_200_03_tb
WHEN NEW.nature = 'concept'
  AND NOT EXISTS (
    SELECT 1 FROM e01_200_04_tb r WHERE r.type_id = NEW.type_id
  )
BEGIN
  INSERT OR IGNORE INTO e01_200_05_tb (ent_uid, type_id, note)
  VALUES (
    NEW.ent_uid, 
    NEW.type_id,
    'No placement rule for type ' || (SELECT type_uid FROM e01_200_01_tb WHERE type_id = NEW.type_id)
  );
END;

-- ═══ ثبت ═══
INSERT OR IGNORE INTO e01_506_03_tb 
  (element_name, element_layer, element_kind, element_level, need_uid)
VALUES 
  ('e01_200_05_tb', 'T', 'tb', 1, 'N50'),
  ('e03_200_05_pending', 'T', 'tr', 3, 'N50');

INSERT OR IGNORE INTO e01_778_02_tb (element_name, need_uid, role)
VALUES 
  ('e01_200_05_tb', 'N50', 'serves'),
  ('e03_200_05_pending', 'N50', 'serves');

INSERT OR IGNORE INTO e01_778_05_tb 
  (element_name, need_uid, policy_kind, exec_name, rationale, is_mandatory)
VALUES 
  ('e01_200_05_tb', 'N50', 'audit', 'e01_200_05_tb', 'Pending placement queue', 1),
  ('e03_200_05_pending', 'N50', 'guard', 'e03_200_05_pending', 'Warn when entity has no placement rule', 1);

INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v131_unknown_type_warning','Pending placement queue for unknown types');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- ═══ تست: نوع جدید ═══
INSERT INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id)
VALUES ('test:newtype',
  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Make'),
  'concept', 'تست نوع بدون قاعده', 'test', 2);

SELECT '═══ آیا در pending ثبت شد؟ ═══' AS section;
SELECT p.ent_uid, t.type_uid, p.status, p.note
FROM e01_200_05_tb p
JOIN e01_200_01_tb t ON t.type_id = p.type_id
WHERE p.ent_uid = 'test:newtype';

-- پاک‌سازی
DELETE FROM e01_200_05_tb WHERE ent_uid='test:newtype';
DELETE FROM e01_200_03_tb WHERE ent_uid='test:newtype';
