#!/bin/bash
# search.sh — جستجو در گزاره‌های اتمی
# استفاده:
#   ./scripts/search.sh "کلمه"              — جستجوی متنی
#   ./scripts/search.sh --code C-033        — جستجو با کد
#   ./scripts/search.sh --type rule         — فیلتر بر اساس نوع
#   ./scripts/search.sh --source constitution — فیلتر بر اساس منبع
#   ./scripts/search.sh --scope DIAGNOSTIC  — فیلتر بر اساس دامنه
#   ./scripts/search.sh --status draft      — فیلتر بر اساس وضعیت

set -e

DB="project_monitor"
USER="monitor_ai"
HOST="localhost"
PROJECT="semantic-core"

KEYWORD=""
CODE=""
TYPE=""
SOURCE=""
SCOPE=""
STATUS=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --code)   CODE="$2"; shift 2 ;;
    --type)   TYPE="$2"; shift 2 ;;
    --source) SOURCE="$2"; shift 2 ;;
    --scope)  SCOPE="$2"; shift 2 ;;
    --status) STATUS="$2"; shift 2 ;;
    --help|-h)
      echo "استفاده: $0 [گزینه‌ها] [کلمه جستجو]"
      echo ""
      echo "گزینه‌ها:"
      echo "  --code CODE      جستجو با کد گزاره"
      echo "  --type TYPE      فیلتر نوع (rule/fact/requirement/forbidden)"
      echo "  --source SRC     فیلتر منبع (constitution/domain_model/...)"
      echo "  --scope SCODE    فیلتر دامنه (SCOPE-GENERAL/SCOPE-DIAGNOSTIC/...)"
      echo "  --status ST      فیلتر وضعیت (draft/active/verified)"
      echo "  --help           این راهنما"
      echo ""
      echo "مثال:"
      echo "  $0 Attribute"
      echo "  $0 --code C-033"
      echo "  $0 --type rule --source constitution"
      exit 0
      ;;
    *)  KEYWORD="$1"; shift ;;
  esac
done

WHERE="WHERE ap.project_id = '$PROJECT'"
[[ -n "$CODE" ]] && WHERE="$WHERE AND ap.prop_code = '$CODE'"
[[ -n "$TYPE" ]] && WHERE="$WHERE AND ap.prop_type = '$TYPE'"
[[ -n "$SOURCE" ]] && WHERE="$WHERE AND s.source_type = '$SOURCE'"
[[ -n "$SCOPE" ]] && WHERE="$WHERE AND sc.scope_code = '$SCOPE'"
[[ -n "$STATUS" ]] && WHERE="$WHERE AND st.status_code = '$STATUS'"
[[ -n "$KEYWORD" ]] && WHERE="$WHERE AND ap.proposition ILIKE '%$KEYWORD%'"

psql -U "$USER" -d "$DB" -h "$HOST" -P pager=off -c "
SELECT
    ap.prop_code AS کد,
    ap.prop_type AS نوع,
    COALESCE(s.source_type, '-') AS منبع,
    COALESCE(sc.scope_code, '-') AS دامنه,
    COALESCE(st.status_code, '-') AS وضعیت,
    ap.proposition AS گزاره
FROM atomic_propositions ap
LEFT JOIN sources s ON ap.source_id = s.source_id
LEFT JOIN scopes sc ON ap.scope_id = sc.scope_id
LEFT JOIN statuses st ON ap.status_id = st.status_id
$WHERE
ORDER BY ap.prop_code
LIMIT 50;
"
