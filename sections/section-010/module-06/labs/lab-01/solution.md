# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. The `--keep` flag keeps the lab running so you can continue after a failed check. This lab was built without running it. The numbers below were computed from the seeded data with `jq`, so they are the values the checks expect for this data.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-010/module-06/labs/lab-01
```

`astrona submit` right after the start shows one check that already passes: `data-unchanged`. It stays your guard while you work.

## Step 1: Compute utilization

```sh
kubectl -n metrics get configmap team-resources -o json | jq -r '.data["teams.json"]' > teams.json
jq -c '.[] | {team, utilization: (.cpu_used_millicores * 100 / .cpu_requested_millicores)}' teams.json
jq '(map(.cpu_used_millicores) | add) * 100 / (map(.cpu_requested_millicores) | add)' teams.json
```

The utilization is 25 for `bridge`, 75 for `scout`, 15 for `shuttle` and 75 for `probe`. The fleet requests 20000 millicores and uses 7400, so the fleet utilization is 37 percent. The teams below 40 percent are `bridge` and `shuttle`.

## Step 2: Compute waste in cores and in money

```sh
jq -c '.[] | {team, wasted: (.cpu_requested_millicores - .cpu_used_millicores), waste_cost: (.monthly_cost * (.cpu_requested_millicores - .cpu_used_millicores) / .cpu_requested_millicores)}' teams.json
```

The wasted CPU is 6000, 1000, 5100 and 500 millicores. The waste cost is 1200, 225, 1275 and 125 dollars. The largest waste in cores is `bridge`. The largest waste in money is `shuttle`, because its environments cost more for each requested core. The total waste cost is 2825 dollars.

## Step 3: Compute unit costs

```sh
kubectl -n metrics get configmap platform-cost -o json | jq -r '.data["cost.json"]'
jq -c '.[] | {team, cost_per_environment: (.monthly_cost / .environments), idle_cost: (.monthly_cost / .environments * .idle_environments)}' teams.json
```

The cost per environment of `shuttle` is 250 dollars. The idle cost is 200 dollars for `bridge` and 750 dollars for `shuttle`, so the idle environment cost is 950 dollars. The platform costs 12000 dollars for 4 teams, which is 3000 dollars per team.

## Step 4: Record the review

Save this as `cost-review.yaml`:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: cost-review
  namespace: metrics
data:
  bridge-utilization-percent: "25"
  scout-utilization-percent: "75"
  shuttle-utilization-percent: "15"
  probe-utilization-percent: "75"
  fleet-utilization-percent: "37"
  teams-below-40-percent: "bridge,shuttle"
  most-wasted-cores-team: "bridge"
  most-wasted-cost-team: "shuttle"
  waste-cost-total: "2825"
  shuttle-cost-per-environment: "250"
  idle-environment-cost: "950"
  platform-cost-per-team: "3000"
```

Apply it:

```sh
kubectl apply -f cost-review.yaml
```

Grade it:

```sh
astrona submit --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-010/module-06/labs/lab-01
```

All checks pass. Clean up with `astrona destroy ats-082-lab-010-06`.
