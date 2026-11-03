#!/usr/bin/env bash
# Guard: the source data must stay as seeded. It passes before any change and fails if the learner edits the data to match an answer.
set -uo pipefail

NS=metrics

if ! kubectl -n "$NS" get configmap team-adoption >/dev/null 2>&1; then
  echo "FAIL: ConfigMap team-adoption is missing from $NS"
  exit 1
fi
sum="$(kubectl -n "$NS" get configmap team-adoption -o json | jq -r '.data["teams.json"]' | jq -S -c . 2>/dev/null | cksum | cut -d' ' -f1)"
if [ "$sum" != "330162294" ]; then
  echo "FAIL: the source data in team-adoption was changed. Do not edit it."
  exit 1
fi
echo "PASS: the source data in team-adoption is unchanged"
exit 0
