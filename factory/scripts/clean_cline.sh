#!/bin/bash
# clean_cline.sh — پاک‌سازی کامل Cline و نصب مجدد
echo "=== 1. Kill VS Code ==="
pkill -9 -f "code" 2>/dev/null
sleep 3

echo "=== 2. Uninstall Cline ==="
code --uninstall-extension saoudrizwan.claude-dev 2>/dev/null
sleep 2

echo "=== 3. Remove extension files ==="
rm -rf ~/.vscode/extensions/saoudrizwan.claude-dev-* 2>/dev/null
rm -rf ~/.config/Code/User/globalStorage/saoudrizwan.claude-dev 2>/dev/null

echo "=== 4. Verify cleaned ==="
ls ~/.vscode/extensions/ | grep -i claude || echo "✓ cleaned"

echo "=== 5. Install stable version 3.3.17 ==="
code --install-extension saoudrizwan.claude-dev@3.3.17 2>&1 | tail -3

echo "=== 6. Restart VS Code ==="
nohup code ~/semantic_core >/dev/null 2>&1 &
sleep 12

echo "=== 7. Result ==="
node -e "const d=require('/home/cs/.vscode/extensions/extensions.json');const c=d.find(e=>/claude-dev/.test(e.identifier?.id||''));console.log(c?('Installed: v'+c.version):'FAILED')"
