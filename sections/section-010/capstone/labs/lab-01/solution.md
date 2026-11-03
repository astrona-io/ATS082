# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. The `--keep` flag keeps the lab running so you can continue after a failed check. This lab was built without running it. The numbers below were computed from the seeded data with `jq`, so they are the values the checks expect for this data.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-010/capstone/labs/lab-01
```

`astrona submit` right after the start shows one check that already passes: `environment-requests-data-unchanged`.

## Step 1: Save the data and count the outcomes

```sh
kubectl -n metrics get configmap environment-requests -o json | jq -r '.data["requests.json"]' > requests.json
kubectl -n metrics get configmap latency-claim -o json | jq -r '.data["claim.json"]'
kubectl -n metrics get configmap kpi-proposal -o json | jq -r '.data["proposal.json"]'
```

Count the outcomes:

```sh
jq 'group_by(.outcome) | map({outcome: .[0].outcome, n: length})' requests.json
```

There are 20 attempts: 13 completed, 3 failed and 4 abandoned. The completion rate is 13 divided by 20, which is 65 percent.

## Step 2: The 90th percentile from timestamps

`fromdateiso8601` turns a UTC timestamp into seconds, so a subtraction gives the time to complete. Keep only completed requests:

```sh
jq 'def pctl($p): sort | .[((length * $p) | ceil) - 1]; def secs: ((.ended_at | fromdateiso8601) - (.requested_at | fromdateiso8601)); [.[] | select(.outcome == "completed") | secs] | pctl(0.9)' requests.json
```

With 13 completed requests, the nearest-rank position is `ceil(0.9 x 13)`, which is 12. The value is 900 seconds. The dashboard limit is 300 seconds, so the claim does not hold. The 90th percentile is 900 seconds even though the 4 abandoned and 3 failed requests are not counted at all.

## Step 3: The worst class

```sh
jq 'group_by(.class) | map({class: .[0].class, attempts: length, rate: (([.[] | select(.outcome == "completed")] | length) * 100 / length)})' requests.json
```

The class `large` has 8 attempts and 4 completed: 50 percent. The class `small` has 12 attempts and 9 completed: 75 percent. The worst class is `large`.

## Step 4: Record the evidence

Save this as `outcome-evidence.yaml`:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: outcome-evidence
  namespace: metrics
data:
  attempts: "20"
  completed: "13"
  abandoned: "4"
  completion-rate-percent: "65"
  p90-completed-seconds: "900"
  worst-class: "large"
  worst-class-completion-rate-percent: "50"
  claim-supported: "no"
  claim-reason: "The 90th percentile of completed requests is 900 seconds, above the 300 second limit, and abandoned requests are not counted."
  proposal-decision: "reject"
  proposal-reason: "Ranking people by request count rewards extra requests instead of outcomes, and teams will inflate the number."
```

Apply it:

```sh
kubectl apply -f outcome-evidence.yaml
```

Grade it:

```sh
astrona submit --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-010/capstone/labs/lab-01
```

All six checks pass. Clean up with `astrona destroy ats-082-capstone-010`.
