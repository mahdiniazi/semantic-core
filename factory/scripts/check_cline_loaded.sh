#!/bin/bash
echo "=== Cline Loading Check ==="
echo ""
echo "1. Extension files:"
ls -la ~/.vscode/extensions/saoudrizwan.claude-dev-4.1.22/dist/extension.js 2>/dev/null || echo "  MISSING"
echo ""
echo "2. Extension registered:"
node -e "const d=require('/home/cs/.vscode/extensions/extensions.json');const c=d.find(e=>/claude-dev/.test(e.identifier?.id||''));console.log('  Found:', c ? 'YES v'+c.version : 'NO')"
echo ""
echo "3. VS Code running:"
pgrep -f "code" | wc -l
echo ""
echo "4. Extension host process:"
ps aux | grep -i "extensionHost" | grep -v grep | wc -l
echo ""
echo "5. Recent ext host logs:"
LOG=$(ls -td ~/.config/Code/logs/*/ 2>/dev/null | head -1)
tail -3 "$LOG"/exthost.log 2>/dev/null || echo "  no exthost.log"
echo ""
echo "=== Expected ==="
echo "1. SHOULD show file exists"
echo "2. SHOULD show YES v4.1.22"
echo "3. SHOULD be > 5"
echo "4. SHOULD be >= 1"
