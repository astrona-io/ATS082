#!/usr/bin/env bash
# Guard: the source data must stay as seeded. It passes before any change and fails if the learner edits the data to match an answer.
set -uo pipefail

fail=0
NS=delivery

if ! kubectl -n "$NS" get configmap deployments >/dev/null 2>&1; then
  echo "FAIL: ConfigMap deployments is missing from $NS"
  exit 1
fi
data="$(kubectl -n "$NS" get configmap deployments -o json | jq -r '.data["deployments.json"]')"
count="$(echo "$data" | jq 'length' 2>/dev/null || echo 0)"
if [ "$count" != "25" ]; then
  echo "FAIL: deployments has $count records, expected 25. Do not edit the source data."
  fail=1
fi
extra="$(echo "$data" | jq -r '[.[]|select(.needed_intervention)]|length' 2>/dev/null || echo none)"
if [ "$extra" != "5" ]; then
  echo "FAIL: the source data in deployments was changed"
  fail=1
fi
if [ "$fail" -eq 0 ]; then
  echo "PASS: the source data in deployments is unchanged"
fi
exit "$fail"

