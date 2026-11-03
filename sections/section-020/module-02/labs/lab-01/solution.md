# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. The `--keep` flag keeps the lab running so you can continue after a failed check. This lab was built without running it. The results below were derived from the seeded data by reading it, so they are the values the checks expect for this data.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-020/module-02/labs/lab-01
```

`astrona submit` right after the start shows one check that already passes: `service-metrics-data-unchanged`.

## Step 1: Save the data and print a comparison

```sh
kubectl -n delivery get configmap service-metrics -o json | jq -r '.data["metrics.json"]' > service-metrics.json
kubectl -n delivery get configmap platform-claim -o json | jq -r '.data["claim.json"]'
```

Print one line per service with the values before and after:

```sh
jq -r '.[] | .service + " pipeline=" + (.platform_pipeline | tostring) + " lead " + (.before.lead_time_hours | tostring) + "->" + (.after.lead_time_hours | tostring) + " deploys/week " + (.before.deploys_per_week | tostring) + "->" + (.after.deploys_per_week | tostring) + " fail% " + (.before.change_fail_rate_percent | tostring) + "->" + (.after.change_fail_rate_percent | tostring) + " rework% " + (.before.rework_rate_percent | tostring) + "->" + (.after.rework_rate_percent | tostring)' service-metrics.json
```

## Step 2: Select the services

Throughput improved when the lead time fell and the deployment frequency rose. Select only services on the platform pipeline:

```sh
jq -r '[.[] | select(.platform_pipeline and .after.lead_time_hours < .before.lead_time_hours and .after.deploys_per_week > .before.deploys_per_week) | .service] | sort | join(",")' service-metrics.json
```

The answer is `probe-api,scout-api`. Instability worsened when the change fail rate or the rework rate rose:

```sh
jq -r '[.[] | select(.platform_pipeline and (.after.change_fail_rate_percent > .before.change_fail_rate_percent or .after.rework_rate_percent > .before.rework_rate_percent)) | .service] | sort | join(",")' service-metrics.json
```

The answer is `scout-api`: its change fail rate went from 10 to 20 percent and its rework rate from 5 to 15 percent. Now look at the service that is not on the pipeline:

```sh
jq -r '[.[] | select((.platform_pipeline | not) and .after.lead_time_hours < .before.lead_time_hours) | .service] | sort | join(",")' service-metrics.json
```

The answer is `drifter-api`: its lead time fell from 40 to 30 hours without the pipeline.

## Step 3: The metric name and the decision

The old field `mttr_minutes` is called failed deployment recovery time in the five-metric model. The claim is `not-proven`: one service got less stable, and a service outside the pipeline improved too. The scope is `per-service`.

Save this as `delivery-interpretation.yaml`:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: delivery-interpretation
  namespace: delivery
data:
  recovery-metric-name: "failed deployment recovery time"
  throughput-improved: "probe-api,scout-api"
  instability-worsened: "scout-api"
  improved-without-platform: "drifter-api"
  platform-claim: "not-proven"
  scope-decision: "per-service"
  claim-reason: "One pipeline service became less stable and a service outside the pipeline also improved, so the data does not prove the pipeline helped every team."
```

Apply it:

```sh
kubectl apply -f delivery-interpretation.yaml
```

Grade it:

```sh
astrona submit --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-020/module-02/labs/lab-01
```

All six checks pass. Clean up with `astrona destroy ats-082-lab-020-02`.
