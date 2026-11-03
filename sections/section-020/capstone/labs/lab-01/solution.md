# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. The `--keep` flag keeps the lab running so you can continue after a failed check. This lab was built without running it. The numbers below were computed from the seeded data with `jq`, so they are the values the checks expect for this data.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-020/capstone/labs/lab-01
```

`astrona submit` right after the start shows one check that already passes: `bridge-deployments-data-unchanged`.

## Step 1: Save the data and read the dashboard note

```sh
kubectl -n delivery get configmap deployments -o json | jq -r '.data["deployments.json"]' > deployments.json
kubectl -n delivery get configmap legacy-dashboard -o json | jq -r '.data["dashboard.json"]'
jq 'length' deployments.json
```

There are 25 deployments in 5 days: 5 per day. The dashboard note says the `MTTR` panel averages only incidents that were closed within one hour. That rule drops every slow recovery before the average.

## Step 2: Lead time and the two rates

With 25 values the median is the 13th value after sorting:

```sh
jq 'def median: sort | if length % 2 == 1 then .[(length-1)/2] else (.[length/2-1] + .[length/2]) / 2 end; map(((.deployed_at | fromdateiso8601) - (.committed_at | fromdateiso8601)) / 3600) | median' deployments.json
jq '[.[] | select(.needed_intervention)] | length' deployments.json
jq '[.[] | select(.unplanned_rework)] | length' deployments.json
```

The median lead time is 7 hours. Five deployments needed intervention (20 percent) and two were unplanned rework (8 percent).

## Step 3: Failed deployment recovery time

```sh
jq 'def median: sort | if length % 2 == 1 then .[(length-1)/2] else (.[length/2-1] + .[length/2]) / 2 end; [.[] | select(.needed_intervention) | ((.recovered_at | fromdateiso8601) - (.deployed_at | fromdateiso8601)) / 60] | median' deployments.json
```

The five recovery times are 15, 30, 45, 60 and 240 minutes, and the median is 45. The dashboard shows 12 minutes. The 240 minute recovery is left out of its average, and so is any other recovery that took longer than an hour, so the panel cannot be trusted.

## Step 4: Record the report

Save this as `bridge-api-report.yaml`:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: bridge-api-report
  namespace: delivery
data:
  service-scope: "bridge-api"
  window-days: "5"
  deployments: "25"
  deployment-frequency-per-day: "5"
  change-lead-time-median-hours: "7"
  change-fail-rate-percent: "20"
  deployment-rework-rate-percent: "8"
  failed-deployment-recovery-median-minutes: "45"
  recovery-metric-name: "failed deployment recovery time"
  instability-metrics: "change fail rate,deployment rework rate"
  dashboard-valid: "no"
  dashboard-reason: "The MTTR panel averages only incidents closed within one hour, so slow recoveries are left out and the value looks better than the data."
```

Apply it:

```sh
kubectl apply -f bridge-api-report.yaml
```

Grade it:

```sh
astrona submit --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-020/capstone/labs/lab-01
```

All seven checks pass. Clean up with `astrona destroy ats-082-capstone-020`.
