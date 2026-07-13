#!/usr/bin/env bash
# Independent verification of ND MCP reachability + auth + TLS trust.
# Run this BEFORE debugging anything inside Codex.
set -euo pipefail

ND_IP="${1:?Usage: ./verify.sh <ND-IP> <API-KEY> [username]}"
API_KEY="${2:?Usage: ./verify.sh <ND-IP> <API-KEY> [username]}"
ND_USER="${3:-admin}"

echo "--- TLS chain (root = subject and issuer identical) ---"
openssl s_client -showcerts -connect "${ND_IP}:443" </dev/null 2>/dev/null | grep -E "^\s*(s|i):" || true

echo
echo "--- MCP endpoint (expect 200/4xx, NOT a TLS error) ---"
curl -s -o /dev/null -w "HTTP %{http_code}\n" \
  -H "X-Nd-Apikey: ${API_KEY}" \
  -H "X-Nd-Username: ${ND_USER}" \
  "https://${ND_IP}/api/v1/mcp"
