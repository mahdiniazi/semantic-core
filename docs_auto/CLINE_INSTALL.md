# Cline — راهنمای نصب و استفاده

## گام ۱: نصب افزونه
code --install-extension saoudrizwan.claude-dev --force

## گام ۲: Restart کامل VS Code
- بستن همه پنجره‌های VS Code
- یا: Ctrl+Shift+P → "Developer: Reload Window"
- یا در ترمینال: pkill -f "code"

## گام ۳: پیدا کردن Cline
- آیکن Cline در sidebar چپ (شبیه ربات یا آیکن Cline)
- اگر پیدا نکردی: Ctrl+Shift+P → "Cline: Open"
- یا View → Open View → Cline

## گام ۴: تنظیم API Key
- Cline → Settings (چرخ‌دنده) → API Configuration
- یکی از این‌ها:
  - Anthropic API key
  - OpenAI API key
  - OpenRouter API key
  - Ollama (local, رایگان)

## گام ۵: تأیید MCP
- Cline → MCP Servers
- باید ببینی: project-monitor (سبز)
- کلیک → Connect

## تست
در Cline بنویس:
"از ابزار get_project_status استفاده کن"

اگر جواب داد، MCP کار می‌کند.
