# 🚀 START HERE — برای AI جدید

اگر تازه به این پروژه آمده‌ای، این ۵ دستور را اجرا کن:

1. bash ~/semantic_core/factory/scripts/welcome.sh
2. cat ~/semantic_core/factory/AI_HANDOFF.md
3. bash ~/semantic_core/factory/scripts/handoff.sh
4. psql -U monitor_ai -d project_monitor -h localhost -c "SELECT * FROM v_clues_open"
5. باز کن: http://localhost:8080/clues.sql

بعد از این ۵ گام، کامل می‌دانی کجایی و چه باید بکنی.

## 🔌 MCP Server (نسخه 2.0)
اگر از Claude Desktop یا Cursor استفاده می‌کنی:
- 10 ابزار خودکار: docs_auto/MCP_TOOLS.md
- وضعیت: docs_auto/MCP_STATUS.md
- تست: bash ~/semantic_core/factory/scripts/test_mcp.sh

## 🖥️ راه‌اندازی MCP در VS Code
1. `code --install-extension saoudrizwan.claude-dev --force`
2. `code ~/semantic_core`
3. Cline sidebar → MCP Servers → project-monitor
4. docs_auto/VSCODE_SETUP.md برای جزئیات

## 🚀 MCP Client — Continue (توصیه‌شده)
1. API key بگیر: cat docs_auto/GET_API_KEY.md
2. راه‌اندازی: bash factory/scripts/setup_continue.sh
3. در VS Code: F1 → Continue: Focus on Continue View
4. رفع مشکل: docs_auto/CONTINUE_FINAL_SETUP.md
