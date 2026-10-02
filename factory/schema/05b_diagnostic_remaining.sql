-- ===================================================================
-- Diagnostic Model — Remaining Propositions (E-096 to E-160)
-- ===================================================================

-- دسته ۴ — Evidence، Test، Selection، Stop (E-096 تا E-125)
INSERT INTO atomic_propositions (project_id, prop_code, proposition, prop_type, scope_id, source_id, status_id)
SELECT 'semantic-core', prop_code, proposition, prop_type,
       (SELECT scope_id FROM scopes WHERE project_id='semantic-core' AND scope_code=scope_code_ref),
       (SELECT source_id FROM sources WHERE project_id='semantic-core' AND source_ref=source_ref_ref),
       (SELECT status_id FROM statuses WHERE project_id='semantic-core' AND status_code='active')
FROM (VALUES
  ('E-096', 'Evidence به‌عنوان رابطه به Hypothesis متصل می‌شود.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-15-TEST'),
  ('E-097', 'چهار نوع رابطه Evidence: Support، Weaken، Neutral، Conflict.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-15-TEST'),
  ('E-098', 'کیفیت، قوت و وضعیت سه مفهوم جدا هستند.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-15-TEST'),
  ('E-099', 'Evidence بدون تعیین رابطه دقیق، قابل استفاده نیست.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-15-TEST'),
  ('E-100', 'سه بُعد کیفیت Evidence وجود دارد.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-15-TEST'),
  ('E-101', 'Measurement Quality، Context Completeness، Independence.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-15-TEST'),
  ('E-102', 'Test یک اقدام قابل تعریف و قابل تفسیر است.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-15-TEST'),
  ('E-103', 'هفت جزء Test وجود دارد.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-15-TEST'),
  ('E-104', 'هدف، Precondition، Method، Observable Outcome از اجزا هستند.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-15-TEST'),
  ('E-105', 'Interpretation Map، Safety، Reversibility از اجزای دیگرند.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-15-TEST'),
  ('E-106', 'Test بدون Interpretation Map بی‌فایده است.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-15-TEST'),
  ('E-107', 'سه نوع Test: Measurement، Activation، Substitution.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-15-TEST'),
  ('E-108', 'Testهای Measurement کم‌خطرترند.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-15-TEST'),
  ('E-109', 'Testهای Substitution می‌توانند منجر به تعویض بی‌مورد شوند.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-15-TEST'),
  ('E-110', 'نتیجه Test ابتدا به Observation و Evidence تبدیل می‌شود.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-15-TEST'),
  ('E-111', 'سه حالت نتیجه Test وجود دارد.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-15-TEST'),
  ('E-112', 'نتیجه سازگار، فرضیه را تقویت می‌کند.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-15-TEST'),
  ('E-113', 'نتیجه ناسازگار، فرضیه را تضعیف می‌کند.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-15-TEST'),
  ('E-114', 'نتیجه ناسازگار با همه، نشانه Hypothesis یا Configuration Gap است.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-15-TEST'),
  ('E-115', 'پریدن از Outcome به Cause ممنوع است.', 'forbidden', 'SCOPE-DIAGNOSTIC', 'DIAG-15-TEST'),
  ('E-116', 'سه سطح اطمینان در نتیجه: قطعی، نسبی، نامطمئن.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-15-TEST'),
  ('E-117', 'شش معیار انتخاب آزمون وجود دارد.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-17-SELECT'),
  ('E-118', 'Discriminating Power، Information Value، Cost/Time از معیارها هستند.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-17-SELECT'),
  ('E-119', 'Risk، Reversibility، Feasibility از معیارهای دیگرند.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-17-SELECT'),
  ('E-120', 'ماتریس تفکیک برای انتخاب آزمون ساخته می‌شود.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-17-SELECT'),
  ('E-121', 'آزمون بدون هدف، هدر دادن منابع است.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-17-SELECT'),
  ('E-122', 'Test Utility تابعی از ارزش، هزینه، ریسک و زمان است.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-17-SELECT'),
  ('E-123', 'امتیاز پنهان جایگزین دلیل انتخاب آزمون نمی‌شود.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-17-SELECT'),
  ('E-124', 'Stop Rule مشخص می‌کند چه زمانی شواهد کافی است.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-19-STOP'),
  ('E-125', '«برای اطمینان ذهنی» دلیل کافی برای آزمون اضافه نیست.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-19-STOP')
) AS t(prop_code, proposition, prop_type, scope_code_ref, source_ref_ref)
ON CONFLICT (project_id, prop_code) DO NOTHING;

-- دسته ۵ — حالت‌های ویژه و تصمیم نهایی (E-126 تا E-160)
INSERT INTO atomic_propositions (project_id, prop_code, proposition, prop_type, scope_id, source_id, status_id)
SELECT 'semantic-core', prop_code, proposition, prop_type,
       (SELECT scope_id FROM scopes WHERE project_id='semantic-core' AND scope_code=scope_code_ref),
       (SELECT source_id FROM sources WHERE project_id='semantic-core' AND source_ref=source_ref_ref),
       (SELECT status_id FROM statuses WHERE project_id='semantic-core' AND status_code='active')
