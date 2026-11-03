# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. The `--keep` flag keeps the lab running so you can continue after a failed check. This lab was built without running it. The numbers below were computed from the seeded data with `jq`, so they are the values the checks expect for this data.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-020/module-01/labs/lab-01
```

`astrona submit` right after the start shows one check that already passes: `deployments-data-unchanged`.

## Step 1: Save the data and compute the frequency

```sh
kubectl -n delivery get configmap deployments -o json | jq -r '.data["deployments.json"]' > deployments.json
jq 'length' deployments.json
```

There are 20 deployments in 10 days, which is 2 deployments per day.

## Step 2: Change lead time

`fromdateiso8601` turns a UTC timestamp into seconds. Subtract, divide by 3600 for hours, sort and take the median. With 20 values, the median is the average of the 10th and the 11th value:

```sh
jq 'def median: sort | if length % 2 == 1 then .[(length-1)/2] else (.[length/2-1] + .[length/2]) / 2 end; map(((.deployed_at | fromdateiso8601) - (.committed_at | fromdateiso8601)) / 3600) | median' deployments.json
```

The median is 6 hours. The mean is 10.3 hours, pulled up by three changes that waited 26, 30 and 48 hours.

## Step 3: Change fail rate and rework rate

Count the two sets separately. They are not the same deployments:

```sh
jq '[.[] | select(.needed_intervention)] | length' deployments.json
jq '[.[] | select(.unplanned_rework)] | length' deployments.json
```

Five deployments needed intervention, which is 25 percent of 20. Two deployments were unplanned rework, which is 10 percent.

## Step 4: Failed deployment recovery time

Only failed deployments have `recovered_at`. Compute minutes and take the median of the 5 values:

```sh
jq 'def median: sort | if length % 2 == 1 then .[(length-1)/2] else (.[length/2-1] + .[length/2]) / 2 end; [.[] | select(.needed_intervention) | ((.recovered_at | fromdateiso8601) - (.deployed_at | fromdateiso8601)) / 60] | median' deployments.json
```

The recovery times are 20, 35, 50, 90 and 300 minutes, so the median is 50.

## Step 5: Record the report

Save this as `delivery-report.yaml`:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: delivery-report
  namespace: delivery
data:
  service: "shuttle-api"
  window-days: "10"
  deployments: "20"
  deployment-frequency-per-day: "2"
  change-lead-time-median-hours: "6"
  change-fail-rate-percent: "25"
  failed-deployment-recovery-median-minutes: "50"
  deployment-rework-rate-percent: "10"
```

Apply it:

```sh
kubectl apply -f delivery-report.yaml
```

Grade it:

```sh
astrona submit --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-020/module-01/labs/lab-01
```

All six checks pass. Clean up with `astrona destroy ats-082-lab-020-01`.
