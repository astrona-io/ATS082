# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. The `--keep` flag keeps the lab running so you can continue after a failed check. This lab was built without running it. The numbers below were computed from the seeded data with `jq`, so they are the values the checks expect for this data.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-010/module-01/labs/lab-01
```

`astrona submit` right after the start shows one check that already passes: `requests-data-unchanged`. It stays your guard while you work.

## Step 1: Save the data and count the outcomes

Read the JSON out of the ConfigMap into a local file. Reading it once keeps every later command short:

```sh
kubectl -n metrics get configmap provisioning-requests -o json | jq -r '.data["requests.json"]' > requests.json
```

Count the attempts and the three outcomes:

```sh
jq 'length' requests.json
jq 'group_by(.outcome) | map({outcome: .[0].outcome, n: length})' requests.json
```

There are 20 attempts: 12 `completed`, 5 `failed` and 3 `abandoned`. The dashboard average of 125 seconds is the mean of the 12 completed requests only, so 8 of 20 attempts are missing from it.

## Step 2: Completion rate and percentiles

The completion rate has all 20 attempts in the denominator: 12 divided by 20 gives 60 percent. For the percentiles, keep only completed requests, sort their `seconds` and pick the nearest-rank position:

```sh
jq 'def pctl($p): sort | .[((length * $p) | ceil) - 1]; [.[] | select(.outcome == "completed") | .seconds] | {p50: pctl(0.5), p90: pctl(0.9)}' requests.json
```

With 12 completed values, the median is at position 6 and the 90th percentile is at position 11. The result is `p50` 80 and `p90` 110. The mean of 125 is higher than the median because one large request took 600 seconds.

## Step 3: Find the worst class

Group by class and compute the completion rate of each group:

```sh
jq 'group_by(.class) | map({class: .[0].class, attempts: length, rate: (([.[] | select(.outcome == "completed")] | length) * 100 / length)})' requests.json
```

The class `large` has 8 attempts and 2 completed, a rate of 25 percent. The class `small` has 12 attempts and 10 completed. The worst class is `large`.

## Step 4: Record the report

Save this as `outcome-report.yaml`:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: outcome-report
  namespace: metrics
data:
  attempts: "20"
  completed: "12"
  failed: "5"
  abandoned: "3"
  completion-rate-percent: "60"
  p50-completed-seconds: "80"
  p90-completed-seconds: "110"
  worst-class: "large"
  worst-class-completion-rate-percent: "25"
```

Apply it:

```sh
kubectl apply -f outcome-report.yaml
```

Grade it:

```sh
astrona submit --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-010/module-01/labs/lab-01
```

All five checks pass. Clean up with `astrona destroy ats-082-lab-010-01`.
