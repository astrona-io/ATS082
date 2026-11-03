# Overview: DORA Trends And Bottlenecks (Playground)

This is a **playground**, not a lab. It starts a fresh cluster with one data set and waits. There is no task, no `astrona submit` and no pass or fail. Read the data, compute, change your mind, `astrona destroy`, start over.

## What's in the box

- A single-node `kind` cluster running Kubernetes 1.35. `kubectl` is already pointed at it, as the cluster administrator. You need `jq` on your machine.
- The namespace `delivery` with the ConfigMap `deployment-history`. Its key `deployments.json` is a JSON array of 24 deployments of the service `probe-api` in three quarters. Each record has `id`, `quarter` (`Q1`, `Q2` or `Q3`), `lead_time_hours`, `failed`, `recovery_minutes` (`null` unless the deployment failed) and `rework`.
- No report exists. The cluster runs no workloads.

## Helpers

Paste these once in each new terminal. `load_deployments` saves the data in `deployments.json`. `quarter_metric` prints one metric for a quarter, for example `quarter_metric Q3 fail`. The metric names are `count`, `lead`, `fail`, `rework` and `recovery`.

```sh
load_deployments() {
  kubectl -n delivery get configmap deployment-history -o json | jq -r '.data["deployments.json"]' > deployments.json
}
quarter_metric() {
  jq --arg q "$1" --arg m "$2" 'def med: sort | (length) as $n | if $n == 0 then null elif ($n % 2) == 1 then .[($n-1)/2] else (.[$n/2-1] + .[$n/2]) / 2 end; [.[] | select(.quarter == $q)] | if $m == "count" then length elif $m == "lead" then ([.[].lead_time_hours] | med) elif $m == "fail" then (([.[] | select(.failed)] | length) * 100 / length) elif $m == "rework" then (([.[] | select(.rework)] | length) * 100 / length) else ([.[] | select(.failed) | .recovery_minutes] | med) end' deployments.json
}
```

## Practice tasks

- Compute all five metrics for each quarter and write the three-quarter table.
- Name the metrics that improved from Q2 to Q3 and the metrics that got worse.
- Remove the 400-minute recovery from Q3 in your local copy of the file and compute the Q3 median recovery again. Explain what this tells you about small samples.
- List the deployments that needed rework but did not fail and decide what a team could learn from them.
- Write one sentence a leader can read that states the Q3 result without hiding the trade-off.
