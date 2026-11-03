#!/usr/bin/env bash
# Guard: the source data must stay as seeded. It passes before any change and fails if the learner edits the data to match an answer.
set -uo pipefail

NS=delivery

if ! kubectl -n "$NS" get configmap deployment-history >/dev/null 2>&1; then
  echo "FAIL: ConfigMap deployment-history is missing from $NS"
  exit 1
fi
sum="$(kubectl -n "$NS" get configmap deployment-history -o json | jq -r '.data["deployments.json"]' | jq -S -c . 2>/dev/null | cksum | cut -d' ' -f1)"
if [ "$sum" != "3634860161" ]; then
  echo "FAIL: the source data in deployment-history was changed. Do not edit it."
  exit 1
fi
echo "PASS: the source data in deployment-history is unchanged"
exit 0
