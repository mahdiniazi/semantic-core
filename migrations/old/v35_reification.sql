-- v35.0 — قاعده چیزسازی روابط
.mode column
.headers on

BEGIN;

-- جدول قاعده
CREATE TABLE IF NOT EXISTS e01_202_02_tb (
    reltype_id   INTEGER PRIMARY KEY,
    reify_rule   TEXT NOT NULL CHECK(reify_rule IN ('never','when_data','always')),
    category     TEXT NOT NULL,
    reason       TEXT NOT NULL,
    CONSTRAINT fk_reify_rel FOREIGN KEY (reltype_id) 
        REFERENCES e01_202_01_tb(reltype_id) ON DELETE CASCADE
);

-- ========== ۱. ساختاری — هرگز ==========
INSERT OR IGNORE INTO e01_202_02_tb (reltype_id, reify_rule, category, reason)
SELECT reltype_id, 'never', 'structural', 'تعریف ساختار — بدون داده'
FROM e01_202_01_tb
WHERE type_uid IN (
  'instance_of','is_a','part_of','connected_to','mounted_on',
  'has_participant','plays_role','faulty_part_of','compatible_with',
  'represents','governed_by'
);

-- ========== ۲. صفت-مقدار — هرگز ==========
INSERT OR IGNORE INTO e01_202_02_tb (reltype_id, reify_rule, category, reason)
SELECT reltype_id, 'never', 'attribute', 'وصل به مقدار — چیزسازی تکراری'
FROM e01_202_01_tb
WHERE type_uid IN (
  'has_voltage','has_resistance','has_part_number','has_manufacturer',
  'has_version','has_state','has_position','has_quantity','has_code',
  'has_vin','observed_value','has_severity','has_occurrence_rate',
  'has_detection_rating','has_expected_lifetime','has_dtc_code','concerns_vehicle'
);

-- ========== ۳. عملکردی — مشروط ==========
INSERT OR IGNORE INTO e01_202_02_tb (reltype_id, reify_rule, category, reason)
SELECT reltype_id, 'when_data', 'functional', 'اگر ولتاژ/جریان/شرایط ثبت شود'
FROM e01_202_01_tb
WHERE type_uid IN (
  'supplies','controls','measures','transmits','carries_signal',
  'produces','communicates_over','powered_by','grounded_at',
  'detected_by','reports_dtc','installed_on'
);

-- ========== ۴. تشخیصی — همیشه ==========
INSERT OR IGNORE INTO e01_202_02_tb (reltype_id, reify_rule, category, reason)
SELECT reltype_id, 'always', 'diagnostic', 'دارای احتمال/منبع/زمان'
FROM e01_202_01_tb
WHERE type_uid IN (
  'has_failure_mode','manifests_as','diagnosed_as','tested_by',
  'resolved_by','repaired_by','failure_caused_by','detectable_by',
  'suspects','ruled_out','verified_by'
);

-- ========== ۵. زمینه/منبع — همیشه ==========
INSERT OR IGNORE INTO e01_202_02_tb (reltype_id, reify_rule, category, reason)
SELECT reltype_id, 'always', 'contextual', 'دارای منبع/زمان/اعتبار'
FROM e01_202_01_tb
WHERE type_uid IN (
  'applies_to','attributed_to','supports','contradicts','derived_from','replaced_with'
);

-- ========== ۶. زنجیره — همیشه ==========
INSERT OR IGNORE INTO e01_202_02_tb (reltype_id, reify_rule, category, reason)
SELECT reltype_id, 'always', 'chain', 'گام زنجیره — داده و ترتیب دارد'
FROM e01_202_01_tb
WHERE type_uid IN (
  'chain_includes_component','chain_produces_signal','chain_requires_signal'
);

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v35.0_reification', 'Reification rules: 60 relation types categorized');

COMMIT;

-- ========== گزارش ==========
SELECT category, reify_rule, COUNT(*) AS n
FROM e01_202_02_tb
GROUP BY category, reify_rule
ORDER BY category;

SELECT '---' AS sep;

SELECT 'categorized' AS k, COUNT(*) AS n FROM e01_202_02_tb
UNION ALL SELECT 'total_relations_types', COUNT(*) FROM e01_202_01_tb;
