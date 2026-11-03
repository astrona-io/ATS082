#!/usr/bin/env bash
# Check: attempts, completed requests and the completion rate. The expected values are recomputed from the live data.
set -uo pipefail

fail=0
NS=metrics
REPORT=outcome-report

read_key() {
  kubectl -n "$NS" get configmap "$REPORT" -o json 2>/dev/null | jq -r --arg key "$1" '.data[$key] // ""'
}

is_number() {
  [[ "$1" =~ ^-?[0-9]+(\.[0-9]+)?$ ]]
}

same_number() {
  awk -v a="$1" -v b="$2" 'BEGIN { d = a - b; if (d < 0) d = -d; exit !(d < 0.01) }'
}

# check_number KEY EXPECTED: the key must hold a number equal to EXPECTED.
check_number() {
  local key="$1" expected="$2" actual
  actual="$(read_key "$key")"
  if ! is_number "$actual"; then
    echo "FAIL: key '$key' must be a number, found '$actual'"
    fail=1
  elif ! same_number "$actual" "$expected"; then
    echo "FAIL: key '$key' is $actual, the data gives $expected"
    fail=1
  fi
}

# check_text KEY EXPECTED: the key must equal EXPECTED (case-insensitive, trimmed).
check_text() {
  local key="$1" expected="$2" actual
  actual="$(read_key "$key" | tr '[:upper:]' '[:lower:]' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
  if [ "$actual" != "$expected" ]; then
    echo "FAIL: key '$key' is '$actual', expected '$expected'"
    fail=1
  fi
}

# check_set KEY EXPECTED: comma-separated names, same members in any order.
check_set() {
  local key="$1" expected="$2" actual
  actual="$(read_key "$key" | tr '[:upper:]' '[:lower:]' | tr ',' '\n' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' | grep -v '^$' | sort | paste -sd, -)"
  if [ "$actual" != "$expected" ]; then
    echo "FAIL: key '$key' is '$actual', expected '$expected'"
    fail=1
  fi
}

require_report() {
  if ! kubectl -n "$NS" get configmap "$REPORT" >/dev/null 2>&1; then
    echo "FAIL: ConfigMap $REPORT not found in namespace $NS"
    exit 1
  fi
}

data="$(kubectl -n "$NS" get configmap provisioning-requests -o json | jq -r '.data["requests.json"]')"
require_report
attempts="$(echo "$data" | jq 'length')"
completed="$(echo "$data" | jq '[.[] | select(.outcome == "completed")] | length')"
check_number attempts "$attempts"
check_number completed "$completed"
check_number completion-rate-percent "$(awk -v c="$completed" -v a="$attempts" 'BEGIN { print c * 100 / a }')"

if [ "$fail" -eq 0 ]; then
  echo "PASS: attempts, completed requests and completion rate match the data"
fi
exit "$fail"
