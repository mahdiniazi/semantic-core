#!/bin/bash
# continue_readiness.sh — آماده‌سازی نهایی Continue
echo "=== Continue Readiness Check ==="
echo ""
# 1. Extension
if code --list-extensions 2>/dev/null | grep -q continue; then
  echo "✅ Continue extension installed"
else
  echo "❌ Continue not installed"
  exit 1
fi

# 2. API key
API_OK=$(node -e "try{const c=require(process.env.HOME+'/.continue/config.json');const k=c.models?.[0]?.apiKey;console.log(k && !k.includes('YOUR_') && k.length>10 ? 'yes':'no')}catch(e){console.log('no')}")
if [ "$API_OK" = "yes" ]; then
  echo "✅ API key set"
else
  echo "⚠️  API key NOT set — گام بعدی:"
  echo "    bash ~/semantic_core/factory/scripts/interactive_api_setup.sh"
fi

# 3. MCP
if grep -q "project-monitor" ~/.continue/config.json 2>/dev/null; then
  echo "✅ MCP project-monitor configured"
else
  echo "❌ MCP missing in config"
fi

# 4. MCP server
if [ -f /home/cs/mcp-servers/pg_mcp_server.js ]; then
  echo "✅ MCP server exists"
else
  echo "❌ MCP server missing"
fi

echo ""
echo "=== Next Steps ==="
if [ "$API_OK" != "yes" ]; then
  echo "1. API key را بگذار (interactive_api_setup.sh)"
fi
echo "2. VS Code: F1 → Developer: Reload Window"
echo "3. VS Code: F1 → Continue: Focus on Continue View"
echo "4. در Continue: get_project_status را تست کن"
