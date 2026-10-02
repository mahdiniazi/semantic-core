# MCP Server — Status

نسخه: 2.0.0
تاریخ: 2026-10-02
وضعیت: ✅ آماده

## Server
- فایل: /home/cs/mcp-servers/pg_mcp_server.js
- پروتکل: stdio (MCP)
- پکیج: @modelcontextprotocol/sdk

## 10 ابزار
1. get_project_status
2. get_clues
3. get_feedback
4. get_handoff
5. get_integrity
6. get_tasks(project_id, only_pending)
7. get_widgets
8. get_roadmap
9. get_propositions(project_id, limit)
10. run_safe_query(sql) — SELECT only

## Config files
- Claude Desktop: ~/.config/Claude/claude_desktop_config.json
- Cursor: ~/.cursor/mcp.json
- Project-level: ~/semantic_core/.mcp.json

## استفاده
1. Client را restart کن (Claude Desktop / Cursor)
2. اتصال خودکار است
3. AI می‌تواند مستقیم query بزند

## تست
bash ~/semantic_core/factory/scripts/test_mcp.sh
bash ~/semantic_core/factory/scripts/mcp_tools_list.sh
