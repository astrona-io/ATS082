#!/usr/bin/env bash
# Check: Waste is recorded in cores and in money. The expected values are recomputed from the live data.
set -uo pipefail

fail=0
NS=metrics
REPORT=cost-review

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
teams="$(kubectl -n "$NS" get configmap team-resources -o json | jq -c '.data["teams.json"]|fromjson')"
cost="$(kubectl -n "$NS" get configmap platform-cost -o json | jq -c '.data["cost.json"]|fromjson')"
check_value most-wasted-cores-team "$(jq -n -r --argjson teams "$teams" --argjson cost "$cost" '$teams|max_by(.cpu_requested_millicores-.cpu_used_millicores)|.team')"
check_value most-wasted-cost-team "$(jq -n -r --argjson teams "$teams" --argjson cost "$cost" '$teams|max_by(.monthly_cost*(.cpu_requested_millicores-.cpu_used_millicores)/.cpu_requested_millicores)|.team')"
check_value waste-cost-total "$(jq -n -r --argjson teams "$teams" --argjson cost "$cost" '$teams|map(.monthly_cost*(.cpu_requested_millicores-.cpu_used_millicores)/.cpu_requested_millicores)|add')"

if [ "$fail" -eq 0 ]; then
  echo "PASS: Waste is recorded in cores and in money"
fi
exit "$fail"
