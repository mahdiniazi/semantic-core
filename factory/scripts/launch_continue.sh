#!/bin/bash
# launch_continue.sh — راه‌اندازی Continue با MCP
echo "=== 1. Check config ==="
node -e "const c=require(process.env.HOME+'/.continue/config.json');const k=c.models?.[0]?.apiKey;if(!k || k.includes('YOUR_') || k.length<10){console.log('❌ API key نیاز دارد');process.exit(1)}else{console.log('✅ API key set')}"
if [ $? -ne 0 ]; then
  echo ""
  echo "کلید API را نگذاری. راهنما:"
  echo "  cat ~/semantic_core/docs_auto/GET_API_KEY.md"
  echo "  bash ~/semantic_core/factory/scripts/interactive_api_setup.sh"
  exit 1
fi

echo "=== 2. Check MCP server ==="
node --check /home/cs/mcp-servers/pg_mcp_server.js && echo "✅ MCP syntax OK"

echo "=== 3. Check DB ==="
DATABASE_URL='postgresql://monitor_ai:monitor_secure_1405@localhost:5432/project_monitor' node -e "const {Pool}=require('/home/cs/mcp-servers/node_modules/pg');const p=new Pool({connectionString:process.env.DATABASE_URL});p.query('SELECT 1').then(()=>{console.log('✅ DB reachable');return p.end();}).catch(e=>{console.log('❌',e.message);process.exit(1)})"

echo "=== 4. All checks passed — آماده استفاده ==="
echo ""
echo "در VS Code:"
echo "  F1 → Developer: Reload Window"
echo "  F1 → Continue: Focus on Continue View"
