# Cline Troubleshooting — چرا آیکن دیده نمی‌شود؟

## علت اصلی
VS Code قبل از نصب Cline اجرا شده بود. Extension host آن را لود نکرده.

## راه‌حل ۱: Restart کامل
pkill -9 -f code
sleep 3
code ~/semantic_core

## راه‌حل ۲: Command Palette
Ctrl+Shift+P
تایپ: Cline: Focus on Cline View
یا: Cline: Open in New Tab

## راه‌حل ۳: از منوی More
- نگاه کن به نوار کناری چپ
- اگر آیکن‌ها با ... بسته شده‌اند
- راست‌کلیک روی نوار → "Customize Activity Bar"
- Cline را فعال کن

## راه‌حل ۴: Use Continue instead
اگر Cline کار نکرد، Continue نصب است:
- Ctrl+Shift+P → "Continue: Focus on Continue"
- Config: ~/.continue/config.json
- MCP config هم گرفته

## راه‌حل ۵: Developer Console
Help → Toggle Developer Tools
Console را ببین — خطای extension host را می‌بینی
