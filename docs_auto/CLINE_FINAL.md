# Cline — راهنمای قطعی

## حقایق تأیید شده
- نصب: saoudrizwan.claude-dev-4.1.22
- سازگاری: VS Code ^1.101.0 (ما: 1.139.1) ✅
- 19 command فعال
- viewContainer: claude-dev-ActivityBar

## چرا اول ندیدی؟
VS Code قبل از نصب Cline باز بود. Extension host آن را لود نکرد.
حالا که restart کردی، باید ببینی.

## دسترسی سریع
### راه ۱: F1
F1 → تایپ: Cline
→ لیست 19 command ظاهر می‌شود
→ "Cline: Open in New Tab" را انتخاب کن

### راه ۲: نوار کناری
نگاه به sidebar چپ → آیکن ربات (Cline)
اگر نبود → راست‌کلیک روی نوار → Customize Activity Bar

### راه ۳: منو
View → Open View → Cline

## بعد از باز شدن
1. Settings (چرخ‌دنده) → API Key
   - Anthropic / OpenAI / OpenRouter / Ollama
2. MCP Servers tab
3. project-monitor → Connect
4. تست: "get_project_status"

## میان‌بر زبان
Ctrl+Shift ممکن است در Linux Mint زبان را عوض کند.
جایگزین: F1 (بدون تضاد)
یا: gsettings set org.gnome.desktop.wm.keybindings switch-input-source "[]"
