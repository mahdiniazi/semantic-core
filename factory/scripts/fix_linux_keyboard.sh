#!/bin/bash
# رفع تداخل Ctrl+Shift با تغییر زبان
echo "=== Backup ==="
mkdir -p ~/semantic_core/factory/backups/gsettings
gsettings get org.gnome.desktop.wm.keybindings switch-input-source > ~/semantic_core/factory/backups/gsettings/sis.bak 2>/dev/null
gsettings get org.gnome.desktop.wm.keybindings switch-input-source-backward > ~/semantic_core/factory/backups/gsettings/sisb.bak 2>/dev/null

echo "=== Current ==="
gsettings get org.gnome.desktop.wm.keybindings switch-input-source 2>/dev/null
gsettings get org.gnome.desktop.wm.keybindings switch-input-source-backward 2>/dev/null

echo "=== Using Super+Space (safe for VS Code) ==="
gsettings set org.gnome.desktop.wm.keybindings switch-input-source "['<Super>space']" 2>/dev/null
gsettings set org.gnome.desktop.wm.keybindings switch-input-source-backward "['<Shift><Super>space']" 2>/dev/null

echo "=== Done — Ctrl+Shift+P now works in VS Code ==="
echo "برای تغییر زبان از Super+Space استفاده کن"
