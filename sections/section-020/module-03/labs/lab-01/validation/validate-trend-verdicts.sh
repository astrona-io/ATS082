#!/usr/bin/env bash
# Check: The lead time and instability trends from Q2 to Q3 are named. The expected values are recomputed from the live data.
set -uo pipefail

fail=0
NS=delivery
REPORT=trend-report

read_key() {
  kubectl -n "$NS" get configmap "$REPORT" -o json 2>/dev/null | jq -r --arg key "$1" '.data[$key] // ""'
}

is_number() {
  [[ "$1" =~ ^-?[0-9]+(\.[0-9]+)?$ ]]
}

same_number() {
  awk -v a="$1" -v b="$2" 'BEGIN { d = a - b; if (d < 0) d = -d; exit !(d < 0.01) }'
}

# check_value KEY EXPECTED: the key must hold EXPECTED, as a number or as a lowercase word.
check_value() {
  local key="$1" expected="$2" actual
  actual="$(read_key "$key" | tr '[:upper:]' '[:lower:]' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
  expected="$(echo "$expected" | tr '[:upper:]' '[:lower:]')"
  if is_number "$expected"; then
    if ! is_number "$actual"; then
      echo "FAIL: key '$key' must be a number, found '$actual'"
      fail=1
    elif ! same_number "$actual" "$expected"; then
      echo "FAIL: key '$key' is $actual, the data gives $expected"
      fail=1
    fi
  elif [ "$actual" != "$expected" ]; then
    echo "FAIL: key '$key' is '$actual', the data gives '$expected'"
    fail=1
  fi
}

if ! kubectl -n "$NS" get configmap "$REPORT" >/dev/null 2>&1; then
  echo "FAIL: ConfigMap $REPORT not found in namespace $NS"
  exit 1
fi
data="$(kubectl -n "$NS" get configmap deployment-history -o json | jq -r '.data["deployments.json"]')"
check_value lead-time-trend-q2-to-q3 "$(echo "$data" | jq -r 'def med: sort | (length) as $n | if $n == 0 then null elif ($n % 2) == 1 then .[($n-1)/2] else (.[$n/2-1] + .[$n/2]) / 2 end; def pctl($p): sort | .[((length * $p) | ceil) - 1]; (([.[]|select(.quarter == "Q3")]|[.[].lead_time_hours]|med) < ([.[]|select(.quarter == "Q2")]|[.[].lead_time_hours]|med)) | if . then "faster" else "slower" end')"
check_value fail-rate-trend-q2-to-q3 "$(echo "$data" | jq -r 'def med: sort | (length) as $n | if $n == 0 then null elif ($n % 2) == 1 then .[($n-1)/2] else (.[$n/2-1] + .[$n/2]) / 2 end; def pctl($p): sort | .[((length * $p) | ceil) - 1]; ((([.[]|select(.quarter == "Q3")]|([.[]|select(.failed)]|length) * 100 / length) > ([.[]|select(.quarter == "Q2")]|([.[]|select(.failed)]|length) * 100 / length))) | if . then "worse" else "better" end')"
check_value recovery-trend-q2-to-q3 "$(echo "$data" | jq -r 'def med: sort | (length) as $n | if $n == 0 then null elif ($n % 2) == 1 then .[($n-1)/2] else (.[$n/2-1] + .[$n/2]) / 2 end; def pctl($p): sort | .[((length * $p) | ceil) - 1]; (([.[]|select(.quarter == "Q3")]|[.[]|select(.failed)|.recovery_minutes]|med) > ([.[]|select(.quarter == "Q2")]|[.[]|select(.failed)|.recovery_minutes]|med)) | if . then "worse" else "better" end')"

if [ "$fail" -eq 0 ]; then
  echo "PASS: The lead time and instability trends from Q2 to Q3 are named"
fi
exit "$fail"
