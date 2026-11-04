#!/usr/bin/env bash
# Guard: the source data must stay as seeded. It passes before any change and fails if the learner edits the data to match an answer.
set -uo pipefail

NS=metrics

if ! kubectl -n "$NS" get configmap service-events >/dev/null 2>&1; then
  echo "FAIL: ConfigMap service-events is missing from $NS"
  exit 1
fi
sum="$(kubectl -n "$NS" get configmap service-events -o json | jq -r '.data["services.json"]' | jq -S -c . 2>/dev/null | cksum | cut -d' ' -f1)"
if [ "$sum" != "122720594" ]; then
  echo "FAIL: the source data in service-events was changed. Do not edit it."
  exit 1
fi
if ! kubectl -n "$NS" get configmap recent-hour >/dev/null 2>&1; then
  echo "FAIL: ConfigMap recent-hour is missing from $NS"
  exit 1
fi
sum="$(kubectl -n "$NS" get configmap recent-hour -o json | jq -r '.data["hour.json"]' | jq -S -c . 2>/dev/null | cksum | cut -d' ' -f1)"
if [ "$sum" != "2749572036" ]; then
  echo "FAIL: the source data in recent-hour was changed. Do not edit it."
  exit 1
fi
echo "PASS: the source data in service-events and recent-hour is unchanged"
exit 0
