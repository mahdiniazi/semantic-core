#!/bin/bash
# try_continue_mcp.sh — راه‌اندازی Continue به‌عنوان MCP client اصلی
echo "=== 1. Check Continue installed ==="
code --list-extensions 2>/dev/null | grep -i continue || echo "not installed"

echo ""
echo "=== 2. Continue config ==="
cat ~/.continue/config.json 2>/dev/null | head -20

echo ""
echo "=== 3. MCP servers configured ==="
node -e "try{const c=require(process.env.HOME+'/.continue/config.json');console.log('MCP:',Object.keys(c.mcpServers||{}).join(', '))}catch(e){console.log('error:',e.message)}"

echo ""
echo "=== 4. Next steps ==="
echo "1. API key را در config.json بگذار"
echo "2. Ctrl+Shift+P → Developer: Reload Window"
echo "   (یا F1 اگر Ctrl+Shift مشکل دارد)"
echo "3. F1 → Continue: Focus on Continue View"
