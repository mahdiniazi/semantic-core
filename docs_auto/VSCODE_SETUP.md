# VS Code + Cline MCP Setup

## 3 گام
1. نصب افزونه:
   code --install-extension saoudrizwan.claude-dev --force

2. باز کردن VS Code:
   code ~/semantic_core

3. کلیک روی آیکن Cline در sidebar → MCP Servers → should show "project-monitor"

## Config file
~/.config/Code/User/globalStorage/saoudrizwan.claude-dev/settings/cline_mcp_settings.json

## 10 ابزار
- get_project_status
- get_clues
- get_feedback
- get_handoff
- get_integrity
- get_tasks(project_id, only_pending)
- get_widgets
- get_roadmap
- get_propositions(project_id, limit)
- run_safe_query(sql)
