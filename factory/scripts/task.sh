#!/bin/bash
set -e
ACTION="$1"
CODE="$2"
TEXT="$3"
TYPE="${4:-rule}"

case "$ACTION" in
  done)
    psql -U monitor_ai -d project_monitor -h localhost -c "UPDATE atomic_propositions SET status_id = (SELECT status_id FROM statuses WHERE project_id='semantic-core' AND status_code='verified') WHERE project_id='semantic-core' AND prop_code='$CODE';"
    echo "✅ $CODE → verified"
    ;;
  active)
    psql -U monitor_ai -d project_monitor -h localhost -c "UPDATE atomic_propositions SET status_id = (SELECT status_id FROM statuses WHERE project_id='semantic-core' AND status_code='active') WHERE project_id='semantic-core' AND prop_code='$CODE';"
    echo "✅ $CODE → active"
    ;;
  add)
    psql -U monitor_ai -d project_monitor -h localhost -c "INSERT INTO atomic_propositions (project_id, prop_code, proposition, prop_type, status_id) VALUES ('semantic-core', '$CODE', '$TEXT', '$TYPE', (SELECT status_id FROM statuses WHERE project_id='semantic-core' AND status_code='draft'));"
    echo "✅ $CODE اضافه شد"
    ;;
  stats)
    psql -U monitor_ai -d project_monitor -h localhost -P pager=off -c "SELECT st.status_code, COUNT(*) FROM atomic_propositions ap JOIN statuses st ON ap.status_id = st.status_id WHERE ap.project_id='semantic-core' GROUP BY st.status_code;"
    ;;
  *)
    echo "استفاده: $0 {done|active|add|stats} [code] [text] [type]"
    exit 1
    ;;
esac
