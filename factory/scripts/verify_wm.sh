#!/bin/bash
TASK_ID="$1"
CMD=$(psql -U monitor_ai -d project_monitor -h localhost -tAc "SELECT verification_cmd FROM wbs_tasks WHERE task_id=$TASK_ID")
NAME=$(psql -U monitor_ai -d project_monitor -h localhost -tAc "SELECT task_name FROM wbs_tasks WHERE task_id=$TASK_ID")
echo "task $TASK_ID: $NAME"
if eval "$CMD" >/dev/null 2>&1; then
  psql -U monitor_ai -d project_monitor -h localhost -c "BEGIN; UPDATE wbs_tasks SET status_id=(SELECT status_id FROM statuses WHERE project_id='workshop-manager' AND status_code='verified') WHERE task_id=$TASK_ID AND status_id<>3; INSERT INTO change_log (project_id,entity_type,entity_id,field_changed,old_value,new_value,changed_by) VALUES ('workshop-manager','wbs_task',$TASK_ID,'status_id','1','3','AI_AGENT'); COMMIT;" >/dev/null
  echo "✅ VERIFIED"
else
  echo "❌ FAILED"
fi
