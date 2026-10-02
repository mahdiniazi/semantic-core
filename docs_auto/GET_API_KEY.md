# گرفتن API Key برای Continue

## گزینه ۱ — OpenRouter (پیشنهاد می‌شود)
**مزایا:** ارزان‌تر، چند مدل (Claude، GPT، Llama)، پرداخت به‌ازای مصرف
**گام‌ها:**
1. برو به https://openrouter.ai
2. Sign up با Google
3. برو به Keys → Create Key
4. کپی کن (شکل: sk-or-v1-...)
5. حداقل ۵ دلار شارژ کن (برای شروع)
6. مدل پیشنهادی: anthropic/claude-3.5-sonnet

## گزینه ۲ — Anthropic (بهترین کیفیت)
**مزایا:** مستقیم از Claude، بهترین کیفیت
**گام‌ها:**
1. برو به https://console.anthropic.com
2. Sign up
3. برو به API Keys → Create Key
4. کپی کن (شکل: sk-ant-...)
5. حداقل ۵ دلار شارژ کن

## گزینه ۳ — OpenAI
**گام‌ها:**
1. برو به https://platform.openai.com
2. Sign up
3. API Keys → Create
4. کپی کن (شکل: sk-...)
5. حداقل ۵ دلار شارژ کن

## گزینه ۴ — Ollama (رایگان، local)
```bash
curl https://ollama.ai/install.sh | sh
ollama pull llama3.2
bash ~/semantic_core/factory/scripts/setup_continue.sh

### دستور ۱۰
```bash
cat ~/semantic_core/docs_auto/GET_API_KEY.md | head -20
echo "=== OpenRouter در دسترس است ==="
curl -s --max-time 5 https://openrouter.ai/api/v1/models | node -e "let d='';process.stdin.on('data',c=>d+=c);process.stdin.on('end',()=>{try{const j=JSON.parse(d);console.log('Total models:',j.data?.length||0);console.log('Sample:',j.data?.slice(0,3).map(m=>m.id).join(', '))}catch(e){console.log('parse error')}})"
cat > ~/semantic_core/factory/scripts/interactive_api_setup.sh << 'XEOF'
#!/bin/bash
# interactive_api_setup.sh — راه‌اندازی تعاملی API key
echo "═══════════════════════════════════════════════════════"
echo "  Continue API Key Setup"
echo "═══════════════════════════════════════════════════════"
echo ""
echo "کدام provider؟"
echo ""
echo "1) OpenRouter (ارزان، چند مدل)      — https://openrouter.ai"
echo "2) Anthropic (بهترین کیفیت)          — https://console.anthropic.com"
echo "3) OpenAI (GPT)                       — https://platform.openai.com"
echo "4) Ollama (رایگان، local)"
echo "5) لغو"
echo ""
read -p "شماره [1-5]: " choice

case $choice in
  1)
    PROVIDER="openrouter"
    MODEL="anthropic/claude-3.5-sonnet"
    URL="https://openrouter.ai/keys"
    ;;
  2)
    PROVIDER="anthropic"
    MODEL="claude-3-5-sonnet-latest"
    URL="https://console.anthropic.com/settings/keys"
    ;;
  3)
    PROVIDER="openai"
    MODEL="gpt-4o"
    URL="https://platform.openai.com/api-keys"
    ;;
  4)
    PROVIDER="ollama"
    MODEL="llama3.2"
    URL="(local — نیاز به ollama install)"
    ;;
  *)
    echo "لغو شد"
    exit 0
    ;;
esac

echo ""
echo "برو به: $URL"
echo "کلید API خود را اینجا پیست کن:"
read -p "API Key: " APIKEY

if [ -z "$APIKEY" ] && [ "$PROVIDER" != "ollama" ]; then
  echo "❌ کلید وارد نشد"
  exit 1
fi

cat > ~/.continue/config.json << EOF
{
  "models": [
    {
      "title": "$MODEL",
      "provider": "$PROVIDER",
      "model": "$MODEL",
      "apiKey": "$APIKEY"
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
echo "✅ ذخیره شد"
echo ""
echo "Provider: $PROVIDER"
echo "Model: $MODEL"
echo ""
echo "گام‌های بعدی:"
echo "1. در VS Code: F1 → Developer: Reload Window"
echo "2. F1 → Continue: Focus on Continue View"
echo "3. Continue → Settings → MCP Servers → Connect project-monitor"
