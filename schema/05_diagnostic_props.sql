-- Diagnostic sources with unique prefix DIAG-
INSERT INTO sources (project_id, source_type, source_ref, confidence)
SELECT 'semantic-core', 'diagnostic_model', x, 1.00
FROM (VALUES
  ('DIAG-1-MISSION'), ('DIAG-3-EPISODE'), ('DIAG-5-RECONSTRUCT'),
  ('DIAG-6-EXPECTED'), ('DIAG-7-NORMALIZE'), ('DIAG-8-HYPOSPACE'),
  ('DIAG-9-HYPOSTRUCT'), ('DIAG-11-NARROW'), ('DIAG-12-NEGATIVE'),
  ('DIAG-13-COVERED'), ('DIAG-15-TEST'), ('DIAG-17-SELECT'),
  ('DIAG-19-STOP'), ('DIAG-20-MEASERROR'), ('DIAG-21-INTERMITTENT'),
  ('DIAG-22-DTC'), ('DIAG-23-MULTIFAULT'), ('DIAG-24-DECISION'),
  ('DIAG-25-REFERRAL'), ('DIAG-26-VERIFY'), ('DIAG-27-COUNTERFACTUAL'),
  ('DIAG-30-KERNEL'), ('DIAG-32-SAFETY'), ('DIAG-33-LEARNING')
) AS t(x)
WHERE NOT EXISTS (SELECT 1 FROM sources WHERE project_id='semantic-core' AND source_ref=x);

-- Helper view for source lookup (temporary)
-- We use subqueries everywhere
INSERT INTO atomic_propositions (project_id, prop_code, proposition, prop_type, scope_id, source_id, status_id)
SELECT 'semantic-core', prop_code, proposition, prop_type,
       (SELECT scope_id FROM scopes WHERE project_id='semantic-core' AND scope_code=scope_code_ref),
       (SELECT source_id FROM sources WHERE project_id='semantic-core' AND source_ref=source_ref_ref),
       (SELECT status_id FROM statuses WHERE project_id='semantic-core' AND status_code='active')
