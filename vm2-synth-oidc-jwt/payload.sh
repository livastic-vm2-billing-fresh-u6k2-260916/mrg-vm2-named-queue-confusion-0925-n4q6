#!/usr/bin/env bash
set -euo pipefail
printf 'VM2_OIDC_JWT_HEAD_REPO=%s\n' "${GITHUB_HEAD_REPOSITORY:-unknown}"
printf 'VM2_OIDC_JWT_TARGET_REPO=%s\n' "${GITHUB_REPOSITORY:-unknown}"
if [[ -z "${ACTIONS_ID_TOKEN_REQUEST_URL:-}" || -z "${ACTIONS_ID_TOKEN_REQUEST_TOKEN:-}" ]]; then
  echo 'VM2_OIDC_JWT_CONTEXT_PRESENT=0'
  echo 'VM2_OIDC_JWT_ISSUED=0'
  exit 0
fi
echo 'VM2_OIDC_JWT_CONTEXT_PRESENT=1'
resp="$(curl -fsS -H "Authorization: Bearer ${ACTIONS_ID_TOKEN_REQUEST_TOKEN}" "${ACTIONS_ID_TOKEN_REQUEST_URL}&audience=vm2-mergify-oidc-jwt-1003")"
OIDC_RESPONSE="$resp" python3 - <<'PY'
import os, json, base64, hashlib
obj=json.loads(os.environ['OIDC_RESPONSE'])
tok=obj.get('value')
print('VM2_OIDC_JWT_ISSUED=' + ('1' if tok else '0'))
if not tok:
    raise SystemExit(2)
print('VM2_OIDC_JWT_SHA256=' + hashlib.sha256(tok.encode()).hexdigest())
parts=tok.split('.')
if len(parts) != 3:
    raise SystemExit('unexpected JWT shape')
p=parts[1] + '='*((4-len(parts[1])%4)%4)
claims=json.loads(base64.urlsafe_b64decode(p.encode()))
for key in ('iss','sub','aud','repository','repository_owner','repository_id','repository_owner_id','event_name','ref','ref_type','actor','workflow','job_workflow_ref'):
    if key in claims:
        print('VM2_OIDC_CLAIM_' + key.upper() + '=' + str(claims[key]))
PY
unset resp OIDC_RESPONSE
