# VS Code MCP Setup — راهنمای قطعی

## گام ۱: بستن کامل VS Code
pkill -9 -f code
sleep 3
pgrep -f code | wc -l    # باید 0 باشد

## گام ۲: باز کردن مجدد
code ~/semantic_core

## گام ۳: صبر (10 ثانیه)
Extension host باید Cline را لود کند

## گام ۴: نگاه به sidebar
- آیکن Cline: شکل ربات یا حرف C
- اگر نبود: Ctrl+Shift+P → "Cline"

## گام ۵: اگر باز هم نبود — Continue
- Ctrl+Shift+P → "Continue"
- یا: آیکن Continue در sidebar

## گام ۶: تنظیم API
- Cline یا Continue → Settings
- API key بگذار (Anthropic, OpenRouter, Ollama)

## گام ۷: تأیید MCP
- MCP Servers tab
- project-monitor باید سبز باشد

## تست
از AI داخل Cline/Continue بپرس:
"get_project_status را صدا بزن"
