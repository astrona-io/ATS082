#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail

data="$(kubectl -n delivery get configmap service-metrics -o json | jq -r '.data["metrics.json"]')"
improved="$(echo "$data" | jq -r '[.[] | select(.platform_pipeline and .after.lead_time_hours < .before.lead_time_hours and .after.deploys_per_week > .before.deploys_per_week) | .service] | sort | join(",")')"
worse="$(echo "$data" | jq -r '[.[] | select(.platform_pipeline and (.after.change_fail_rate_percent > .before.change_fail_rate_percent or .after.rework_rate_percent > .before.rework_rate_percent)) | .service] | sort | join(",")')"
without="$(echo "$data" | jq -r '[.[] | select((.platform_pipeline | not) and .after.lead_time_hours < .before.lead_time_hours) | .service] | sort | join(",")')"
kubectl -n delivery create configmap delivery-interpretation \
  --from-literal=recovery-metric-name="failed deployment recovery time" \
  --from-literal=throughput-improved="$improved" --from-literal=instability-worsened="$worse" \
  --from-literal=improved-without-platform="$without" \
  --from-literal=platform-claim=not-proven --from-literal=scope-decision=per-service \
  --from-literal=claim-reason="One service got less stable and a service outside the pipeline also improved, so the data does not prove the pipeline made every team better" \
  --dry-run=client -o yaml | kubectl apply -f -
echo "[solution] Applied."
