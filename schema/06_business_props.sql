-- ===================================================================
-- Business Plan Atomic Propositions
-- ===================================================================

-- دامنه کسب‌وکار
INSERT INTO scopes (project_id, scope_code, description)
SELECT 'semantic-core', 'SCOPE-BUSINESS', 'لایه کسب‌وکار'
WHERE NOT EXISTS (SELECT 1 FROM scopes WHERE project_id='semantic-core' AND scope_code='SCOPE-BUSINESS');

-- منابع
INSERT INTO sources (project_id, source_type, source_ref, confidence)
SELECT 'semantic-core', 'business_plan', x, 1.00
FROM (VALUES
  ('BIZ-MARKET'), ('BIZ-MODELS'), ('BIZ-COMPARE'),
  ('BIZ-LESSONS'), ('BIZ-HYBRID'), ('BIZ-ROADMAP'),
  ('BIZ-FINANCE'), ('BIZ-RISK'), ('BIZ-KPI'), ('BIZ-RECOMMEND')
) AS t(x)
WHERE NOT EXISTS (SELECT 1 FROM sources WHERE project_id='semantic-core' AND source_ref=x);

-- گزاره‌های کسب‌وکار (B-001 تا B-075)
INSERT INTO atomic_propositions (project_id, prop_code, proposition, prop_type, scope_id, source_id, status_id)
SELECT 'semantic-core', prop_code, proposition, prop_type,
       (SELECT scope_id FROM scopes WHERE project_id='semantic-core' AND scope_code='SCOPE-BUSINESS'),
       (SELECT source_id FROM sources WHERE project_id='semantic-core' AND source_ref=source_ref_ref),
       (SELECT status_id FROM statuses WHERE project_id='semantic-core' AND status_code='active')