FROM (VALUES
  ('E-126', 'سه سطح Stop: موفق، نامشخص، ارجاع.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-19-STOP'),
  ('E-127', 'Stop Rule بر اساس اصل کفایت عمل می‌کند.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-19-STOP'),
  ('E-128', 'Measurement یک عدد نیست، روش و نقطه و مرجع هم دارد.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-20-MEASERROR'),
  ('E-129', 'پنج پرسش برای Measurement: کجا، نسبت به چه، چه زمانی، با چه ابزاری، چه کیفیتی.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-20-MEASERROR'),
  ('E-130', 'عدد بدون بافت کافی نیست.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-20-MEASERROR'),
  ('E-131', 'خطای اندازه‌گیری یک فرضیه معتبر است.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-20-MEASERROR'),
  ('E-132', 'سه نوع خطای اندازه‌گیری: ابزار، روش، مرجع.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-20-MEASERROR'),
  ('E-133', 'فرضیه خطای اندازه‌گیری همیشه باز است.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-20-MEASERROR'),
  ('E-134', 'Fault متناوب با شرط وقوع مدل می‌شود.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-21-INTERMITTENT'),
  ('E-135', 'عدم مشاهده خرابی در یک لحظه، آن را رد نمی‌کند.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-21-INTERMITTENT'),
  ('E-136', 'سه ویژگی Fault متناوب: Condition-dependent، تکرار نامنظم، آزمون لحظه‌ای نامناسب.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-21-INTERMITTENT'),
  ('E-137', 'چهار راهکار Test برای Fault متناوب وجود دارد.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-21-INTERMITTENT'),
  ('E-138', 'DTC یک Observation است، نه Cause.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-22-DTC'),
  ('E-139', 'استفاده درست: DTC → Candidate Hypotheses.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-22-DTC'),
  ('E-140', 'استفاده نادرست: DTC → Failed Component.', 'forbidden', 'SCOPE-DIAGNOSTIC', 'DIAG-22-DTC'),
  ('E-141', 'Freeze Frame اطلاعات ارزشمند ارائه می‌دهد.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-22-DTC'),
  ('E-142', 'DTC با Failure Mode متفاوت است.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-22-DTC'),
  ('E-143', 'مدل باید بیش از یک علت را هم‌زمان نگه دارد.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-23-MULTIFAULT'),
  ('E-144', 'Minimal Explanation به معنای همیشه یک علت نیست.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-23-MULTIFAULT'),
  ('E-145', 'سه معیار Minimal Explanation: پوشش، ساختار، شواهد.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-23-MULTIFAULT'),
  ('E-146', 'Decision باید به اندازه شواهد ادعا کند.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-24-DECISION'),
  ('E-147', 'شش سطح بیان وجود دارد.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-24-DECISION'),
  ('E-148', 'Observation، Supported، Strongly Supported، Confirmed، Decision، Unknown/Referral.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-24-DECISION'),
  ('E-149', 'ادعای بزرگ‌تر از شواهد ممنوع است.', 'forbidden', 'SCOPE-DIAGNOSTIC', 'DIAG-24-DECISION'),
  ('E-150', 'Referral یک خروجی معتبر است، نه شکست.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-25-REFERRAL'),
  ('E-151', 'چهار نوع ارجاع: فنی، ایمنی، معرفتی، پیکربندی.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-25-REFERRAL'),
  ('E-152', 'Referral خوب شامل علت، ردها، فضای فعلی، شواهد، آزمون پیشنهادی است.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-25-REFERRAL'),
  ('E-153', 'سه پرسش برای تشخیص نیاز به ارجاع وجود دارد.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-25-REFERRAL'),
  ('E-154', 'Repair یک اقدام تغییردهنده است.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-26-VERIFY'),
  ('E-155', 'Verification بررسی می‌کند آیا رفتار برگشته است.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-26-VERIFY'),
  ('E-156', 'سه سطح Verification: فوری، شرایط مشابه، شرایط متغیر.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-26-VERIFY'),
  ('E-157', 'Verification باید مستقل از Repair باشد.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-26-VERIFY'),
  ('E-158', 'Counterfactual آزمون معکوس‌پذیر است.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-27-COUNTERFACTUAL'),
  ('E-159', 'سه سطح شاهد علّی: Weak، Stronger، Strong.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-27-COUNTERFACTUAL'),
  ('E-160', 'Counterfactual پرخطر نیازمند احتیاط است.', 'rule', 'SCOPE-DIAGNOSTIC', 'DIAG-27-COUNTERFACTUAL')
) AS t(prop_code, proposition, prop_type, scope_code_ref, source_ref_ref)
ON CONFLICT (project_id, prop_code) DO NOTHING;
