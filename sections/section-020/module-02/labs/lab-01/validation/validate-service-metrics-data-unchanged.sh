#!/usr/bin/env bash
# Guard: the source data must stay as seeded. It passes before any change and fails if the learner edits the data to match an answer.
set -uo pipefail

fail=0
NS=delivery

if ! kubectl -n "$NS" get configmap service-metrics >/dev/null 2>&1; then
  echo "FAIL: ConfigMap service-metrics is missing from $NS"
  exit 1
fi
data="$(kubectl -n "$NS" get configmap service-metrics -o json | jq -r '.data["metrics.json"]')"
count="$(echo "$data" | jq 'length' 2>/dev/null || echo 0)"
if [ "$count" != "3" ]; then
  echo "FAIL: service-metrics has $count records, expected 3. Do not edit the source data."
  fail=1
fi
extra="$(echo "$data" | jq -r '[.[]|select(.platform_pipeline)]|length' 2>/dev/null || echo none)"
if [ "$extra" != "2" ]; then
  echo "FAIL: the source data in service-metrics was changed"
  fail=1
fi
if [ "$fail" -eq 0 ]; then
  echo "PASS: the source data in service-metrics is unchanged"
fi
exit "$fail"

