#!/bin/bash
grep -E "^\s*\{ name: '" /home/cs/mcp-servers/pg_mcp_server.js | sed "s/.*name: '\([^']*\)'.*/\1/"