FROM (VALUES
  -- بازار (B-001 تا B-010)
  ('B-001', 'بازار کرج، دومین کلان‌شهر ایران با تراکم خودرو بالا است.', 'fact', 'BIZ-MARKET'),
  ('B-002', 'نسبت تعمیرگاه غیررسمی به رسمی حدود ۱۰ به ۱ است.', 'fact', 'BIZ-MARKET'),
  ('B-003', 'سه دسته رقیب وجود دارد: نمایندگی رسمی، تعمیرگاه سنتی، تعمیرگاه تخصصی.', 'fact', 'BIZ-MARKET'),
  ('B-004', 'تعمیرگاه‌های سنتی ۷۰٪ بازار را در اختیار دارند.', 'fact', 'BIZ-MARKET'),
  ('B-005', 'نمایندگی‌های رسمی ۲۰٪ بازار را در اختیار دارند.', 'fact', 'BIZ-MARKET'),
  ('B-006', 'تعمیرگاه‌های تخصصی ۱۰٪ بازار را در اختیار دارند.', 'fact', 'BIZ-MARKET'),
  ('B-007', 'شکاف عدم شفافیت قیمت در بازار جدی است.', 'fact', 'BIZ-MARKET'),
  ('B-008', 'شکاف کیفیت غیریکنواخت در بازار جدی است.', 'fact', 'BIZ-MARKET'),
  ('B-009', 'شکاف عدم پیگیری پس از تعمیر در بازار جدی است.', 'fact', 'BIZ-MARKET'),
  ('B-010', 'سه پرسونا مشتری وجود دارد: محافظه‌کار، مدرن، اضطراری.', 'fact', 'BIZ-MARKET'),

  -- هفت مدل (B-011 تا B-025)
  ('B-011', 'هفت مدل کسب‌وکار ممکن برای این پروژه وجود دارد.', 'fact', 'BIZ-MODELS'),
  ('B-012', 'مدل سنتی سریع اجرا می‌شود اما مقیاس‌پذیر نیست.', 'fact', 'BIZ-MODELS'),
  ('B-013', 'مدل فرنچایز نیازمند برند قوی و SOP بالغ است.', 'fact', 'BIZ-MODELS'),
  ('B-014', 'مدل SaaS خالص در ایران ۱۴۰۵ سخت است.', 'fact', 'BIZ-MODELS'),
  ('B-015', 'مدل مارکت‌پلیس در ایران با مشکل اعتماد مواجه است.', 'fact', 'BIZ-MODELS'),
  ('B-016', 'مدل فروش داده در ایران خریدار محدود دارد.', 'fact', 'BIZ-MODELS'),
  ('B-017', 'مدل B2B API نیازمند محصول بالغ است.', 'fact', 'BIZ-MODELS'),
  ('B-018', 'مدل سرمایه‌گذاری خارجی در ایران ۱۴۰۵ غیرممکن است.', 'fact', 'BIZ-MODELS'),
  ('B-019', 'حاشیه سود تعمیرگاه سنتی ۱۵ تا ۲۵ درصد است.', 'fact', 'BIZ-MODELS'),
  ('B-020', 'حاشیه سود SaaS و B2B API بین ۷۰ تا ۹۰ درصد است.', 'fact', 'BIZ-MODELS'),
  ('B-021', 'فرنچایز جهانی Christian Brothers، ۸۵٪ فرنچایزگیرندگان را از خارج صنعت جذب می‌کند.', 'fact', 'BIZ-MODELS'),
  ('B-022', 'فرنچایزگیرنده بدون تجربه صنعت، SOP را راحت‌تر می‌پذیرد.', 'fact', 'BIZ-MODELS'),
  ('B-023', 'مدل SaaS نیازمند فرهنگ پرداخت اشتراک است.', 'fact', 'BIZ-MODELS'),
  ('B-024', 'تعمیرکار ایرانی به ذخیره ابری اعتماد ندارد.', 'fact', 'BIZ-MODELS'),
  ('B-025', 'فروش داده نیازمند حجم ۱۰۰٫۰۰۰ Case و بالغ شدن بیمه‌هاست.', 'fact', 'BIZ-MODELS'),

  -- مقایسه و درس‌ها (B-026 تا B-040)
  ('B-026', 'نتیجه مقایسه: هیچ مدلی به‌تنهایی کافی نیست.', 'fact', 'BIZ-COMPARE'),
  ('B-027', 'فرنچایز و تعمیرگاه سنتی برندگان کوتاه‌مدت هستند.', 'fact', 'BIZ-COMPARE'),
  ('B-028', 'SaaS و B2B API برندگان میان‌مدت هستند.', 'fact', 'BIZ-COMPARE'),
  ('B-029', 'فروش داده برنده بلندمدت است.', 'fact', 'BIZ-COMPARE'),
  ('B-030', 'رشد بی‌محابا بدون اقتصاد واحد، دلیل اصلی شکست‌ها است.', 'fact', 'BIZ-LESSONS'),
  ('B-031', 'اتکا به سرمایه خارجی به‌جای درآمد داخلی، دلیل شکست است.', 'fact', 'BIZ-LESSONS'),
  ('B-032', 'فرض‌های اثبات‌نشده، دلیل شکست GoMechanic و 集群车宝 بود.', 'fact', 'BIZ-LESSONS'),
  ('B-033', 'تمرکز روی فناوری به‌جای مشتری، دلیل شکست است.', 'fact', 'BIZ-LESSONS'),
  ('B-034', 'تمرکز بر یک منطقه قبل از گسترش، الگوی موفقیت است.', 'fact', 'BIZ-LESSONS'),
  ('B-035', 'اقتصاد واحد مثبت از ابتدا، الگوی موفقیت است.', 'fact', 'BIZ-LESSONS'),
  ('B-036', 'SOP قوی و آموزش مؤثر، الگوی موفقیت است.', 'fact', 'BIZ-LESSONS'),
  ('B-037', 'درآمد تکرارشونده، الگوی موفقیت است.', 'fact', 'BIZ-LESSONS'),
  ('B-038', 'داده به‌عنوان اهرم داخلی، الگوی موفقیت است.', 'fact', 'BIZ-LESSONS'),
  ('B-039', 'Christian Brothers الگوی موفقیت فرنچایز جهانی است.', 'fact', 'BIZ-LESSONS'),
  ('B-040', 'Bosch Car Service نشان می‌دهد برند و استاندارد جایگزین قیمت پایین می‌شوند.', 'fact', 'BIZ-LESSONS'),

  -- مدل ترکیبی (B-041 تا B-055)
  ('B-041', 'مدل پیشنهادی، ترکیبی مرحله‌ای است.', 'rule', 'BIZ-HYBRID'),
  ('B-042', 'مدل مارپیچی، امکان بازگشت و اصلاح را می‌دهد.', 'rule', 'BIZ-HYBRID'),
  ('B-043', 'مرحله اول: تعمیرگاه پرچم‌دار.', 'rule', 'BIZ-HYBRID'),
  ('B-044', 'مرحله دوم: فرنچایز (۲ تا ۵ شعبه).', 'rule', 'BIZ-HYBRID'),
  ('B-045', 'مرحله سوم: SaaS (فروش به تعمیرگاه‌های مستقل).', 'rule', 'BIZ-HYBRID'),
  ('B-046', 'مرحله چهارم: B2B API (بیمه، قطعه، خودروساز).', 'rule', 'BIZ-HYBRID'),
  ('B-047', 'مرحله پنجم: فروش داده (تحلیلی و راهبردی).', 'rule', 'BIZ-HYBRID'),
  ('B-048', 'مرحله اول باید ابتدا مسئله واقعی را حل کند.', 'rule', 'BIZ-HYBRID'),
  ('B-049', 'مرحله دوم تکرارپذیری مدل را اثبات می‌کند.', 'rule', 'BIZ-HYBRID'),
  ('B-050', 'مرحله سوم پس از اثبات و برند شناخته‌شده آغاز می‌شود.', 'rule', 'BIZ-HYBRID'),
  ('B-051', 'مرحله چهارم نیازمند دانش ساختاریافته چندساله است.', 'rule', 'BIZ-HYBRID'),
  ('B-052', 'مرحله پنجم آخرین مرحله است، چون خریدار داده محدود است.', 'rule', 'BIZ-HYBRID'),
  ('B-053', 'هر مرحله، مرحله بعد را با درآمد خود تأمین می‌کند.', 'rule', 'BIZ-HYBRID'),
  ('B-054', 'مدل ترکیبی نیازمند سرمایه‌گذاری خارجی نیست.', 'rule', 'BIZ-HYBRID'),
  ('B-055', 'مدل مارپیچی با واقعیت پیچیده کسب‌وکار سازگارتر است.', 'rule', 'BIZ-HYBRID'),

  -- نقشه راه (B-056 تا B-060)
  ('B-056', 'مرحله اول: ۶ ماه، تعمیرگاه پرچم‌دار، ۵۰۰-۹۰۰ میلیون تومان سرمایه.', 'rule', 'BIZ-ROADMAP'),
  ('B-057', 'مرحله دوم: ۱۲ ماه، فرنچایز، معیار: شعبه دوم به ۷۰٪ شعبه اول.', 'rule', 'BIZ-ROADMAP'),
  ('B-058', 'مرحله سوم: ۱۲ ماه، SaaS، معیار: ۱۰ شعبه + ۵ مشتری SaaS.', 'rule', 'BIZ-ROADMAP'),
  ('B-059', 'مرحله چهارم: ۱۲ ماه، B2B API، معیار: ۳ قرارداد فعال.', 'rule', 'BIZ-ROADMAP'),
  ('B-060', 'مرحله پنجم: ادامه، فروش داده، معیار: ۱۰٪ درآمد از داده.', 'rule', 'BIZ-ROADMAP'),

  -- ریسک و KPI (B-061 تا B-070)
  ('B-061', 'ریسک‌های اصلی: عدم پذیرش مشتری، مقاومت پرسنل، بحران قطعات، تورم.', 'fact', 'BIZ-RISK'),
  ('B-062', 'سه ریسک کشنده: عدم اقتصاد واحد، شکست فرنچایز اول، از دست دادن استادکار.', 'fact', 'BIZ-RISK'),
  ('B-063', 'راهکار ریسک استادکار: ساخت سیستم و انتقال دانش به SOP.', 'rule', 'BIZ-RISK'),
  ('B-064', 'KPI اول: Customer Acquisition Cost کمتر از ۲۰۰ هزار تومان.', 'rule', 'BIZ-KPI'),
  ('B-065', 'KPI دوم: Lifetime Value بیش از ۳ برابر CAC.', 'rule', 'BIZ-KPI'),
  ('B-066', 'KPI سوم: Diagnostic Time Saved حداقل ۲۰٪.', 'rule', 'BIZ-KPI'),
  ('B-067', 'KPI چهارم: Repeat Rate حداقل ۴۰٪.', 'rule', 'BIZ-KPI'),
  ('B-068', 'KPI پنجم: Franchise Replication Rate حداکثر ۴ ماه.', 'rule', 'BIZ-KPI'),
  ('B-069', 'پنج KPI اصلی در کل مسیر پایش می‌شوند.', 'rule', 'BIZ-KPI'),
  ('B-070', 'هر تغییر اساسی در مفروضات، نیازمند بازنگری سند است.', 'rule', 'BIZ-KPI'),

  -- توصیه نهایی (B-071 تا B-075)
  ('B-071', 'توصیه اول: با تعمیرگاه پرچم‌دار شروع کن، نه فرنچایز.', 'rule', 'BIZ-RECOMMEND'),
  ('B-072', 'توصیه دوم: اقتصاد واحد را قبل از فرنچایز اثبات کن.', 'rule', 'BIZ-RECOMMEND'),
  ('B-073', 'توصیه سوم: سرمایه‌گذاری خارجی را فراموش کن.', 'rule', 'BIZ-RECOMMEND'),
  ('B-074', 'توصیه چهارم: داده را محصول نکن، اهرم کن.', 'rule', 'BIZ-RECOMMEND'),
  ('B-075', 'توصیه پنجم: مشتری مدرن را هدف بگیر.', 'rule', 'BIZ-RECOMMEND')
) AS t(prop_code, proposition, prop_type, source_ref_ref)
ON CONFLICT (project_id, prop_code) DO NOTHING;
