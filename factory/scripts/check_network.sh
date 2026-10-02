#!/bin/bash
echo "=== Network Health Check ==="
echo ""
for host in marketplace.visualstudio.com api.anthropic.com openrouter.ai api.openai.com github.com; do
  if curl -s --max-time 5 "https://$host" >/dev/null 2>&1; then
    echo "✅ $host"
  else
    echo "❌ $host"
  fi
done
echo ""
echo "DNS:"
cat /etc/resolv.conf | grep nameserver
