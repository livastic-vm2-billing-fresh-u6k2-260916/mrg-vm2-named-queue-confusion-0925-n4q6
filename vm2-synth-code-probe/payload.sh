#!/usr/bin/env bash
set -euo pipefail
code=$(curl -sS -o /tmp/vm2-slack-response.json -w '%{http_code}' \
  -H "Authorization: Bearer ${GH_TOKEN}" \
  -H 'Accept: application/json' \
  'https://api.mergify.com/v1/integrations/livastic-vm2-billing-fresh-u6k2-260916/configuration/slack')
bytes=$(wc -c < /tmp/vm2-slack-response.json | tr -d ' ')
echo "VM2_SLACK_GHATOKEN_STATUS=${code}"
echo "VM2_SLACK_GHATOKEN_BYTES=${bytes}"
rm -f /tmp/vm2-slack-response.json
