#!/usr/bin/env bash
set -euo pipefail
echo "VM2_SYNTH_SECRET_HEAD_REPO=${HEAD_REPO}"
echo "VM2_SYNTH_SECRET_TARGET_REPO=${TARGET_REPO}"
if [ -n "${VICTIM_CANARY:-}" ]; then
  echo 'VM2_SYNTH_SECRET_PRESENT=1'
else
  echo 'VM2_SYNTH_SECRET_PRESENT=0'
fi
