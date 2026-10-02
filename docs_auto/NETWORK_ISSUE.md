# مشکل شبکه — تشخیص

## چه اتفاقی افتاد؟
لپ‌تاپ به این سرورها دسترسی ندارد:
- marketplace.visualstudio.com
- rooveterinaryinc.gallerycdn.vsassets.io

## پیامدها
- Cline قابل نصب مجدد نیست
- Roo Cline قابل نصب نیست
- هیچ افزونه جدیدی قابل نصب نیست

## چه چیزی کار می‌کند
- Continue.continue (نصب شده قبل از قطعی)
- GitLens, Prettier, Python, ESLint
- همه افزونه‌های نصب‌شده قبلی

## راه‌حل‌ها
### کوتاه‌مدت
از Continue استفاده کن — کامل کار می‌کند

### میان‌مدت
شبکه را بررسی کن:
- DNS: cat /etc/resolv.conf
- VPN
- Proxy

### بلندمدت
افزونه‌ها را به‌صورت دستی نصب کن:
- vsix را دانلود کن از یک سیستم دیگر
- code --install-extension /path/to/file.vsix
