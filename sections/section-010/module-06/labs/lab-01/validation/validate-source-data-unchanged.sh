#!/usr/bin/env bash
# Guard: the source data must stay as seeded. It passes before any change and fails if the learner edits the data to match an answer.
set -uo pipefail

NS=metrics

if ! kubectl -n "$NS" get configmap team-resources >/dev/null 2>&1; then
  echo "FAIL: ConfigMap team-resources is missing from $NS"
  exit 1
fi
sum="$(kubectl -n "$NS" get configmap team-resources -o json | jq -r '.data["teams.json"]' | jq -S -c . 2>/dev/null | cksum | cut -d' ' -f1)"
if [ "$sum" != "1992709674" ]; then
  echo "FAIL: the source data in team-resources was changed. Do not edit it."
  exit 1
fi
if ! kubectl -n "$NS" get configmap platform-cost >/dev/null 2>&1; then
  echo "FAIL: ConfigMap platform-cost is missing from $NS"
  exit 1
fi
sum="$(kubectl -n "$NS" get configmap platform-cost -o json | jq -r '.data["cost.json"]' | jq -S -c . 2>/dev/null | cksum | cut -d' ' -f1)"
if [ "$sum" != "4211545274" ]; then
  echo "FAIL: the source data in platform-cost was changed. Do not edit it."
  exit 1
fi
echo "PASS: the source data in team-resources and platform-cost is unchanged"
exit 0