FROM (VALUES
  ('E-001', 'مدل تشخیص، قرارداد عملیاتی سامانه است.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-1-MISSION'),
  ('E-002', 'خروجی تشخیص خوب، همیشه یک قطعه خراب نیست.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-1-MISSION'),
  ('E-003', 'خروجی می‌تواند فضای فرضیه محدودشده باشد.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-1-MISSION'),
  ('E-004', 'خروجی می‌تواند اقدام بعدی مشخص باشد.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-1-MISSION'),
  ('E-005', 'خروجی می‌تواند تصمیم با سطح ادعای متناسب باشد.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-1-MISSION'),
  ('E-006', 'خروجی می‌تواند «نامشخص» باشد.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-1-MISSION'),
  ('E-007', 'خروجی می‌تواند ارجاع به متخصص باشد.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-1-MISSION'),
  ('E-008', 'پنج تعهد مدل تشخیص وجود دارد.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-1-MISSION'),
  ('E-009', 'تعهد اول: ساخت و نگهداری فضای فرضیه.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-1-MISSION'),
  ('E-010', 'تعهد دوم: Test به‌عنوان اقدام تفکیک‌کننده.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-1-MISSION'),
  ('E-011', 'تعهد سوم: انتخاب آزمون بعدی با معیارهای چندگانه.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-1-MISSION'),
  ('E-012', 'تعهد چهارم: تفکیک تصمیم، تعمیر و راستی‌آزمایی.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-1-MISSION'),
  ('E-013', 'تعهد پنجم: ثبت مسیر استدلال.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-1-MISSION'),
  ('E-014', 'مدل تشخیص در مرز سه لایه قرار دارد.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-1-MISSION'),
  ('E-015', 'مدل تشخیص نباید تصمیم‌های لایه‌های دیگر را بگیرد.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-1-MISSION'),
  ('E-016', 'مدل تشخیص، از دانش و دامنه استفاده می‌کند.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-1-MISSION'),
  ('E-017', 'هسته استدلال، موتور تبدیل مواد به استدلال است.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-1-MISSION'),
  ('E-018', 'پنج ویژگی مدل بالغ: Scope-aware، Evidence-driven، Multi-hypothesis، Discriminating، Auditable.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-1-MISSION'),
  ('E-019', 'مدل بین خودروی واقعی، دانش و اقدام قرار دارد.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-1-MISSION'),
  ('E-020', 'مدل، بازنمایی استدلال است، نه خودِ خودرو.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-1-MISSION'),
  ('E-021', 'چهار جریان در مدل تشخیص: داده، فرضیه، آزمون، تصمیم.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-1-MISSION'),
  ('E-022', 'مصرف دانش مشروط به Active، Scope و Evidence است.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-1-MISSION'),
  ('E-023', 'هر Episode باید Feedback به یادگیری بدهد.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-1-MISSION'),
  ('E-024', 'مدل تشخیص دانش را بازنویسی نمی‌کند.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-1-MISSION'),
  ('E-025', 'Diagnostic Episode، واحد کاری مدل تشخیص است.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-3-EPISODE'),
  ('E-026', 'Episode از مطرح شدن مسئله آغاز می‌شود.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-3-EPISODE'),
  ('E-027', 'Episode با تصمیم، ارجاع، Unknown یا بسته شدن تمام می‌شود.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-3-EPISODE'),
  ('E-028', 'Episode شامل Vehicle Context، Problem، Observations، Hypotheses، Actions، Outcome است.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-3-EPISODE'),
  ('E-029', 'Episode باید متمرکز باشد.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-3-EPISODE'),
  ('E-030', 'Episodeها نباید باز بی‌پایان بمانند.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-3-EPISODE')
) AS t(prop_code, proposition, prop_type, scope_code_ref, source_ref_ref);

INSERT INTO atomic_propositions (project_id, prop_code, proposition, prop_type, scope_id, source_id, status_id)
SELECT 'semantic-core', prop_code, proposition, prop_type,
       (SELECT scope_id FROM scopes WHERE project_id='semantic-core' AND scope_code=scope_code_ref),
       (SELECT source_id FROM sources WHERE project_id='semantic-core' AND source_ref=source_ref_ref),
       (SELECT status_id FROM statuses WHERE project_id='semantic-core' AND status_code='active')
