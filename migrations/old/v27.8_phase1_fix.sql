-- =====================================================================
-- v27.8 Phase 1 — Fix label_norm, FTS, and enum
-- =====================================================================

-- FIX 1: Backfill label_norm for all entities
UPDATE e01_200_03_tb
SET label_norm = lower(trim(label))
WHERE label_norm IS NULL OR label_norm = '';

-- FIX 2: Backfill desc_norm if needed
UPDATE e01_200_03_tb
SET desc_norm = lower(trim(COALESCE(description, '')))
WHERE desc_norm IS NULL OR desc_norm = '';

-- FIX 3: Rebuild FTS with actual data
INSERT INTO e02_404_01_ft(e02_404_01_ft) VALUES('rebuild');

-- FIX 4: Restore enum domains (8 domains)
INSERT OR IGNORE INTO e01_200_02_tb (dom_uid, label) VALUES
('state','وضعیت'),
('severity','شدت'),
('confidence','اطمینان'),
('yes_no','بله/خیر'),
('absence_type','نوع غیاب'),
('negation_kind','نوع نفی'),
('detection_rating','رتبه تشخیص'),
('rate_unit','واحد نرخ');

-- FIX 5: Restore enum values (25 values)
INSERT OR IGNORE INTO e01_201_01_tb (dom_id, value_uid, label, sort_order)
SELECT (SELECT dom_id FROM e01_200_02_tb WHERE dom_uid='state'),'on','روشن',1
UNION ALL SELECT (SELECT dom_id FROM e01_200_02_tb WHERE dom_uid='state'),'off','خاموش',2
UNION ALL SELECT (SELECT dom_id FROM e01_200_02_tb WHERE dom_uid='state'),'unknown','نامعلوم',3
UNION ALL SELECT (SELECT dom_id FROM e01_200_02_tb WHERE dom_uid='severity'),'info','اطلاع',1
UNION ALL SELECT (SELECT dom_id FROM e01_200_02_tb WHERE dom_uid='severity'),'warning','هشدار',2
UNION ALL SELECT (SELECT dom_id FROM e01_200_02_tb WHERE dom_uid='severity'),'critical','بحرانی',3
UNION ALL SELECT (SELECT dom_id FROM e01_200_02_tb WHERE dom_uid='confidence'),'low','کم',1
UNION ALL SELECT (SELECT dom_id FROM e01_200_02_tb WHERE dom_uid='confidence'),'medium','متوسط',2
UNION ALL SELECT (SELECT dom_id FROM e01_200_02_tb WHERE dom_uid='confidence'),'high','بالا',3
UNION ALL SELECT (SELECT dom_id FROM e01_200_02_tb WHERE dom_uid='yes_no'),'yes','بله',1
UNION ALL SELECT (SELECT dom_id FROM e01_200_02_tb WHERE dom_uid='yes_no'),'no','خیر',2
UNION ALL SELECT (SELECT dom_id FROM e01_200_02_tb WHERE dom_uid='absence_type'),'not_observed','مشاهده نشد',1
UNION ALL SELECT (SELECT dom_id FROM e01_200_02_tb WHERE dom_uid='absence_type'),'not_recorded','ثبت نشد',2
UNION ALL SELECT (SELECT dom_id FROM e01_200_02_tb WHERE dom_uid='absence_type'),'not_applicable','نامرتبط',3
UNION ALL SELECT (SELECT dom_id FROM e01_200_02_tb WHERE dom_uid='absence_type'),'unknown','نامعلوم',4
UNION ALL SELECT (SELECT dom_id FROM e01_200_02_tb WHERE dom_uid='negation_kind'),'source_denied','منبع رد کرد',1
UNION ALL SELECT (SELECT dom_id FROM e01_200_02_tb WHERE dom_uid='negation_kind'),'author_retracted','نویسنده پس گرفت',2
UNION ALL SELECT (SELECT dom_id FROM e01_200_02_tb WHERE dom_uid='negation_kind'),'counterfactual','فرضی',3
UNION ALL SELECT (SELECT dom_id FROM e01_200_02_tb WHERE dom_uid='detection_rating'),'certain','قطعاً',1
UNION ALL SELECT (SELECT dom_id FROM e01_200_02_tb WHERE dom_uid='detection_rating'),'likely','احتمالاً',2
UNION ALL SELECT (SELECT dom_id FROM e01_200_02_tb WHERE dom_uid='detection_rating'),'uncertain','نامعلوم',3
UNION ALL SELECT (SELECT dom_id FROM e01_200_02_tb WHERE dom_uid='detection_rating'),'rare','به‌ندرت',4
UNION ALL SELECT (SELECT dom_id FROM e01_200_02_tb WHERE dom_uid='rate_unit'),'per_year','در سال',1
UNION ALL SELECT (SELECT dom_id FROM e01_200_02_tb WHERE dom_uid='rate_unit'),'per_100k_km','در ۱۰۰ هزار کیلومتر',2
UNION ALL SELECT (SELECT dom_id FROM e01_200_02_tb WHERE dom_uid='rate_unit'),'mtbf_hours','MTBF ساعتی',3;

-- Log
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v27.8_phase1_fix', 'Backfilled label_norm, rebuilt FTS, restored enum');

-- Bump
UPDATE e01_676_02_tb SET schema_ver = 45, last_scan_at = datetime('now') WHERE id = 1;
