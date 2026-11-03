#!/usr/bin/env bash
# Check: Team-level metrics are counted per SPACE dimension. The expected values are recomputed from the live data.
set -uo pipefail

fail=0
NS=metrics
REPORT=metric-review

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
data="$(kubectl -n "$NS" get configmap metric-catalogue -o json | jq -r '.data["metrics.json"]')"
check_value satisfaction-count "$(echo "$data" | jq -r 'def med: sort | (length) as $n | if $n == 0 then null elif ($n % 2) == 1 then .[($n-1)/2] else (.[$n/2-1] + .[$n/2]) / 2 end; def pctl($p): sort | .[((length * $p) | ceil) - 1]; [.[]|select(.level == "team" and .dimension == "satisfaction")]|length')"
check_value performance-count "$(echo "$data" | jq -r 'def med: sort | (length) as $n | if $n == 0 then null elif ($n % 2) == 1 then .[($n-1)/2] else (.[$n/2-1] + .[$n/2]) / 2 end; def pctl($p): sort | .[((length * $p) | ceil) - 1]; [.[]|select(.level == "team" and .dimension == "performance")]|length')"
check_value activity-count "$(echo "$data" | jq -r 'def med: sort | (length) as $n | if $n == 0 then null elif ($n % 2) == 1 then .[($n-1)/2] else (.[$n/2-1] + .[$n/2]) / 2 end; def pctl($p): sort | .[((length * $p) | ceil) - 1]; [.[]|select(.level == "team" and .dimension == "activity")]|length')"
check_value communication-count "$(echo "$data" | jq -r 'def med: sort | (length) as $n | if $n == 0 then null elif ($n % 2) == 1 then .[($n-1)/2] else (.[$n/2-1] + .[$n/2]) / 2 end; def pctl($p): sort | .[((length * $p) | ceil) - 1]; [.[]|select(.level == "team" and .dimension == "communication")]|length')"
check_value efficiency-count "$(echo "$data" | jq -r 'def med: sort | (length) as $n | if $n == 0 then null elif ($n % 2) == 1 then .[($n-1)/2] else (.[$n/2-1] + .[$n/2]) / 2 end; def pctl($p): sort | .[((length * $p) | ceil) - 1]; [.[]|select(.level == "team" and .dimension == "efficiency")]|length')"

if [ "$fail" -eq 0 ]; then
  echo "PASS: Team-level metrics are counted per SPACE dimension"
fi
exit "$fail"
