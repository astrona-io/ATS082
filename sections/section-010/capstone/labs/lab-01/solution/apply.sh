#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail

data="$(kubectl -n metrics get configmap environment-requests -o json | jq -r '.data["requests.json"]')"
attempts="$(echo "$data" | jq 'length')"
completed="$(echo "$data" | jq '[.[] | select(.outcome == "completed")] | length')"
abandoned="$(echo "$data" | jq '[.[] | select(.outcome == "abandoned")] | length')"
rate="$(awk -v c="$completed" -v a="$attempts" 'BEGIN { print c * 100 / a }')"
p90="$(echo "$data" | jq 'def pctl($p): sort | .[((length * $p) | ceil) - 1]; def secs: ((.ended_at | fromdateiso8601) - (.requested_at | fromdateiso8601)); [.[] | select(.outcome == "completed") | secs] | pctl(0.9)')"
stats='group_by(.class) | map({class: .[0].class, rate: (([.[] | select(.outcome == "completed")] | length) * 100 / length)}) | sort_by(.rate) | .[0]'
worst="$(echo "$data" | jq -r "$stats | .class")"
worst_rate="$(echo "$data" | jq -r "$stats | .rate")"
kubectl -n metrics create configmap outcome-evidence \
  --from-literal=attempts="$attempts" --from-literal=completed="$completed" --from-literal=abandoned="$abandoned" \
  --from-literal=completion-rate-percent="$rate" --from-literal=p90-completed-seconds="$p90" \
  --from-literal=worst-class="$worst" --from-literal=worst-class-completion-rate-percent="$worst_rate" \
  --from-literal=claim-supported=no \
  --from-literal=claim-reason="The 90th percentile of completed requests is $p90 seconds, above the 300 second limit, and abandoned requests are not even counted" \
  --from-literal=proposal-decision=reject \
  --from-literal=proposal-reason="Ranking people by request count rewards extra requests, not outcomes, and teams will game the number" \
  --dry-run=client -o yaml | kubectl apply -f -
echo "[solution] Applied."
