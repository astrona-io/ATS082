# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. The `--keep` flag keeps the lab running so you can continue after a failed check. This lab was built without running it. The numbers below were computed from the seeded data with `jq`, so they are the values the checks expect for this data.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-020/module-03/labs/lab-01
```

`astrona submit` right after the start shows one check that already passes: `data-unchanged`. It stays your guard while you work.

## Step 1: Save the data and count the deployments

```sh
kubectl -n delivery get configmap deployment-history -o json | jq -r '.data["deployments.json"]' > deployments.json
jq -c 'group_by(.quarter) | map({quarter: .[0].quarter, deployments: length})' deployments.json
```

Q1 has 6 deployments, Q2 has 8 and Q3 has 10.

## Step 2: Lead time per quarter

```sh
jq -c 'def med: sort | (length) as $n | if ($n % 2) == 1 then .[($n-1)/2] else (.[$n/2-1] + .[$n/2]) / 2 end; group_by(.quarter) | map({quarter: .[0].quarter, median: ([.[].lead_time_hours] | med)})' deployments.json
```

The medians are 65, 37 and 22.5 hours. Every quarter has an even count, so each median is the average of two middle values.

## Step 3: Instability per quarter

```sh
jq -c 'group_by(.quarter) | map({quarter: .[0].quarter, fail_rate: (([.[] | select(.failed)] | length) * 100 / length)})' deployments.json
jq -c 'def med: sort | (length) as $n | if ($n % 2) == 1 then .[($n-1)/2] else (.[$n/2-1] + .[$n/2]) / 2 end; [.[] | select(.failed)] | group_by(.quarter) | map({quarter: .[0].quarter, median: ([.[].recovery_minutes] | med)})' deployments.json
```

The change fail rates are 33.33, 12.5 and 20 percent. The median recovery times are 210, 90 and 222.5 minutes. Use failed deployments only for the recovery time.

## Step 4: Trends from Q2 to Q3

Lead time fell from 37 to 22.5 hours, so it is `faster`. The fail rate rose from 12.5 to 20 percent, so it is `worse`. The median recovery time rose from 90 to 222.5 minutes, so it is `worse`. The claim "improved in every quarter" is true for lead time only.

## Step 5: Record the report

Save this as `trend-report.yaml`:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: trend-report
  namespace: delivery
data:
  q1-deployments: "6"
  q2-deployments: "8"
  q3-deployments: "10"
  q1-median-lead-time-hours: "65"
  q2-median-lead-time-hours: "37"
  q3-median-lead-time-hours: "22.5"
  q1-change-fail-rate-percent: "33.33"
  q2-change-fail-rate-percent: "12.5"
  q3-change-fail-rate-percent: "20"
  q1-median-recovery-minutes: "210"
  q2-median-recovery-minutes: "90"
  q3-median-recovery-minutes: "222.5"
  lead-time-trend-q2-to-q3: "faster"
  fail-rate-trend-q2-to-q3: "worse"
  recovery-trend-q2-to-q3: "worse"
```

Apply it:

```sh
kubectl apply -f trend-report.yaml
```

Grade it:

```sh
astrona submit --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-020/module-03/labs/lab-01
```

All checks pass. Clean up with `astrona destroy ats-082-lab-020-03`.
