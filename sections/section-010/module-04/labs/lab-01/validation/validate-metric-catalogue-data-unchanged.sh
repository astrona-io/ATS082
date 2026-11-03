#!/usr/bin/env bash
# Guard: the source data must stay as seeded. It passes before any change and fails if the learner edits the data to match an answer.
set -uo pipefail

NS=metrics

if ! kubectl -n "$NS" get configmap metric-catalogue >/dev/null 2>&1; then
  echo "FAIL: ConfigMap metric-catalogue is missing from $NS"
  exit 1
fi
sum="$(kubectl -n "$NS" get configmap metric-catalogue -o json | jq -r '.data["metrics.json"]' | jq -S -c . 2>/dev/null | cksum | cut -d' ' -f1)"
if [ "$sum" != "3855001832" ]; then
  echo "FAIL: the source data in metric-catalogue was changed. Do not edit it."
  exit 1
fi
echo "PASS: the source data in metric-catalogue is unchanged"
exit 0
