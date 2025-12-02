#!/usr/bin/env bash
set -euo pipefail
# expects app running locally on port 3000
curl --fail -s http://127.0.0.1:3000/health | grep -q '\"ok\":true'
curl --fail -s http://127.0.0.1:3000/message | grep -q 'hello world'
echo "SMOKE_OK"
