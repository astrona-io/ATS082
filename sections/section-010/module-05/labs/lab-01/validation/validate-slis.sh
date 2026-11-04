#!/usr/bin/env bash
# Check: SLI percentages are recorded. The expected values are recomputed from the live data.
set -uo pipefail

fail=0
NS=metrics
REPORT=slo-review

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
svc="$(kubectl -n "$NS" get configmap service-events -o json | jq -c '.data["services.json"]|fromjson')"
hr="$(kubectl -n "$NS" get configmap recent-hour -o json | jq -c '.data["hour.json"]|fromjson')"
check_value provisioning-api-sli-percent "$(jq -n -r --argjson svc "$svc" --argjson hr "$hr" '$svc|.[]|select(.service=="provisioning-api")|(.good_events*100/.total_events)')"
check_value pipeline-runner-sli-percent "$(jq -n -r --argjson svc "$svc" --argjson hr "$hr" '$svc|.[]|select(.service=="pipeline-runner")|(.good_events*100/.total_events)')"
check_value portal-sli-percent "$(jq -n -r --argjson svc "$svc" --argjson hr "$hr" '$svc|.[]|select(.service=="portal")|(.good_events*100/.total_events)')"
check_value artifact-registry-sli-percent "$(jq -n -r --argjson svc "$svc" --argjson hr "$hr" '$svc|.[]|select(.service=="artifact-registry")|(.good_events*100/.total_events)')"

if [ "$fail" -eq 0 ]; then
  echo "PASS: SLI percentages are recorded"
fi
exit "$fail"
