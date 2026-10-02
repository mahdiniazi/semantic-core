# Changelog

تمام تغییرات مهم این پروژه در این فایل ثبت می‌شود.

## [v157] — 2026-09-30

### Added
- سلسله‌مراتب زیرشاخه‌های Attribute
- ۵ زیرشاخه: PhysicalQuantity، BaseQuantity، DerivedQuantity، QualitativeProperty، Identifier
- `concept:engine` و اتصالش به `concept:powertrain-system`

### Changed
- `Attribute` از abstract به concrete تغییر کرد
- ۵ نمونه (temperature, voltage, pressure, rpm, humidity) به زیرشاخه درست خود منتقل شدند

## [v156] — 2026-09-30

### Added
- type `Attribute` با ۵ instance اولیه

## [v155] — 2026-09-30

### Added
- اولین State: `state:cold`

## [v154] — 2026-09-30

### Changed
- تغییر نام `has_state` به `has_value`
- ساخت type `Weather` با اولین weather entity

## [v153] — 2026-09-30

### Added
- type `DiagnosticEpisode`
- type `State`
- اولین اپیزود تشخیصی کامل با ۸ participant

## [v152] — 2026-09-30

### Added
- ۶ context در سطح value

## [v151] — 2026-09-30

### Added
- ۴ context در سطح relation برای زنجیره P0301

## [v150] — 2026-09-30

### Added
- ۴ context در سطح entity برای زنجیره P0301

## [v149-v143] — 2026-09-30

### Added
- لایه‌های میانی پروژه (migrationهای متعدد)

## [v141] — 2026-09-30

### Added
- migrationهای میانی

## [v139] — 2026-09-30

### Added
- type `Role` و نقش‌های پایه

## [v100-v138] — 2026-09-30

### Added
- ساخت لایه‌های health، gate، organic placement
- Dashboard و health view

## [v65-v99] — 2026-09-30

### Added
- گسترش کامل دامنه خودرو (همه برندها، همه سیستم‌ها)
- chainها (powertrain, chassis, body, ee)
- روابط inherent و direct-part

## [v27-v64] — 2026-09-29 تا 2026-09-30

### Added
- ساختار اولیه دیتابیس
- Entity، Type، Relation
- Phase 2 تا 5 (Context, Identity, Versioning, Monitor)

## [v1-v26] — 2026-09-29

### Added
- نسخه اولیه schema
- جداول اصلی e01_*
- Triggers و constraints

---

## فرمت نسخه‌گذاری

نسخه‌ها با الگوی `v{شماره}_{توضیح}.sql` نام‌گذاری می‌شوند.
هر migration در `e01_676_01_tb` ثبت می‌شود با تاریخ و توضیح.

---

## [v158] — 2026-10-01

### Added
- **AI_HANDOFF.md** — سند قانون اساسی پروژه (۲۹۱ خط، ۱۲ بخش)
  - راهنمای کامل برای هر AI که روی پروژه کار می‌کند
  - شامل: هدف، فلسفه، معماری، قوانین، خطوط سرخ
  - به‌عنوان «حافظه بلندمدت» در هر گفتگو با AI استفاده می‌شود
- **v158_attribute_expansion.sql** — گسترش لایه ویژگی‌ها
  - ۱۵ ویژگی جدید (BaseQuantity + DerivedQuantity + QualitativeProperty + Identifier)
  - ۲۶ واحد جدید
  - has_unit relation type + ۲ قاعده
  - has_value relation rules
  - concept:engine + اتصال به powertrain-system
  - ۱۶ اتصال has_unit
  - ۳۳ اتصال applies_to

### Changed
- تعداد relations از ۲۱۵۹ به ۲۱۶۰ (افزودن has_direct_part برای engine)


## [v1.0.0] — 2026-10-02

### Added (all phases complete)
- Phase 1-5: all 63 atomic tasks verified
- `verify.sh` — per-task verification runner
- `check_task.sh` — verification rules per task code
- `dashboard.sh` — factory overview
- `report.sh` — customer-facing knowledge-base report
- API server: `products/semantic_core/api/server.py` (localhost:8888)
- Webhook: `products/semantic_core/api/webhook.py` (localhost:8889)
- SQLPage dashboard: `factory/web/dashboard.sql`

### Migrations
- v159: Claim instances + subtypes (3 entities, 3 types)
- v160: Diagnostic engine types (Episode, Verification, Decision + 5 reltypes)

### Task Completion
- 5 phases: زیرساخت، مدل دامنه، حاکمیت دانش، موتور تشخیص، بنیان کسب‌وکار
- 63/63 atomic + 24/24 non-atomic cascade
