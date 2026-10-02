#!/bin/bash
D=~/semantic_core/factory/backups/daily
mkdir -p "$D"
pg_dump -U monitor_ai -h localhost project_monitor > "$D/pm_$(date +%Y%m%d_%H%M).sql"
find "$D" -name "pm_*.sql" -mtime +7 -delete
echo "backup done: $(date '+%Y-%m-%d %H:%M')"
