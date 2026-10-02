#!/bin/bash
# doc_generator.sh — تولید README نسخه‌دار برای هر سطح
PG="psql -U monitor_ai -d project_monitor -h localhost -tAc"
VERSION="${1:-v1.4.0}"
TOP=~/semantic_core/docs_auto
mkdir -p "$TOP/factory" "$TOP/products/semantic-core" "$TOP/products/workshop-manager"

# Top-level README
{
  echo "# Semantic Core Workspace — $VERSION"
  echo ""
  echo "تولید خودکار: $(date '+%Y-%m-%d %H:%M')"
  echo ""
  echo "## پروژه‌ها"
  psql -U monitor_ai -d project_monitor -h localhost -A -F' | ' -c "SELECT project_id, display_name FROM projects WHERE enabled=true"
  echo ""
  echo "## وضعیت"
  psql -U monitor_ai -d project_monitor -h localhost -A -F' | ' -c "SELECT * FROM v_project_progress"
} > "$TOP/README.md"

# Factory README
{
  echo "# Factory — $VERSION"
  echo "نسخه: $VERSION | $(date '+%Y-%m-%d %H:%M')"
  echo ""
  echo "## جداول"
  psql -U monitor_ai -d project_monitor -h localhost -A -F' | ' -c "SELECT table_name FROM information_schema.tables WHERE table_schema='public' ORDER BY table_name"
} > "$TOP/factory/README.md"

# Products
for P in semantic-core workshop-manager; do
  DIR=$TOP/products/$P
  {
    echo "# $P — $VERSION"
    echo "نسخه: $VERSION | $(date '+%Y-%m-%d %H:%M')"
    echo ""
    echo "## پیشرفت"
    psql -U monitor_ai -d project_monitor -h localhost -A -F' | ' -c "SELECT * FROM v_project_progress WHERE project_id='$P'"
  } > "$DIR/README.md"
done

echo "Docs generated at $TOP"
find "$TOP" -name "README.md" -exec wc -l {} \;
