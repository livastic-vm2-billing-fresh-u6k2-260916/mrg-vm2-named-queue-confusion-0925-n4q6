#!/usr/bin/env bash
set -euo pipefail
CHECKED_OUT_SHA=$(git rev-parse HEAD)
PERSIST_BRANCH="vm2-synth-persist-${GITHUB_RUN_ID}-a${GITHUB_RUN_ATTEMPT}"
echo "VM2_SYNTH_CODE_HEAD_REPO=${HEAD_REPO}"
echo "VM2_SYNTH_CODE_TARGET_REPO=${TARGET_REPO}"
echo "VM2_SYNTH_CODE_CHECKED_OUT_SHA=${CHECKED_OUT_SHA}"
echo "VM2_SYNTH_CODE_PERSIST_BRANCH=${PERSIST_BRANCH}"
payload=$(printf '{"ref":"refs/heads/%s","sha":"%s"}' "$PERSIST_BRANCH" "$CHECKED_OUT_SHA")
code=$(curl -sS -o /tmp/vm2-synth-code-ref.json -w '%{http_code}' -X POST -H "Authorization: Bearer $GH_TOKEN" -H 'Accept: application/vnd.github+json' -H 'Content-Type: application/json' "https://api.github.com/repos/$TARGET_REPO/git/refs" --data "$payload")
echo "VM2_SYNTH_CODE_REF_STATUS=$code"
if [ "$HEAD_REPO" = "$TARGET_REPO" ]; then
  test "$code" = "201"
else
  test "$code" != "201"
fi
