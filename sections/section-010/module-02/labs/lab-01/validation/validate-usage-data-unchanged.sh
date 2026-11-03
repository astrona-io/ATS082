#!/usr/bin/env bash
# Guard: the source data must stay as seeded. It passes before any change and fails if the learner edits the data to match an answer.
set -uo pipefail

fail=0
NS=metrics

if ! kubectl -n "$NS" get configmap portal-usage >/dev/null 2>&1; then
  echo "FAIL: ConfigMap portal-usage is missing from $NS"
  exit 1
fi
data="$(kubectl -n "$NS" get configmap portal-usage -o json | jq -r '.data["usage.json"]')"
count="$(echo "$data" | jq 'length' 2>/dev/null || echo 0)"
if [ "$count" != "4" ]; then
  echo "FAIL: portal-usage has $count records, expected 4. Do not edit the source data."
  fail=1
fi
extra="$(echo "$data" | jq -r '[.[].tickets]|add' 2>/dev/null || echo none)"
if [ "$extra" != "134" ]; then
  echo "FAIL: the source data in portal-usage was changed"
  fail=1
fi
if [ "$fail" -eq 0 ]; then
  echo "PASS: the source data in portal-usage is unchanged"
fi
exit "$fail"

