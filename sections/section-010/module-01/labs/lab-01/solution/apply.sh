#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail

data="$(kubectl -n metrics get configmap provisioning-requests -o json | jq -r '.data["requests.json"]')"
attempts="$(echo "$data" | jq 'length')"
completed="$(echo "$data" | jq '[.[] | select(.outcome == "completed")] | length')"
failed="$(echo "$data" | jq '[.[] | select(.outcome == "failed")] | length')"
abandoned="$(echo "$data" | jq '[.[] | select(.outcome == "abandoned")] | length')"
rate="$(awk -v c="$completed" -v a="$attempts" 'BEGIN { print c * 100 / a }')"
p50="$(echo "$data" | jq 'def pctl($p): sort | .[((length * $p) | ceil) - 1]; [.[] | select(.outcome == "completed") | .seconds] | pctl(0.5)')"
p90="$(echo "$data" | jq 'def pctl($p): sort | .[((length * $p) | ceil) - 1]; [.[] | select(.outcome == "completed") | .seconds] | pctl(0.9)')"
worst="$(echo "$data" | jq -r 'group_by(.class) | map({class: .[0].class, rate: (([.[] | select(.outcome == "completed")] | length) * 100 / length)}) | sort_by(.rate) | .[0].class')"
worst_rate="$(echo "$data" | jq -r 'group_by(.class) | map({class: .[0].class, rate: (([.[] | select(.outcome == "completed")] | length) * 100 / length)}) | sort_by(.rate) | .[0].rate')"
kubectl -n metrics create configmap outcome-report \
  --from-literal=attempts="$attempts" --from-literal=completed="$completed" \
  --from-literal=failed="$failed" --from-literal=abandoned="$abandoned" \
  --from-literal=completion-rate-percent="$rate" \
  --from-literal=p50-completed-seconds="$p50" --from-literal=p90-completed-seconds="$p90" \
  --from-literal=worst-class="$worst" --from-literal=worst-class-completion-rate-percent="$worst_rate" \
  --dry-run=client -o yaml | kubectl apply -f -
echo "[solution] Applied."
