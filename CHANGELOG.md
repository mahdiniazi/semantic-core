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
