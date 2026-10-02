# چرا Cline فعال نمی‌شود؟

## حقایق تأیید شده
- نصب: v4.1.22 (و اکنون v3.3.17)
- eng: ^1.101.0 (VS Code 1.139.1 پشتیبانی می‌کند)
- Extension host: فعال
- GitLens, Prettier, spell-checker: فعال شدند
- **Cline: در event `onStartupFinished` ظاهر نشد**

## معنی
Cline در `activationEvents` ثبت شده ولی در حین activation crash کرده.

## دلایل ممکن
1. ناسازگاری build Linux Mint 21.3
2. Crash در Node module native
3. problem با شبکه (تلاش برای fetch اولیه)
4. VS Code cache corruption

## راه‌حل‌های امتحان شده
- [x] Restart کامل
- [x] نصب مجدد 4.1.22
- [x] نسخه 3.3.17 (قدیمی‌تر، پایدارتر)

## اگر باز هم کار نکرد
- Continue.continue را به‌عنوان جایگزین استفاده کن
- Roo Cline (fork پایدارتر) امتحان کن
- VS Code Insiders امتحان کن

## آپدیت VS Code؟
❌ کمکی نمی‌کند — نسخه فعلی سازگار است.
