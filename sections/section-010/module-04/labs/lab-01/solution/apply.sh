#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail

data="$(kubectl -n metrics get configmap metric-catalogue -o json | jq -r '.data["metrics.json"]')"
metrics_total="$(echo "$data" | jq -r 'def med: sort | (length) as $n | if $n == 0 then null elif ($n % 2) == 1 then .[($n-1)/2] else (.[$n/2-1] + .[$n/2]) / 2 end; def pctl($p): sort | .[((length * $p) | ceil) - 1]; length')"
individual_level_count="$(echo "$data" | jq -r 'def med: sort | (length) as $n | if $n == 0 then null elif ($n % 2) == 1 then .[($n-1)/2] else (.[$n/2-1] + .[$n/2]) / 2 end; def pctl($p): sort | .[((length * $p) | ceil) - 1]; [.[]|select(.level == "individual")]|length')"
satisfaction_count="$(echo "$data" | jq -r 'def med: sort | (length) as $n | if $n == 0 then null elif ($n % 2) == 1 then .[($n-1)/2] else (.[$n/2-1] + .[$n/2]) / 2 end; def pctl($p): sort | .[((length * $p) | ceil) - 1]; [.[]|select(.level == "team" and .dimension == "satisfaction")]|length')"
performance_count="$(echo "$data" | jq -r 'def med: sort | (length) as $n | if $n == 0 then null elif ($n % 2) == 1 then .[($n-1)/2] else (.[$n/2-1] + .[$n/2]) / 2 end; def pctl($p): sort | .[((length * $p) | ceil) - 1]; [.[]|select(.level == "team" and .dimension == "performance")]|length')"
activity_count="$(echo "$data" | jq -r 'def med: sort | (length) as $n | if $n == 0 then null elif ($n % 2) == 1 then .[($n-1)/2] else (.[$n/2-1] + .[$n/2]) / 2 end; def pctl($p): sort | .[((length * $p) | ceil) - 1]; [.[]|select(.level == "team" and .dimension == "activity")]|length')"
communication_count="$(echo "$data" | jq -r 'def med: sort | (length) as $n | if $n == 0 then null elif ($n % 2) == 1 then .[($n-1)/2] else (.[$n/2-1] + .[$n/2]) / 2 end; def pctl($p): sort | .[((length * $p) | ceil) - 1]; [.[]|select(.level == "team" and .dimension == "communication")]|length')"
efficiency_count="$(echo "$data" | jq -r 'def med: sort | (length) as $n | if $n == 0 then null elif ($n % 2) == 1 then .[($n-1)/2] else (.[$n/2-1] + .[$n/2]) / 2 end; def pctl($p): sort | .[((length * $p) | ceil) - 1]; [.[]|select(.level == "team" and .dimension == "efficiency")]|length')"
thinnest_dimension="$(echo "$data" | jq -r 'def med: sort | (length) as $n | if $n == 0 then null elif ($n % 2) == 1 then .[($n-1)/2] else (.[$n/2-1] + .[$n/2]) / 2 end; def pctl($p): sort | .[((length * $p) | ceil) - 1]; [.[]|select(.level == "team")] | group_by(.dimension) | map({d: .[0].dimension, n: length}) | sort_by(.n) | .[0].d')"
perceptual_team_count="$(echo "$data" | jq -r 'def med: sort | (length) as $n | if $n == 0 then null elif ($n % 2) == 1 then .[($n-1)/2] else (.[$n/2-1] + .[$n/2]) / 2 end; def pctl($p): sort | .[((length * $p) | ceil) - 1]; [.[]|select(.level == "team" and .measure == "perceptual")]|length')"
workflow_team_count="$(echo "$data" | jq -r 'def med: sort | (length) as $n | if $n == 0 then null elif ($n % 2) == 1 then .[($n-1)/2] else (.[$n/2-1] + .[$n/2]) / 2 end; def pctl($p): sort | .[((length * $p) | ceil) - 1]; [.[]|select(.level == "team" and .measure == "workflow")]|length')"
feedback_loops_count="$(echo "$data" | jq -r 'def med: sort | (length) as $n | if $n == 0 then null elif ($n % 2) == 1 then .[($n-1)/2] else (.[$n/2-1] + .[$n/2]) / 2 end; def pctl($p): sort | .[((length * $p) | ceil) - 1]; [.[]|select(.level == "team" and .devex == "feedback loops")]|length')"
cognitive_load_count="$(echo "$data" | jq -r 'def med: sort | (length) as $n | if $n == 0 then null elif ($n % 2) == 1 then .[($n-1)/2] else (.[$n/2-1] + .[$n/2]) / 2 end; def pctl($p): sort | .[((length * $p) | ceil) - 1]; [.[]|select(.level == "team" and .devex == "cognitive load")]|length')"
flow_state_count="$(echo "$data" | jq -r 'def med: sort | (length) as $n | if $n == 0 then null elif ($n % 2) == 1 then .[($n-1)/2] else (.[$n/2-1] + .[$n/2]) / 2 end; def pctl($p): sort | .[((length * $p) | ceil) - 1]; [.[]|select(.level == "team" and .devex == "flow state")]|length')"
kubectl -n metrics create configmap metric-review \
  --from-literal=metrics-total="$metrics_total" \
  --from-literal=individual-level-count="$individual_level_count" \
  --from-literal=satisfaction-count="$satisfaction_count" \
  --from-literal=performance-count="$performance_count" \
  --from-literal=activity-count="$activity_count" \
  --from-literal=communication-count="$communication_count" \
  --from-literal=efficiency-count="$efficiency_count" \
  --from-literal=thinnest-dimension="$thinnest_dimension" \
  --from-literal=perceptual-team-count="$perceptual_team_count" \
  --from-literal=workflow-team-count="$workflow_team_count" \
  --from-literal=feedback-loops-count="$feedback_loops_count" \
  --from-literal=cognitive-load-count="$cognitive_load_count" \
  --from-literal=flow-state-count="$flow_state_count" \
  --dry-run=client -o yaml | kubectl apply -f -
echo "[solution] Applied."
