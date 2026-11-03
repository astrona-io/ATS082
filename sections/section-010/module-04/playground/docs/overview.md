# Overview: SPACE, DevEx And Cognitive Load (Playground)

This is a **playground**, not a lab. It starts a fresh cluster with two data sets and waits. There is no task, no `astrona submit` and no pass or fail. Read the data, compute, change your mind, `astrona destroy`, start over.

## What's in the box

- A single-node `kind` cluster running Kubernetes 1.35. `kubectl` is already pointed at it, as the cluster administrator. You need `jq` on your machine.
- The namespace `metrics` with the ConfigMap `metric-catalogue`. Its key `metrics.json` is a JSON array of 13 metrics. Each record has `metric`, `dimension` (a SPACE dimension), `level` (`team` or `individual`), `measure` (`workflow` or `perceptual`) and `devex` (`feedback loops`, `cognitive load`, `flow state` or `none`).
- The ConfigMap `team-measurements` with key `teams.json`: three teams with `satisfaction` (1 to 5), `build_wait_minutes`, `deployments_per_day`, `change_fail_rate` (percent) and `interruptions_per_day`.
- No report exists. The cluster runs no workloads.

## Helpers

Paste these once in each new terminal. `load_catalogue` and `load_teams` save the data in local files. `count_by` prints the number of team-level metrics for each value of a field of the catalogue, for example `count_by dimension`.

```sh
load_catalogue() {
  kubectl -n metrics get configmap metric-catalogue -o json | jq -r '.data["metrics.json"]' > metrics.json
}
load_teams() {
  kubectl -n metrics get configmap team-measurements -o json | jq -r '.data["teams.json"]' > teams.json
}
count_by() {
  jq -c --arg field "$1" '[.[] | select(.level == "team")] | group_by(.[$field]) | map({value: .[0][$field], n: length})' metrics.json
}
```

## Practice tasks

- Run `count_by dimension` and name the dimension with the fewest team-level metrics. Propose a metric for it.
- Run `count_by devex` and decide which DevEx area has too few metrics.
- List the perceptual metrics and decide which dimension would gain most from one more perceptual metric.
- For each team, compare `satisfaction` with `build_wait_minutes` and `interruptions_per_day`. Write one sentence that states what the data shows and one that states what it does not prove.
- Pair `deployments_per_day` with `change_fail_rate` for each team and judge which team's speed is healthy.