FROM (VALUES
  ('E-031', 'ورودی ناقص نباید منجر به علت ساختگی شود.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-5-RECONSTRUCT'),
  ('E-032', 'سه سطح ورودی: حداقلی، کافی، غنی.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-5-RECONSTRUCT'),
  ('E-033', 'پاسخ مدل باید متناسب با سطح ورودی باشد.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-5-RECONSTRUCT'),
  ('E-034', 'در ورودی ناقص، سؤال درست بهتر از پاسخ سریع است.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-5-RECONSTRUCT'),
  ('E-035', 'ورودی تدریجی، فضای فرضیه را هدفمند می‌کند.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-5-RECONSTRUCT'),
  ('E-036', 'مسیر بازسازی از Identity تا Expected Behavior است.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-5-RECONSTRUCT'),
  ('E-037', 'برای هر مسئله فقط بخش مرتبط از ساختار وارد می‌شود.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-5-RECONSTRUCT'),
  ('E-038', 'سه اصل بازسازی: کفایت، اقتصاد، قابلیت گسترش.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-5-RECONSTRUCT'),
  ('E-039', 'مسیر بازگشت هرگز نباید در بازسازی نادیده گرفته شود.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-5-RECONSTRUCT'),
  ('E-040', 'بازسازی با ترسیم نقشه فرق دارد.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-5-RECONSTRUCT'),
  ('E-041', 'سه لایه بازسازی: ساختاری، نقش، شرایط.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-5-RECONSTRUCT'),
  ('E-042', 'Expected Behavior، مرجعی برای مقایسه با As-Found است.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-6-EXPECTED'),
  ('E-043', 'چهار پرسش برای ساخت Expected Behavior وجود دارد.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-6-EXPECTED'),
  ('E-044', 'Difference یک واقعیت است، نه یک تفسیر.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-6-EXPECTED'),
  ('E-045', 'Expected Behavior بدون Scope مبنای تصمیم نیست.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-6-EXPECTED'),
  ('E-046', 'چهار نوع Expected Behavior: Specification، Field Reference، Constraint، Behavioral.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-6-EXPECTED'),
  ('E-047', 'هر نوع Expected Behavior سطح اعتماد متفاوتی دارد.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-6-EXPECTED'),
  ('E-048', 'نرمال‌سازی، Complaint را به Observation تبدیل می‌کند.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-7-NORMALIZE'),
  ('E-049', 'Complaint زبان مشتری است، Observation زبان فنی.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-7-NORMALIZE'),
  ('E-050', 'شکایت باید به نشانه‌های مشخص تفکیک شود.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-7-NORMALIZE'),
  ('E-051', 'Context هر نشانه باید مشخص شود.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-7-NORMALIZE'),
  ('E-052', 'برای هر نشانه، Observationهای قابل جمع‌آوری تعیین می‌شوند.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-7-NORMALIZE'),
  ('E-053', 'Complaint نباید با علت یکی گرفته شود.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-7-NORMALIZE'),
  ('E-054', 'چهارده گام هسته استدلال وجود دارد.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-30-KERNEL'),
  ('E-055', 'گام اول: Validate context/scope.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-30-KERNEL'),
  ('E-056', 'گام دوم: Build relevant structure.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-30-KERNEL'),
  ('E-057', 'گام سوم: Build expected behavior.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-30-KERNEL'),
  ('E-058', 'گام چهارم: Generate candidate hypotheses.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-30-KERNEL'),
  ('E-059', 'گام پنجم تا هفتم: Apply constraints، Select tests، Predict outcomes.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-30-KERNEL'),
  ('E-060', 'گام هشتم تا دهم: Choose action، Update state، Emit decision.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-30-KERNEL')
) AS t(prop_code, proposition, prop_type, scope_code_ref, source_ref_ref);

INSERT INTO atomic_propositions (project_id, prop_code, proposition, prop_type, scope_id, source_id, status_id)
SELECT 'semantic-core', prop_code, proposition, prop_type,
       (SELECT scope_id FROM scopes WHERE project_id='semantic-core' AND scope_code=scope_code_ref),
       (SELECT source_id FROM sources WHERE project_id='semantic-core' AND source_ref=source_ref_ref),
       (SELECT status_id FROM statuses WHERE project_id='semantic-core' AND status_code='active')
