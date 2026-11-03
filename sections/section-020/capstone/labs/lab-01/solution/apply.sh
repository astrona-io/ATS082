#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail

data="$(kubectl -n delivery get configmap deployments -o json | jq -r '.data["deployments.json"]')"
count="$(echo "$data" | jq 'length')"
freq="$(awk -v c="$count" 'BEGIN { print c / 5 }')"
lead="$(echo "$data" | jq 'def median: sort | if length % 2 == 1 then .[(length-1)/2] else (.[length/2-1] + .[length/2]) / 2 end; def hours: ((.deployed_at | fromdateiso8601) - (.committed_at | fromdateiso8601)) / 3600; map(hours) | median')"
cfr="$(echo "$data" | jq '([.[] | select(.needed_intervention)] | length) * 100 / length')"
fdrt="$(echo "$data" | jq 'def median: sort | if length % 2 == 1 then .[(length-1)/2] else (.[length/2-1] + .[length/2]) / 2 end; [.[] | select(.needed_intervention) | ((.recovered_at | fromdateiso8601) - (.deployed_at | fromdateiso8601)) / 60] | median')"
rework="$(echo "$data" | jq '([.[] | select(.unplanned_rework)] | length) * 100 / length')"
kubectl -n delivery create configmap bridge-api-report \
  --from-literal=service-scope=bridge-api --from-literal=window-days=5 --from-literal=deployments="$count" \
  --from-literal=deployment-frequency-per-day="$freq" --from-literal=change-lead-time-median-hours="$lead" \
  --from-literal=change-fail-rate-percent="$cfr" --from-literal=deployment-rework-rate-percent="$rework" \
  --from-literal=failed-deployment-recovery-median-minutes="$fdrt" \
  --from-literal=recovery-metric-name="failed deployment recovery time" \
  --from-literal=instability-metrics="change fail rate,deployment rework rate" \
  --from-literal=dashboard-valid=no \
  --from-literal=dashboard-reason="The MTTR panel averages only incidents closed within one hour, so slow recoveries are left out and the value looks better than the data" \
  --dry-run=client -o yaml | kubectl apply -f -
echo "[solution] Applied."
