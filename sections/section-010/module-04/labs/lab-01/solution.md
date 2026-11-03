# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. The `--keep` flag keeps the lab running so you can continue after a failed check. This lab was built without running it. The numbers below were computed from the seeded data with `jq`, so they are the values the checks expect for this data.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-010/module-04/labs/lab-01
```

`astrona submit` right after the start shows one check that already passes: `data-unchanged`. It stays your guard while you work.

## Step 1: Save the data and count the catalogue

```sh
kubectl -n metrics get configmap metric-catalogue -o json | jq -r '.data["metrics.json"]' > metrics.json
jq 'length' metrics.json
jq '[.[] | select(.level == "individual")] | length' metrics.json
```

The catalogue has 13 metrics and 2 of them are individual-level (`commits per developer` and `lines of code per developer`).

## Step 2: Count team-level metrics per dimension

```sh
jq -c '[.[] | select(.level == "team")] | group_by(.dimension) | map({dimension: .[0].dimension, n: length})' metrics.json
```

The counts are satisfaction 2, performance 2, activity 2, communication 1 and efficiency 4. The thinnest dimension is communication.

## Step 3: Measure types and DevEx areas

```sh
jq -c '[.[] | select(.level == "team")] | group_by(.measure) | map({measure: .[0].measure, n: length})' metrics.json
jq -c '[.[] | select(.level == "team")] | group_by(.devex) | map({devex: .[0].devex, n: length})' metrics.json
```

There are 3 perceptual and 8 workflow team-level metrics. The DevEx areas have 2 feedback loops, 2 cognitive load and 1 flow state team-level metrics. The remaining 6 team-level metrics have the value `none`.

## Step 4: Record the review

Save this as `metric-review.yaml`:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: metric-review
  namespace: metrics
data:
  metrics-total: "13"
  individual-level-count: "2"
  satisfaction-count: "2"
  performance-count: "2"
  activity-count: "2"
  communication-count: "1"
  efficiency-count: "4"
  thinnest-dimension: "communication"
  perceptual-team-count: "3"
  workflow-team-count: "8"
  feedback-loops-count: "2"
  cognitive-load-count: "2"
  flow-state-count: "1"
```

Apply it:

```sh
kubectl apply -f metric-review.yaml
```

Grade it:

```sh
astrona submit --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-010/module-04/labs/lab-01
```

All checks pass. Clean up with `astrona destroy ats-082-lab-010-04`.