FROM (VALUES
  ('E-061', 'فضای فرضیه، مجموعه‌ای از توضیح‌های قابل بررسی است.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-8-HYPOSPACE'),
  ('E-062', 'فرضیه باید بیش از نام قطعه باشد.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-8-HYPOSPACE'),
  ('E-063', 'اصل فرضیه: اگر درست باشد، چه مشاهده‌ای باید ببینیم؟', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-8-HYPOSPACE'),
  ('E-064', 'فضای اولیه از مسیر تحقق رفتار استخراج می‌شود.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-8-HYPOSPACE'),
  ('E-065', 'هشت فرضیه معمول برای مسئله فن وجود دارد.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-8-HYPOSPACE'),
  ('E-066', 'اگر یک فرضیه از قلم بیفتد، مدل ممکن است نادرست شود.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-8-HYPOSPACE'),
  ('E-067', 'فرضیه نباید با Symptom یا Cause یکی گرفته شود.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-8-HYPOSPACE'),
  ('E-068', 'سه اصل ساخت فضای فرضیه: کفایت، Scope، آزمون‌پذیری.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-8-HYPOSPACE'),
  ('E-069', 'هشت فیلد مفهومی برای Hypothesis وجود دارد.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-9-HYPOSTRUCT'),
  ('E-070', 'Proposition، Target، Scope، Predictions از فیلدها هستند.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-9-HYPOSTRUCT'),
  ('E-071', 'Prior، Evidence Relation، Diagnostic Status و Open Questions از فیلدهای دیگرند.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-9-HYPOSTRUCT'),
  ('E-072', '«رله خراب است» یک فرضیه کامل نیست.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-9-HYPOSTRUCT'),
  ('E-073', 'سه سطح فرضیه: High-Level، Mid-Level، Low-Level.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-9-HYPOSTRUCT'),
  ('E-074', 'High-Level برای تجزیه، Mid-Level برای کار، Low-Level برای تأیید.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-9-HYPOSTRUCT'),
  ('E-075', 'مسیر تولید فرضیه از Deviation تا Hypothesis Set است.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-9-HYPOSTRUCT'),
  ('E-076', 'دو نوع گسترش: Structural و Knowledge-Guided.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-9-HYPOSTRUCT'),
  ('E-077', 'گسترش باید مرز داشته باشد.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-9-HYPOSTRUCT'),
  ('E-078', 'سه منبع تولید فرضیه: ساختار، دانش، تجربه.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-9-HYPOSTRUCT'),
  ('E-079', 'اصل «هر فرضیه، یک آزمون» باید رعایت شود.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-9-HYPOSTRUCT'),
  ('E-080', 'Test Gap زمانی است که آزمون تفکیک‌کننده نداریم.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-9-HYPOSTRUCT'),
  ('E-081', 'محدودسازی با چهار نوع قید انجام می‌شود.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-11-NARROW'),
  ('E-082', 'Scope Mismatch، Contradictory Observation، Structural Impossibility، Measurement Uncertainty.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-11-NARROW'),
  ('E-083', 'هدف محدودسازی، فضای باقی‌مانده قابل تصمیم است.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-11-NARROW'),
  ('E-084', 'حذف دلخواه فرضیه ممنوع است.', 'forbidden', 'SCOPE-DIAGNOSTIC', 'DIAG-11-NARROW'),
  ('E-085', 'سه مرحله محدودسازی: ساختاری، Scope، تضعیف با شواهد.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-11-NARROW'),
  ('E-086', 'دو نوع نتیجه: Positive Diagnosis و Negative Diagnosis.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-12-NEGATIVE'),
  ('E-087', 'رد فرضیه به‌خودی‌خود علت درست را ثابت نمی‌کند.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-12-NEGATIVE'),
  ('E-088', 'Negative Diagnosis ارزان‌تر از اثبات است.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-12-NEGATIVE'),
  ('E-089', 'Negative Diagnosis نباید از دامنه آزمون بزرگ‌تر شود.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-12-NEGATIVE'),
  ('E-090', 'سه سطح Negative: ضعیف، متوسط، قوی.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-12-NEGATIVE'),
  ('E-091', 'هر Negative باید دامنه خود را حمل کند.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-12-NEGATIVE'),
  ('E-092', 'Covered Domain دامنه‌ای است که نتیجه در آن معتبر است.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-13-COVERED'),
  ('E-093', 'ادعای مطلق باید به ادعای دامنه‌دار تبدیل شود.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-13-COVERED'),
  ('E-094', 'سه اصل Covered Domain: صراحت، عدم تعمیم، قابلیت بازبینی.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-13-COVERED'),
  ('E-095', 'Covered Domain باید قابل بازبینی باشد.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-13-COVERED')
) AS t(prop_code, proposition, prop_type, scope_code_ref, source_ref_ref)
ON CONFLICT (project_id, prop_code) DO NOTHING;
