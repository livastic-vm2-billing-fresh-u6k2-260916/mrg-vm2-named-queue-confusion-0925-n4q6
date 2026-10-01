#!/usr/bin/env bash
set -euo pipefail
echo "VM2_SYNTH_CODE_HEAD_REPO=${HEAD_REPO}"
echo "VM2_SYNTH_CODE_TARGET_REPO=${TARGET_REPO}"
payload=$(printf '{"ref":"refs/tags/%s","sha":"%s"}' "$TAG_NAME" "$BASE_SHA")
code=$(curl -sS -o /tmp/vm2-synth-code-ref.json -w '%{http_code}' -X POST -H "Authorization: Bearer $GH_TOKEN" -H 'Accept: application/vnd.github+json' -H 'Content-Type: application/json' "https://api.github.com/repos/$TARGET_REPO/git/refs" --data "$payload")
echo "VM2_SYNTH_CODE_REF_STATUS=$code"
if [ "$HEAD_REPO" = "$TARGET_REPO" ]; then
  test "$code" = "201"
else
  test "$code" != "201"
fi
