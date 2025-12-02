#!/usr/bin/env bash
set -euo pipefail
BASE_URL=${BASE_URL:-http://127.0.0.1:8080}
curl --fail -s ${BASE_URL}/health | grep -q '\"ok\":true'
curl --fail -s -X POST -H "Content-Type: application/json" -d '{"message":"from-ci"}' ${BASE_URL}/message | grep -q 'from-ci'
echo "integration-tests: OK"
