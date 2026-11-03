#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail

data="$(kubectl -n delivery get configmap deployment-history -o json | jq -r '.data["deployments.json"]')"
q1_deployments="$(echo "$data" | jq -r 'def med: sort | (length) as $n | if $n == 0 then null elif ($n % 2) == 1 then .[($n-1)/2] else (.[$n/2-1] + .[$n/2]) / 2 end; def pctl($p): sort | .[((length * $p) | ceil) - 1]; [.[]|select(.quarter == "Q1")]|length')"
q2_deployments="$(echo "$data" | jq -r 'def med: sort | (length) as $n | if $n == 0 then null elif ($n % 2) == 1 then .[($n-1)/2] else (.[$n/2-1] + .[$n/2]) / 2 end; def pctl($p): sort | .[((length * $p) | ceil) - 1]; [.[]|select(.quarter == "Q2")]|length')"
q3_deployments="$(echo "$data" | jq -r 'def med: sort | (length) as $n | if $n == 0 then null elif ($n % 2) == 1 then .[($n-1)/2] else (.[$n/2-1] + .[$n/2]) / 2 end; def pctl($p): sort | .[((length * $p) | ceil) - 1]; [.[]|select(.quarter == "Q3")]|length')"
q1_median_lead_time_hours="$(echo "$data" | jq -r 'def med: sort | (length) as $n | if $n == 0 then null elif ($n % 2) == 1 then .[($n-1)/2] else (.[$n/2-1] + .[$n/2]) / 2 end; def pctl($p): sort | .[((length * $p) | ceil) - 1]; [.[]|select(.quarter == "Q1")]|[.[].lead_time_hours]|med')"
q2_median_lead_time_hours="$(echo "$data" | jq -r 'def med: sort | (length) as $n | if $n == 0 then null elif ($n % 2) == 1 then .[($n-1)/2] else (.[$n/2-1] + .[$n/2]) / 2 end; def pctl($p): sort | .[((length * $p) | ceil) - 1]; [.[]|select(.quarter == "Q2")]|[.[].lead_time_hours]|med')"
q3_median_lead_time_hours="$(echo "$data" | jq -r 'def med: sort | (length) as $n | if $n == 0 then null elif ($n % 2) == 1 then .[($n-1)/2] else (.[$n/2-1] + .[$n/2]) / 2 end; def pctl($p): sort | .[((length * $p) | ceil) - 1]; [.[]|select(.quarter == "Q3")]|[.[].lead_time_hours]|med')"
q1_change_fail_rate_percent="$(echo "$data" | jq -r 'def med: sort | (length) as $n | if $n == 0 then null elif ($n % 2) == 1 then .[($n-1)/2] else (.[$n/2-1] + .[$n/2]) / 2 end; def pctl($p): sort | .[((length * $p) | ceil) - 1]; [.[]|select(.quarter == "Q1")]|([.[]|select(.failed)]|length) * 100 / length')"
q2_change_fail_rate_percent="$(echo "$data" | jq -r 'def med: sort | (length) as $n | if $n == 0 then null elif ($n % 2) == 1 then .[($n-1)/2] else (.[$n/2-1] + .[$n/2]) / 2 end; def pctl($p): sort | .[((length * $p) | ceil) - 1]; [.[]|select(.quarter == "Q2")]|([.[]|select(.failed)]|length) * 100 / length')"
q3_change_fail_rate_percent="$(echo "$data" | jq -r 'def med: sort | (length) as $n | if $n == 0 then null elif ($n % 2) == 1 then .[($n-1)/2] else (.[$n/2-1] + .[$n/2]) / 2 end; def pctl($p): sort | .[((length * $p) | ceil) - 1]; [.[]|select(.quarter == "Q3")]|([.[]|select(.failed)]|length) * 100 / length')"
q1_median_recovery_minutes="$(echo "$data" | jq -r 'def med: sort | (length) as $n | if $n == 0 then null elif ($n % 2) == 1 then .[($n-1)/2] else (.[$n/2-1] + .[$n/2]) / 2 end; def pctl($p): sort | .[((length * $p) | ceil) - 1]; [.[]|select(.quarter == "Q1")]|[.[]|select(.failed)|.recovery_minutes]|med')"
q2_median_recovery_minutes="$(echo "$data" | jq -r 'def med: sort | (length) as $n | if $n == 0 then null elif ($n % 2) == 1 then .[($n-1)/2] else (.[$n/2-1] + .[$n/2]) / 2 end; def pctl($p): sort | .[((length * $p) | ceil) - 1]; [.[]|select(.quarter == "Q2")]|[.[]|select(.failed)|.recovery_minutes]|med')"
q3_median_recovery_minutes="$(echo "$data" | jq -r 'def med: sort | (length) as $n | if $n == 0 then null elif ($n % 2) == 1 then .[($n-1)/2] else (.[$n/2-1] + .[$n/2]) / 2 end; def pctl($p): sort | .[((length * $p) | ceil) - 1]; [.[]|select(.quarter == "Q3")]|[.[]|select(.failed)|.recovery_minutes]|med')"
lead_time_trend_q2_to_q3="$(echo "$data" | jq -r 'def med: sort | (length) as $n | if $n == 0 then null elif ($n % 2) == 1 then .[($n-1)/2] else (.[$n/2-1] + .[$n/2]) / 2 end; def pctl($p): sort | .[((length * $p) | ceil) - 1]; (([.[]|select(.quarter == "Q3")]|[.[].lead_time_hours]|med) < ([.[]|select(.quarter == "Q2")]|[.[].lead_time_hours]|med)) | if . then "faster" else "slower" end')"
fail_rate_trend_q2_to_q3="$(echo "$data" | jq -r 'def med: sort | (length) as $n | if $n == 0 then null elif ($n % 2) == 1 then .[($n-1)/2] else (.[$n/2-1] + .[$n/2]) / 2 end; def pctl($p): sort | .[((length * $p) | ceil) - 1]; ((([.[]|select(.quarter == "Q3")]|([.[]|select(.failed)]|length) * 100 / length) > ([.[]|select(.quarter == "Q2")]|([.[]|select(.failed)]|length) * 100 / length))) | if . then "worse" else "better" end')"
recovery_trend_q2_to_q3="$(echo "$data" | jq -r 'def med: sort | (length) as $n | if $n == 0 then null elif ($n % 2) == 1 then .[($n-1)/2] else (.[$n/2-1] + .[$n/2]) / 2 end; def pctl($p): sort | .[((length * $p) | ceil) - 1]; (([.[]|select(.quarter == "Q3")]|[.[]|select(.failed)|.recovery_minutes]|med) > ([.[]|select(.quarter == "Q2")]|[.[]|select(.failed)|.recovery_minutes]|med)) | if . then "worse" else "better" end')"
kubectl -n delivery create configmap trend-report \
  --from-literal=q1-deployments="$q1_deployments" \
  --from-literal=q2-deployments="$q2_deployments" \
  --from-literal=q3-deployments="$q3_deployments" \
  --from-literal=q1-median-lead-time-hours="$q1_median_lead_time_hours" \
  --from-literal=q2-median-lead-time-hours="$q2_median_lead_time_hours" \
  --from-literal=q3-median-lead-time-hours="$q3_median_lead_time_hours" \
  --from-literal=q1-change-fail-rate-percent="$q1_change_fail_rate_percent" \
  --from-literal=q2-change-fail-rate-percent="$q2_change_fail_rate_percent" \
  --from-literal=q3-change-fail-rate-percent="$q3_change_fail_rate_percent" \
  --from-literal=q1-median-recovery-minutes="$q1_median_recovery_minutes" \
  --from-literal=q2-median-recovery-minutes="$q2_median_recovery_minutes" \
  --from-literal=q3-median-recovery-minutes="$q3_median_recovery_minutes" \
  --from-literal=lead-time-trend-q2-to-q3="$lead_time_trend_q2_to_q3" \
  --from-literal=fail-rate-trend-q2-to-q3="$fail_rate_trend_q2_to_q3" \
  --from-literal=recovery-trend-q2-to-q3="$recovery_trend_q2_to_q3" \
  --dry-run=client -o yaml | kubectl apply -f -
echo "[solution] Applied."
