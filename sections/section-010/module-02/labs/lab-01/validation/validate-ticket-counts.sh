#!/usr/bin/env bash
# Check: tickets before (August, September) and after (October, November) the portal redesign.
set -uo pipefail

fail=0
NS=metrics
REPORT=experience-report

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

usage="$(kubectl -n "$NS" get configmap portal-usage -o json | jq -r '.data["usage.json"]')"
require_report
check_number tickets-before "$(echo "$usage" | jq '[.[] | select(.month < "2026-10") | .tickets] | add')"
check_number tickets-after "$(echo "$usage" | jq '[.[] | select(.month >= "2026-10") | .tickets] | add')"

if [ "$fail" -eq 0 ]; then
  echo "PASS: the ticket counts match the usage data"
fi
exit "$fail"
