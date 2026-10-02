#!/bin/bash
# set_anthropic.sh — ذخیره API key Anthropic
if [ -z "$1" ]; then
  echo "Usage: $0 sk-ant-xxxxx"
  exit 1
fi
cat > ~/.continue/config.json << EOF
{
  "models": [
    {
      "title": "Claude 3.5 Sonnet",
      "provider": "anthropic",
      "model": "claude-3-5-sonnet-latest",
      "apiKey": "$1"
    }
  ],
  "mcpServers": {
    "project-monitor": {
      "command": "node",
      "args": ["/home/cs/mcp-servers/pg_mcp_server.js"],
      "env": {
        "DATABASE_URL": "postgresql://monitor_ai:monitor_secure_1405@localhost:5432/project_monitor"
      }
    }
  },
  "allowAnonymousTelemetry": false
}
EOF
echo "✅ Anthropic key ذخیره شد"
