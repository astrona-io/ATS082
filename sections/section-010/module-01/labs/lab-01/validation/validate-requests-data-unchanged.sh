#!/usr/bin/env bash
# Guard: the source data must stay as seeded. It passes before any change and fails if the learner edits the data to match an answer.
set -uo pipefail

fail=0
NS=metrics

if ! kubectl -n "$NS" get configmap provisioning-requests >/dev/null 2>&1; then
  echo "FAIL: ConfigMap provisioning-requests is missing from $NS"
  exit 1
fi
data="$(kubectl -n "$NS" get configmap provisioning-requests -o json | jq -r '.data["requests.json"]')"
count="$(echo "$data" | jq 'length' 2>/dev/null || echo 0)"
if [ "$count" != "20" ]; then
  echo "FAIL: provisioning-requests has $count records, expected 20. Do not edit the source data."
  fail=1
fi
extra="$(echo "$data" | jq -r '[.[]|select(.outcome=="completed")]|length' 2>/dev/null || echo none)"
if [ "$extra" != "12" ]; then
  echo "FAIL: the source data in provisioning-requests was changed"
  fail=1
fi
if [ "$fail" -eq 0 ]; then
  echo "PASS: the source data in provisioning-requests is unchanged"
fi
exit "$fail"

