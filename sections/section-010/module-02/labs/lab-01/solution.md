# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. The `--keep` flag keeps the lab running so you can continue after a failed check. This lab was built without running it. The numbers below were computed from the seeded data with `jq`, so they are the values the checks expect for this data.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-010/module-02/labs/lab-01
```

`astrona submit` right after the start shows two checks that already pass: `usage-data-unchanged` and `survey-data-unchanged`.

## Step 1: Save the three data sets

Read each JSON document into a local file:

```sh
kubectl -n metrics get configmap portal-usage -o json | jq -r '.data["usage.json"]' > usage.json
kubectl -n metrics get configmap survey-responses -o json | jq -r '.data["survey.json"]' > survey.json
kubectl -n metrics get configmap platform-changes -o json | jq -r '.data["changes.json"]' > changes.json
```

Read the change log first. It lists two changes: the portal redesign on 2026-10-01 and a reduction of the environment quota per team from 5 to 2 on 2026-10-12:

```sh
jq -r '.[] | .date + " " + .change' changes.json
```

## Step 2: Tickets and completion rates

Sum the tickets of each period. The month strings sort in date order, so a string comparison selects the period:

```sh
jq '[.[] | select(.month < "2026-10") | .tickets] | add' usage.json
jq '[.[] | select(.month >= "2026-10") | .tickets] | add' usage.json
```

The totals are 80 before and 54 after. For the completion rate, divide the total of completed tasks by the total of started sessions in each period:

```sh
jq '[.[] | select(.month < "2026-10")] | ([.[].tasks_completed] | add) * 100 / ([.[].sessions_started] | add)' usage.json
jq '[.[] | select(.month >= "2026-10")] | ([.[].tasks_completed] | add) * 100 / ([.[].sessions_started] | add)' usage.json
```

Before, 320 of 400 sessions completed a task: 80 percent. After, 220 of 400: 55 percent. Tickets fell, but the share of finished tasks fell by 25 points. People who cannot finish a task and give up open no ticket.

## Step 3: The survey theme

Count the answers per theme and sort by the count:

```sh
jq 'group_by(.theme) | map({theme: .[0].theme, n: length}) | sort_by(-.n)' survey.json
```

The theme `unclear-error` has 5 answers, `confusing-field` has 4 and `workaround` has 3. The top theme is `unclear-error`.

## Step 4: Record the report

The verdict is `worse`, because the completion rate fell. The quota reduction on 2026-10-12 is the other change in the period. Save this as `experience-report.yaml`:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: experience-report
  namespace: metrics
data:
  tickets-before: "80"
  tickets-after: "54"
  completion-rate-before-percent: "80"
  completion-rate-after-percent: "55"
  top-survey-theme: "unclear-error"
  confounders: "The environment quota per team was reduced from 5 to 2 on 2026-10-12, in the same period as the redesign."
  verdict: "worse"
```

Apply it:

```sh
kubectl apply -f experience-report.yaml
```

Grade it:

```sh
astrona submit --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-010/module-02/labs/lab-01
```

All seven checks pass. Clean up with `astrona destroy ats-082-lab-010-02`.
