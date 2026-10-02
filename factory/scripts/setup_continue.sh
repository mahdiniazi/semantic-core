#!/bin/bash
# setup_continue.sh — راه‌اندازی Continue با پرسش از کاربر
echo "═══════════════════════════════════════════════════════"
echo "  Continue.continue — راه‌اندازی"
echo "═══════════════════════════════════════════════════════"
echo ""
echo "کدام provider را می‌خواهی؟"
echo ""
echo "1) Anthropic Claude (بهترین، پول لازم)"
echo "2) OpenRouter (چند مدل، ارزان)"
echo "3) OpenAI GPT"
echo "4) Ollama (رایگان، local — اگر نصب است)"
echo ""
read -p "انتخاب [1-4]: " choice
read -p "API key (یا Enter برای local): " apikey

case $choice in
  1) PROVIDER="anthropic"; MODEL="claude-3-5-sonnet-latest" ;;
  2) PROVIDER="openrouter"; MODEL="anthropic/claude-3.5-sonnet" ;;
  3) PROVIDER="openai"; MODEL="gpt-4o" ;;
  4) PROVIDER="ollama"; MODEL="llama3.2" ;;
  *) echo "invalid"; exit 1 ;;
esac

cat > ~/.continue/config.json << EOF
{
  "models": [
    {
      "title": "$MODEL",
      "provider": "$PROVIDER",
      "model": "$MODEL",
      "apiKey": "$apikey"
    }
  ],
  "mcpServers": {
    "project-monitor": {
      "command": "node",
      "args": ["/home/cs/mcp-servers/pg_mcp_server.js"],
      "env": {
        "DATABASE_URL": "postgresql://monitor_ai:monitor_secure_1405@localhost:5432/project_monitor"
      }
    }
  },
  "allowAnonymousTelemetry": false
}
EOF

echo ""
echo "✅ Config ذخیره شد"
cat ~/.continue/config.json
echo ""
echo "حالا:"
echo "1. VS Code را reload کن (F1 → Developer: Reload Window)"
echo "2. F1 → Continue: Focus on Continue View"
