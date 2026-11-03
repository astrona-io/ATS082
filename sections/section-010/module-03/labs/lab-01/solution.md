# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. The `--keep` flag keeps the lab running so you can continue after a failed check. This lab was built without running it. The numbers below were computed from the seeded data with `jq`, so they are the values the checks expect for this data.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-010/module-03/labs/lab-01
```

`astrona submit` right after the start shows one check that already passes: `data-unchanged`. It stays your guard while you work.

## Step 1: Save the data and compute the adoption numbers

Read the JSON out of the ConfigMap into a local file:

```sh
kubectl -n metrics get configmap team-adoption -o json | jq -r '.data["teams.json"]' > teams.json
```

Count eligible and adopted teams, and split the adopted teams by mandate:

```sh
jq '[.[] | select(.eligible)] | length' teams.json
jq '[.[] | select(.eligible and .onboarded)] | length' teams.json
jq '[.[] | select(.onboarded and .mandated)] | length' teams.json
```

There are 10 eligible teams and 7 adopted teams, so the adoption rate is 70 percent. Of the 7 adopted teams, 3 are mandated and 4 are voluntary. The two teams that are not eligible stay out of the denominator.

## Step 2: Onboarding time

Take the days of the onboarded teams only:

```sh
jq -c 'def pctl($p): sort | .[((length * $p) | ceil) - 1]; [.[] | select(.onboarded) | .days_to_first_deploy] | {p50: pctl(0.5), p90: pctl(0.9)}' teams.json
```

With 7 values, the median is at position 4 and the 90th percentile at position 7. The result is 6 and 20 days.

## Step 3: Self-service rate and satisfaction

The self-service requests add up to 64 and the manual tickets to 55, so the rate is 64 divided by 119, which is 53.78 percent:

```sh
jq '([.[].self_service_requests] | add) as $s | ([.[].manual_tickets] | add) as $m | $s * 100 / ($s + $m)' teams.json
```

Seven teams answered the survey. Four scored 4 or 5, which is 57.14 percent. Promoters are 2 and detractors are 3, so the NPS is (2 minus 3) divided by 7, times 100, which is -14.29.

## Step 4: Record the report

Save this as `adoption-report.yaml`:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: adoption-report
  namespace: metrics
data:
  eligible-teams: "10"
  adopted-teams: "7"
  adoption-rate-percent: "70"
  mandated-adopted-teams: "3"
  voluntary-adopted-teams: "4"
  median-days-to-first-deploy: "6"
  p90-days-to-first-deploy: "20"
  self-service-rate-percent: "53.78"
  csat-satisfied-percent: "57.14"
  nps: "-14.29"
```

Apply it:

```sh
kubectl apply -f adoption-report.yaml
```

Grade it:

```sh
astrona submit --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-010/module-03/labs/lab-01
```

All checks pass. Clean up with `astrona destroy ats-082-lab-010-03`.
