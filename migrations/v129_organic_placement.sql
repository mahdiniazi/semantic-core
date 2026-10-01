-- v129 — سیستم جای‌گذاری خودکار
.mode column
.headers on

BEGIN;

-- ═══════════════════════════════════════════════════════
-- ۱. جدول قواعد: هر نوع کجای سیستم می‌نشیند؟
-- ═══════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS e01_200_04_tb (
  rule_id INTEGER PRIMARY KEY AUTOINCREMENT,
  type_id INTEGER NOT NULL,
  target_uid TEXT NOT NULL,
  placement_kind TEXT NOT NULL CHECK(placement_kind IN ('inherent_to','has_direct_part','may_have_direct_part')),
  is_default INTEGER NOT NULL DEFAULT 1,
  note TEXT,
  UNIQUE(type_id, target_uid, placement_kind),
  CONSTRAINT fk_plc_type FOREIGN KEY (type_id) REFERENCES e01_200_01_tb(type_id),
  CONSTRAINT fk_plc_target FOREIGN KEY (target_uid) REFERENCES e01_200_03_tb(ent_uid)
);
CREATE INDEX IF NOT EXISTS e02_200_40_ix ON e01_200_04_tb(type_id);

-- ═══════════════════════════════════════════════════════
-- ۲. پر کردن قواعد از داده‌های فعلی
-- هر رابطه inherent_to که از یک زیرسیستم به یک قطعه وجود دارد
-- → قاعده‌ای برای نوع آن قطعه
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_200_04_tb (type_id, target_uid, placement_kind, note)
SELECT DISTINCT 
  e.type_id, 
  subj.ent_uid, 
  'inherent_to',
  'Auto-extracted from existing inherent_to relations'
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='inherent_to'
JOIN e01_200_03_tb subj ON subj.ent_id = r.subj_ent_id
JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
JOIN e01_200_03_tb e ON e.ent_uid = obj.ent_uid
WHERE subj.ent_uid LIKE 'concept:%-subsystem'
  AND r.status='asserted' AND r.superseded_at IS NULL;

INSERT OR IGNORE INTO e01_200_04_tb (type_id, target_uid, placement_kind, note)
SELECT DISTINCT 
  e.type_id, 
  subj.ent_uid, 
  'has_direct_part',
  'Auto-extracted from existing has_direct_part relations'
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='has_direct_part'
JOIN e01_200_03_tb subj ON subj.ent_id = r.subj_ent_id
JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
JOIN e01_200_03_tb e ON e.ent_uid = obj.ent_uid
WHERE subj.ent_uid LIKE 'concept:%-subsystem'
  AND r.status='asserted' AND r.superseded_at IS NULL;

-- ═══════════════════════════════════════════════════════
-- ۳. Trigger: وقتی entity جدید اضافه شد، خودش جای بگیرد
-- ═══════════════════════════════════════════════════════
DROP TRIGGER IF EXISTS e03_200_04_auto_place;
CREATE TRIGGER e03_200_04_auto_place
AFTER INSERT ON e01_200_03_tb
WHEN NEW.nature = 'concept'
  AND NEW.ent_uid NOT LIKE 'concept:%system%'
  AND NEW.ent_uid NOT LIKE 'concept:%-domain'
  AND NEW.ent_uid NOT LIKE 'concept:%-subsystem'
BEGIN
  -- اگر نوعش در جدول قواعد هست، خودکار وصلش کن
  INSERT OR IGNORE INTO e01_222_01_tb 
    (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
  SELECT 
    'r:auto-' || REPLACE(NEW.ent_uid, ':', '-') || '-' || REPLACE(r.target_uid, ':', '-'),
    (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid = r.placement_kind),
    (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid = r.target_uid),
    NEW.ent_id,
    'asserted',
    2
  FROM e01_200_04_tb r
  WHERE r.type_id = NEW.type_id
    AND r.is_default = 1
    AND NOT EXISTS (
      SELECT 1 FROM e01_222_01_tb x
      WHERE x.subj_ent_id = (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid = r.target_uid)
        AND x.obj_ent_id = NEW.ent_id
        AND x.status='asserted' AND x.superseded_at IS NULL
    );
END;

-- ═══════════════════════════════════════════════════════
-- ۴. ثبت در registry و matrix
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_506_03_tb 
  (element_name, element_layer, element_kind, element_level, need_uid)
VALUES 
  ('e01_200_04_tb', 'T', 'tb', 1, 'N50'),
  ('e03_200_04_auto_place', 'T', 'tr', 3, 'N50');

INSERT OR IGNORE INTO e01_778_02_tb (element_name, need_uid, role)
VALUES 
  ('e01_200_04_tb', 'N50', 'serves'),
  ('e03_200_04_auto_place', 'N50', 'serves');

INSERT OR IGNORE INTO e01_778_05_tb 
  (element_name, need_uid, policy_kind, exec_name, rationale, is_mandatory)
VALUES 
  ('e01_200_04_tb', 'N50', 'audit', 'e01_200_04_tb', 'Organic placement rules table', 1),
  ('e03_200_04_auto_place', 'N50', 'guard', 'e03_200_04_auto_place', 'Auto-place new entities based on type', 1);

INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v129_organic_placement','Meta placement rules + auto-placement trigger');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- ═══ گزارش ═══
SELECT '═══ قواعد استخراج‌شده ═══' AS section;
SELECT placement_kind, COUNT(*) AS n FROM e01_200_04_tb GROUP BY placement_kind;

SELECT '' AS x;
SELECT '═══ نمونه قواعد ═══' AS section;
SELECT t.type_uid AS entity_type, r.target_uid AS goes_to, r.placement_kind
FROM e01_200_04_tb r
JOIN e01_200_01_tb t ON t.type_id = r.type_id
LIMIT 15;
