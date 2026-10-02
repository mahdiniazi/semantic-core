#!/bin/bash
# reload_vscode.sh — بستن کامل و باز کردن مجدد VS Code
echo "Killing all VS Code processes..."
pkill -f "code" 2>/dev/null
sleep 2
echo "Restarting VS Code with semantic_core..."
code ~/semantic_core &
sleep 3
echo "Done. Look for Cline icon in sidebar."
