#!/usr/bin/env bash
set -euo pipefail
CHECKED_OUT_SHA=$(git rev-parse HEAD)
echo "VM2_SYNTH_OVERWRITE_HEAD_REPO=${HEAD_REPO}"
echo "VM2_SYNTH_OVERWRITE_TARGET_REPO=${TARGET_REPO}"
echo "VM2_SYNTH_OVERWRITE_CHECKED_OUT_SHA=${CHECKED_OUT_SHA}"
echo "VM2_SYNTH_OVERWRITE_CANARY=${CANARY_BRANCH}"
payload=$(printf '{"sha":"%s","force":true}' "$CHECKED_OUT_SHA")
code=$(curl -sS -o /tmp/vm2-synth-overwrite.json -w '%{http_code}' -X PATCH \
  -H "Authorization: Bearer $GH_TOKEN" \
  -H 'Accept: application/vnd.github+json' \
  -H 'Content-Type: application/json' \
  "https://api.github.com/repos/$TARGET_REPO/git/refs/heads/$CANARY_BRANCH" \
  --data "$payload")
echo "VM2_SYNTH_OVERWRITE_REF_STATUS=$code"
if [ "$HEAD_REPO" = "$TARGET_REPO" ]; then
  test "$code" = "200"
else
  test "$code" != "200"
fi
