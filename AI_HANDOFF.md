# AI Handoff — راهنمای همکاری با عوامل هوشمند

این فایل برای هر AI (Claude, ChatGPT, Gemini, Cursor, …) نوشته شده
که می‌خواهد روی این پروژه کار کند. اگر تو یک AI هستی و این فایل را
می‌خوانی، **قبل از هر تغییری، تمام این سند را بخوان**.

---

## ۱. پروژه چیست

یک **پایگاه دانش معنایی (semantic knowledge base)** برای دامنه برق
و الکترونیک خودرو. بنا شده بر پنج سند راهبردی در `docs/strategic/`.

هدف بلندمدت: ساخت یک سامانه تشخیص برق خودرو با استدلال قابل بازسازی.

---

## ۲. ساختار پروژه

\`\`\`
~/semantic_core/
├── db/
│   └── semantic_core.db          ← دیتابیس اصلی (SQLite) — در Git نیست
├── migrations/                   ← اسکریپت‌های تغییر دیتابیس
│   ├── 00_initial/               ← اسکریپت‌های ساخت اولیه (v1-v26)
│   ├── old/                      ← تاریخچه (v27-v64) — دست نزن
│   └── vNNN_*.sql                ← migrationهای مدرن (v65 به بعد)
├── scripts/
│   ├── backup.sh                 ← بکاپ خودکار با بررسی سلامت
│   ├── migrate.sh                ← اجرای migration + بکاپ خودکار
│   ├── audit.sh                  ← بازرسی دیتابیس
│   └── run.sh                    ← اجرای سریع
├── docs/
│   ├── strategic/                ← ۵ سند راهبردی (مرجع اصلی)
│   ├── audits/                   ← گزارش‌های تحلیل
│   └── logs/                     ← لاگ‌های قدیمی
├── backups/                      ← بکاپ‌ها — در Git نیست
├── snapshots/                    ← آرشیوها — در Git نیست
├── README.md
├── CHANGELOG.md
├── AI_HANDOFF.md                 ← همین فایل
└── .gitignore
\`\`\`

---

## ۳. قوانین طلایی

### قانون ۱ — هر تغییر = یک migration
هر تغییری در دیتابیس باید در یک فایل جدید `migrations/vNNN_*.sql` ثبت شود.
**هرگز دیتابیس را مستقیم ویرایش نکن.**

### قانون ۲ — migration باید idempotent باشد
از `INSERT OR IGNORE` یا `WHERE NOT EXISTS` استفاده کن.
اجرای مکرر یک migration نباید خطا بدهد یا داده تکراری بسازد.

### قانون ۳ — migration باید خودش را ثبت کند
در انتهای هر migration:
\`\`\`sql
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('vNNN_description', 'توضیح فارسی کوتاه');
\`\`\`

### قانون ۴ — قبل از هر تغییر، بکاپ
از \`./scripts/migrate.sh migrations/vNNN.sql\` استفاده کن.
این اسکریپت خودش قبل از اجرا بکاپ می‌گیرد.

### قانون ۵ — شماره migration بعدی
آخرین migration را ببین:
\`\`\`sql
SELECT migration_uid FROM e01_676_01_tb ORDER BY applied_at DESC LIMIT 1;
\`\`\`
شماره بعدی = آخرین + ۱.

### قانون ۶ — محل فایل‌ها
| چه چیزی | کجا |
|---|---|
| migration جدید | \`migrations/vNNN_*.sql\` |
| اسکریپت shell | \`scripts/*.sh\` |
| سند راهبردی | \`docs/strategic/*.html\` |
| گزارش تحلیل | \`docs/audits/\` |
| بکاپ | \`backups/manual/\` (نه در Git) |

---

## ۴. الگوهای نام‌گذاری

### Migration
\`\`\`
vNNN_توضیح_کوتاه_با_زیرخط.sql
\`\`\`
مثال: \`v158_attribute_expansion.sql\`

### Entity (ent_uid)
| نوع | پیشوند | مثال |
|---|---|---|
| مفهوم | \`concept:\` | \`concept:engine\` |
| ویژگی | \`attribute:\` | \`attribute:temperature\` |
| واحد | \`unit:\` | \`unit:celsius\` |
| نقش | \`role:\` | \`role:switch\` |
| وضعیت | \`state:\` | \`state:cold\` |
| اندازه‌گیری | \`measurement:\` | \`measurement:battery-12v\` |
| اپیزود | \`episode:\` | \`episode:p0301-2026\` |

### Relation (rel_uid)
\`\`\`
r:{relationtype}-{subject}-{object}
\`\`\`
مثال: \`r:applies-temperature-engine\`

---

## ۵. جدول‌های اصلی دیتابیس

| جدول | نقش |
|---|---|
| \`e01_200_01_tb\` | types (سلسله‌مراتبی با parent_id) |
| \`e01_200_03_tb\` | entities (nature: concept یا instance) |
| \`e01_202_01_tb\` | relation types (schema) |
| \`e01_222_01_tb\` | relations (instances) |
| \`e01_112_01_tb\` | allowed subject/object types |
| \`e01_303_01_tb\` | provenance (منبع/شاهد) |
| \`e01_305_01_tb\` | entity contexts |
| \`e01_330_01_tb\` | versions |
| \`e01_676_01_tb\` | **migration log** |
| \`e01_676_03_tb\` | system parameters (مثل max_depth) |

---

## ۶. تریگرهای مهم (قبل از insert حتماً بدان)

- \`e03_120_04_tr\` روی entity INSERT: اگر \`nature='instance'\` و type **abstract** → ABORT
- \`e03_120_05_tr\` روی entity UPDATE: همین چک
- \`e03_320_*\` روی DELETE: چک می‌کند ارجاع دارد یا نه
- \`e03_120_02_tr\` روی type INSERT: closure table را پر می‌کند
- \`e03_434_01_tr\` روی entity INSERT: FTS را پر می‌کند
- \`e03_200_04_auto_place\` روی entity INSERT برای concept: جای‌گذاری خودکار

---

## ۷. گردش کار روزمره

\`\`\`bash
# ۱. رفتن به پروژه
cd ~/semantic_core

# ۲. ساخت migration جدید در migrations/vNNN_*.sql

# ۳. اجرا (خودش بکاپ می‌گیرد)
./scripts/migrate.sh migrations/vNNN_*.sql

# ۴. تأیید آمار
sqlite3 db/semantic_core.db "SELECT COUNT(*) FROM e01_200_03_tb;"

# ۵. ثبت در Git
git add migrations/vNNN_*.sql
git commit -m "vNNN: توضیح کوتاه"
git push
\`\`\`

---

## ۸. خطوط سرخ — هرگز این کارها را نکن

- ❌ دیتابیس را مستقیم با \`sqlite3 edit\` تغییر نده — همیشه از migration
- ❌ فایل‌های \`migrations/old/\` را تغییر نده یا rename نکن (تاریخچه)
- ❌ \`db/semantic_core.db\` را در Git commit نکن (در .gitignore)
- ❌ بکاپ‌ها و snapshotها را در Git پوش نکن
- ❌ migration را بدون ثبت در \`e01_676_01_tb\` تمام نکن
- ❌ بدون بکاپ، migration را اجرا نکن
- ❌ رکورد را بدون بررسی ارجاعات حذف نکن
- ❌ type انتزاعی (abstract) را بدون اطلاع تغییر نده
- ❌ درخت type hierarchy را بدون توجه به closure table تغییر نده
- ❌ فایل‌های \`migrations/00_initial/\` را دست نزن

---

## ۹. وضعیت فعلی پروژه

| مورد | مقدار |
|---|---|
| آخرین migration | \`v157_attribute_hierarchy\` |
| migration بعدی | \`v158\` |
| type | 517 |
| entity | 1176 |
| relation | 2159 |
| attribute | 20 |
| unit | 26 |

---

## ۱۰. اسناد راهبردی مرجع

پنج سند در \`docs/strategic/\` — قبل از هر کار مهم، این‌ها را بخوان:

1. \`01_constitution.html\` — قانون اساسی (v5.0) — لایه حاکم
2. \`02_domain_model.html\` — مدل دامنه (v2.0) — هستی‌شناسی
3. \`03_knowledge_governance.html\` — حاکمیت دانش (v2.0) — پذیرش و نسخه
4. \`04_diagnostic_model.html\` — مدل تشخیص (v2.0) — استدلال
5. \`05_business_plan.html\` — کسب‌وکار (v2.0) — راهبردی

---

## ۱۱. اطلاعات مرتبط

- مخزن GitHub: \`github.com/mahdiniazi/semantic-core\`
- شاخه اصلی: \`main\`
- کاربر: \`mahdi niazi\`
- ایمیل: \`mahdiniazi@users.noreply.github.com\`

---

## ۱۲. اگر سؤالی داری

اگر به عنوان AI، چیزی در این سند نامشخص بود، **قبل از اجرای هر دستوری**
از کاربر بپرس. هرگز حدس نزن. تغییر اشتباه در دیتابیس، ممکن است
باعث از دست رفتن داده شود.

**قاعده نهایی:** «اگر شک داری، بپرس. اگر بکاپ نیست، بساز. اگر migration نیست، بساز.»
