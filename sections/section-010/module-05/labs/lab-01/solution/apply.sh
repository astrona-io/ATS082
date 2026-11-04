#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail

NS=metrics
svc="$(kubectl -n "$NS" get configmap service-events -o json | jq -c '.data["services.json"]|fromjson')"
hr="$(kubectl -n "$NS" get configmap recent-hour -o json | jq -c '.data["hour.json"]|fromjson')"
provisioning_api_sli_percent="$(jq -n -r --argjson svc "$svc" --argjson hr "$hr" '$svc|.[]|select(.service=="provisioning-api")|(.good_events*100/.total_events)')"
pipeline_runner_sli_percent="$(jq -n -r --argjson svc "$svc" --argjson hr "$hr" '$svc|.[]|select(.service=="pipeline-runner")|(.good_events*100/.total_events)')"
portal_sli_percent="$(jq -n -r --argjson svc "$svc" --argjson hr "$hr" '$svc|.[]|select(.service=="portal")|(.good_events*100/.total_events)')"
artifact_registry_sli_percent="$(jq -n -r --argjson svc "$svc" --argjson hr "$hr" '$svc|.[]|select(.service=="artifact-registry")|(.good_events*100/.total_events)')"
provisioning_api_budget_used_percent="$(jq -n -r --argjson svc "$svc" --argjson hr "$hr" '$svc|.[]|select(.service=="provisioning-api")|((.total_events-.good_events)/(.total_events*(100-.slo_target_percent)/100)*100)')"
pipeline_runner_budget_used_percent="$(jq -n -r --argjson svc "$svc" --argjson hr "$hr" '$svc|.[]|select(.service=="pipeline-runner")|((.total_events-.good_events)/(.total_events*(100-.slo_target_percent)/100)*100)')"
portal_budget_used_percent="$(jq -n -r --argjson svc "$svc" --argjson hr "$hr" '$svc|.[]|select(.service=="portal")|((.total_events-.good_events)/(.total_events*(100-.slo_target_percent)/100)*100)')"
artifact_registry_budget_used_percent="$(jq -n -r --argjson svc "$svc" --argjson hr "$hr" '$svc|.[]|select(.service=="artifact-registry")|((.total_events-.good_events)/(.total_events*(100-.slo_target_percent)/100)*100)')"
services_missing_slo="$(jq -n -r --argjson svc "$svc" --argjson hr "$hr" '$svc|[.[]|select((.good_events*100/.total_events) < .slo_target_percent)|.service]|sort|join(",")')"
most_budget_used_service="$(jq -n -r --argjson svc "$svc" --argjson hr "$hr" '$svc|map({s:.service, u:((.total_events-.good_events)/(.total_events*(100-.slo_target_percent)/100)*100)})|max_by(.u)|.s')"
provisioning_api_burn_rate="$(jq -n -r --argjson svc "$svc" --argjson hr "$hr" '($hr.bad_events/$hr.total_events) / (($svc|.[]|select(.service==$hr.service)|(100-.slo_target_percent))/100)')"
days_to_exhaust_budget="$(jq -n -r --argjson svc "$svc" --argjson hr "$hr" '30 / (($hr.bad_events/$hr.total_events) / (($svc|.[]|select(.service==$hr.service)|(100-.slo_target_percent))/100))')"
kubectl -n metrics create configmap slo-review \
  --from-literal=provisioning-api-sli-percent="$provisioning_api_sli_percent" \
  --from-literal=pipeline-runner-sli-percent="$pipeline_runner_sli_percent" \
  --from-literal=portal-sli-percent="$portal_sli_percent" \
  --from-literal=artifact-registry-sli-percent="$artifact_registry_sli_percent" \
  --from-literal=provisioning-api-budget-used-percent="$provisioning_api_budget_used_percent" \
  --from-literal=pipeline-runner-budget-used-percent="$pipeline_runner_budget_used_percent" \
  --from-literal=portal-budget-used-percent="$portal_budget_used_percent" \
  --from-literal=artifact-registry-budget-used-percent="$artifact_registry_budget_used_percent" \
  --from-literal=services-missing-slo="$services_missing_slo" \
  --from-literal=most-budget-used-service="$most_budget_used_service" \
  --from-literal=provisioning-api-burn-rate="$provisioning_api_burn_rate" \
  --from-literal=days-to-exhaust-budget="$days_to_exhaust_budget" \
  --dry-run=client -o yaml | kubectl apply -f -
echo "[solution] Applied."
