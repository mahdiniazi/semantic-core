#!/bin/bash
# kill_vscode.sh — بستن کامل VS Code
echo "Killing all VS Code processes..."
pkill -9 -f "code" 2>/dev/null
sleep 3
COUNT=$(pgrep -f "code" | wc -l)
echo "Remaining VS Code processes: $COUNT"
if [ "$COUNT" = "0" ]; then
  echo "✅ All killed. Run: code ~/semantic_core"
fi
