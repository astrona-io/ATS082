#!/usr/bin/env bash
# Guard: the source data must stay as seeded. It passes before any change and fails if the learner edits the data to match an answer.
set -uo pipefail

fail=0
NS=metrics

if ! kubectl -n "$NS" get configmap survey-responses >/dev/null 2>&1; then
  echo "FAIL: ConfigMap survey-responses is missing from $NS"
  exit 1
fi
data="$(kubectl -n "$NS" get configmap survey-responses -o json | jq -r '.data["survey.json"]')"
count="$(echo "$data" | jq 'length' 2>/dev/null || echo 0)"
if [ "$count" != "12" ]; then
  echo "FAIL: survey-responses has $count records, expected 12. Do not edit the source data."
  fail=1
fi
extra="$(echo "$data" | jq -r '[.[].theme]|unique|length' 2>/dev/null || echo none)"
if [ "$extra" != "3" ]; then
  echo "FAIL: the source data in survey-responses was changed"
  fail=1
fi
if [ "$fail" -eq 0 ]; then
  echo "PASS: the source data in survey-responses is unchanged"
fi
exit "$fail"

