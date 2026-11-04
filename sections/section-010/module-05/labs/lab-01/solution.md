# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. The `--keep` flag keeps the lab running so you can continue after a failed check. This lab was built without running it. The numbers below were computed from the seeded data with `jq`, so they are the values the checks expect for this data.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-010/module-05/labs/lab-01
```

`astrona submit` right after the start shows one check that already passes: `data-unchanged`. It stays your guard while you work.

## Step 1: Save the data and compute the SLI

```sh
kubectl -n metrics get configmap service-events -o json | jq -r '.data["services.json"]' > services.json
jq -c '.[] | {service, sli: (.good_events * 100 / .total_events), slo: .slo_target_percent}' services.json
```

The SLI values are 99.7 for `provisioning-api`, 99.4 for `pipeline-runner`, 99.95 for `portal` and 99.89 for `artifact-registry`.

## Step 2: Compute the error budget used

```sh
jq -c '.[] | {service, bad: (.total_events - .good_events), allowed: (.total_events * (100 - .slo_target_percent) / 100)}' services.json
```

The allowed bad events are 1000, 250, 100 and 100. The bad events are 600, 300, 50 and 110. The share of budget used is 60, 120, 50 and 110 percent.

## Step 3: Find the services that miss the SLO

A service misses its SLO when its SLI is below its own target. `pipeline-runner` (99.4 against 99.5) and `artifact-registry` (99.89 against 99.9) miss. `provisioning-api` and `portal` meet their targets. The service with the largest share of budget used is `pipeline-runner` at 120 percent.

## Step 4: Compute the burn rate

```sh
kubectl -n metrics get configmap recent-hour -o json | jq -r '.data["hour.json"]'
```

The last hour had 100 bad events out of 10000, an error ratio of 0.01. The SLO of `provisioning-api` allows an error ratio of 0.005. The burn rate is 0.01 divided by 0.005, which is 2. A full budget lasts 30 divided by 2, which is 15 days.

## Step 5: Record the review

Save this as `slo-review.yaml`:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: slo-review
  namespace: metrics
data:
  provisioning-api-sli-percent: "99.7"
  pipeline-runner-sli-percent: "99.4"
  portal-sli-percent: "99.95"
  artifact-registry-sli-percent: "99.89"
  provisioning-api-budget-used-percent: "60"
  pipeline-runner-budget-used-percent: "120"
  portal-budget-used-percent: "50"
  artifact-registry-budget-used-percent: "110"
  services-missing-slo: "artifact-registry,pipeline-runner"
  most-budget-used-service: "pipeline-runner"
  provisioning-api-burn-rate: "2"
  days-to-exhaust-budget: "15"
```

Apply it:

```sh
kubectl apply -f slo-review.yaml
```

Grade it:

```sh
astrona submit --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-010/module-05/labs/lab-01
```

All checks pass. Clean up with `astrona destroy ats-082-lab-010-05`.
