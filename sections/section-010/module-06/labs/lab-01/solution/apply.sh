#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail

NS=metrics
teams="$(kubectl -n "$NS" get configmap team-resources -o json | jq -c '.data["teams.json"]|fromjson')"
cost="$(kubectl -n "$NS" get configmap platform-cost -o json | jq -c '.data["cost.json"]|fromjson')"
bridge_utilization_percent="$(jq -n -r --argjson teams "$teams" --argjson cost "$cost" '$teams|.[]|select(.team=="bridge")|(.cpu_used_millicores*100/.cpu_requested_millicores)')"
scout_utilization_percent="$(jq -n -r --argjson teams "$teams" --argjson cost "$cost" '$teams|.[]|select(.team=="scout")|(.cpu_used_millicores*100/.cpu_requested_millicores)')"
shuttle_utilization_percent="$(jq -n -r --argjson teams "$teams" --argjson cost "$cost" '$teams|.[]|select(.team=="shuttle")|(.cpu_used_millicores*100/.cpu_requested_millicores)')"
probe_utilization_percent="$(jq -n -r --argjson teams "$teams" --argjson cost "$cost" '$teams|.[]|select(.team=="probe")|(.cpu_used_millicores*100/.cpu_requested_millicores)')"
fleet_utilization_percent="$(jq -n -r --argjson teams "$teams" --argjson cost "$cost" '$teams|((map(.cpu_used_millicores)|add)*100/(map(.cpu_requested_millicores)|add))')"
teams_below_40_percent="$(jq -n -r --argjson teams "$teams" --argjson cost "$cost" '$teams|[.[]|select((.cpu_used_millicores*100/.cpu_requested_millicores) < 40)|.team]|sort|join(",")')"
most_wasted_cores_team="$(jq -n -r --argjson teams "$teams" --argjson cost "$cost" '$teams|max_by(.cpu_requested_millicores-.cpu_used_millicores)|.team')"
most_wasted_cost_team="$(jq -n -r --argjson teams "$teams" --argjson cost "$cost" '$teams|max_by(.monthly_cost*(.cpu_requested_millicores-.cpu_used_millicores)/.cpu_requested_millicores)|.team')"
waste_cost_total="$(jq -n -r --argjson teams "$teams" --argjson cost "$cost" '$teams|map(.monthly_cost*(.cpu_requested_millicores-.cpu_used_millicores)/.cpu_requested_millicores)|add')"
shuttle_cost_per_environment="$(jq -n -r --argjson teams "$teams" --argjson cost "$cost" '$teams|.[]|select(.team=="shuttle")|(.monthly_cost/.environments)')"
idle_environment_cost="$(jq -n -r --argjson teams "$teams" --argjson cost "$cost" '$teams|map(.monthly_cost/.environments*.idle_environments)|add')"
platform_cost_per_team="$(jq -n -r --argjson teams "$teams" --argjson cost "$cost" '$cost.platform_monthly_cost/$cost.teams_supported')"
kubectl -n metrics create configmap cost-review \
  --from-literal=bridge-utilization-percent="$bridge_utilization_percent" \
  --from-literal=scout-utilization-percent="$scout_utilization_percent" \
  --from-literal=shuttle-utilization-percent="$shuttle_utilization_percent" \
  --from-literal=probe-utilization-percent="$probe_utilization_percent" \
  --from-literal=fleet-utilization-percent="$fleet_utilization_percent" \
  --from-literal=teams-below-40-percent="$teams_below_40_percent" \
  --from-literal=most-wasted-cores-team="$most_wasted_cores_team" \
  --from-literal=most-wasted-cost-team="$most_wasted_cost_team" \
  --from-literal=waste-cost-total="$waste_cost_total" \
  --from-literal=shuttle-cost-per-environment="$shuttle_cost_per_environment" \
  --from-literal=idle-environment-cost="$idle_environment_cost" \
  --from-literal=platform-cost-per-team="$platform_cost_per_team" \
  --dry-run=client -o yaml | kubectl apply -f -
echo "[solution] Applied."
