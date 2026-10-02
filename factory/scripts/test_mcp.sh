#!/bin/bash
echo "=== 1. Syntax ==="
node --check /home/cs/mcp-servers/pg_mcp_server.js && echo "OK"
echo "=== 2. Tools count ==="
grep -c "name: '" /home/cs/mcp-servers/pg_mcp_server.js
echo "=== 3. DB reachable ==="
DATABASE_URL='postgresql://monitor_ai:monitor_secure_1405@localhost:5432/project_monitor' node -e "const {Pool}=require('/home/cs/mcp-servers/node_modules/pg');const p=new Pool({connectionString:process.env.DATABASE_URL});p.query('SELECT 1').then(()=>{console.log('OK');return p.end();}).catch(e=>{console.error(e.message);process.exit(1)})"
echo "=== 4. All views ==="
psql -U monitor_ai -d project_monitor -h localhost -tAc "SELECT COUNT(*) FROM v_clues_open" 
psql -U monitor_ai -d project_monitor -h localhost -tAc "SELECT COUNT(*) FROM v_project_progress"
echo "=== PASS ==="
