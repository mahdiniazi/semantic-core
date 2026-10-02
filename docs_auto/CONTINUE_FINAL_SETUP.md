# Continue.continue — راه‌اندازی نهایی

## چرا Continue؟
- ✅ نصب است
- ✅ MCP را کامل پشتیبانی می‌کند
- ✅ config آماده در ~/.continue/config.json
- ❌ Cline روی این لپ‌تاپ کار نمی‌کند (شبکه)

## ۳ گام
### ۱. API Key
انتخاب یکی:
- Anthropic: https://console.anthropic.com
- OpenRouter: https://openrouter.ai
- Ollama (local): بدون کلید

جایگزین در ~/.continue/config.json در فیلد apiKey.

### ۲. VS Code را reload
F1 → Developer: Reload Window

### ۳. Continue را باز کن
F1 → Continue: Focus on Continue View

## تست MCP
در Continue بنویس:
"از ابزار get_project_status استفاده کن"

## اگر Continue هم ندیدی
- Ctrl+Shift+X → جستجو: Continue
- اگر Disable → فعال کن
- اگر Enable → VS Code را reload کن

## Config فعلی
~/.continue/config.json
{
  "models": [...],
  "mcpServers": {
    "project-monitor": { ... }
  }
}

## 10 ابزار MCP
get_project_status, get_clues, get_feedback, get_handoff,
get_integrity, get_tasks, get_widgets, get_roadmap,
get_propositions, run_safe_query
