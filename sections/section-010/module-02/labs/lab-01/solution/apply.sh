#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail

usage="$(kubectl -n metrics get configmap portal-usage -o json | jq -r '.data["usage.json"]')"
survey="$(kubectl -n metrics get configmap survey-responses -o json | jq -r '.data["survey.json"]')"
tb="$(echo "$usage" | jq '[.[] | select(.month < "2026-10") | .tickets] | add')"
ta="$(echo "$usage" | jq '[.[] | select(.month >= "2026-10") | .tickets] | add')"
rb="$(echo "$usage" | jq '[.[] | select(.month < "2026-10")] | ([.[].tasks_completed] | add) * 100 / ([.[].sessions_started] | add)')"
ra="$(echo "$usage" | jq '[.[] | select(.month >= "2026-10")] | ([.[].tasks_completed] | add) * 100 / ([.[].sessions_started] | add)')"
top="$(echo "$survey" | jq -r 'group_by(.theme) | map({theme: .[0].theme, n: length}) | sort_by(-.n) | .[0].theme')"
kubectl -n metrics create configmap experience-report \
  --from-literal=tickets-before="$tb" --from-literal=tickets-after="$ta" \
  --from-literal=completion-rate-before-percent="$rb" --from-literal=completion-rate-after-percent="$ra" \
  --from-literal=top-survey-theme="$top" \
  --from-literal=confounders="Environment quota per team was reduced from 5 to 2 on 2026-10-12, in the same period as the redesign" \
  --from-literal=verdict=worse \
  --dry-run=client -o yaml | kubectl apply -f -
echo "[solution] Applied."
