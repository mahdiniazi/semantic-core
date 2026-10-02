#!/bin/bash
# cycle.sh — چرخه کامل: analyze → propose → scope_check → mirror
echo "=== 1. analyze ==="
~/semantic_core/factory/scripts/analyze_feedback.sh
echo "=== 2. propose ==="
~/semantic_core/factory/scripts/propose_actions.sh
echo "=== 3. scope_check ==="
~/semantic_core/factory/scripts/scope_check.sh
echo "=== 4. mirror ==="
~/semantic_core/factory/scripts/weekly_mirror.sh
echo "=== done ==="
