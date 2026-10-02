#!/bin/bash
# widgets.sh — معرفی ویجت‌ها در ابتدای هر گفتگو
echo "═══ ویجت‌های فعال کارخانه ═══"
echo "دسترسی: http://localhost:8080"
echo ""
psql -U monitor_ai -d project_monitor -h localhost -A -F' | ' -c "SELECT category, title, url_path FROM widget_registry WHERE is_active=true ORDER BY category, slug"
echo ""
echo "پیشنهاد: هر گفتگو با /clues.sql شروع شود"
