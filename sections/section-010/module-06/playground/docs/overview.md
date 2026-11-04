# Overview: Cost And Resource Efficiency (Playground)

This is a **playground**, not a lab. It starts a fresh cluster with two data sets and waits. There is no task, no `astrona submit` and no pass or fail. Read the data, compute, change your mind, `astrona destroy`, start over.

## What's in the box

- A single-node `kind` cluster running Kubernetes 1.35. `kubectl` is already pointed at it, as the cluster administrator. You need `jq` on your machine.
- The namespace `metrics` with the ConfigMap `team-resources`. Its key `teams.json` is a JSON array of four teams. Each record has `team`, `cpu_requested_millicores`, `cpu_used_millicores` (the average use over the month), `monthly_cost` in dollars, `environments` and `idle_environments`.
- The ConfigMap `platform-cost` with key `cost.json`: `platform_monthly_cost` and `teams_supported`.
- No report exists. The cluster runs no workloads.

## Helpers

Paste these once in each new terminal. `load_teams` and `load_cost` save the data in local files. `team_table` prints utilization, wasted millicores and waste cost for each team.

```sh
load_teams() {
  kubectl -n metrics get configmap team-resources -o json | jq -r '.data["teams.json"]' > teams.json
}
load_cost() {
  kubectl -n metrics get configmap platform-cost -o json | jq -r '.data["cost.json"]' > cost.json
}
team_table() {
  jq -c '.[] | {team, utilization: (.cpu_used_millicores * 100 / .cpu_requested_millicores), wasted: (.cpu_requested_millicores - .cpu_used_millicores), waste_cost: (.monthly_cost * (.cpu_requested_millicores - .cpu_used_millicores) / .cpu_requested_millicores)}' teams.json
}
```

## Practice tasks

- Run `team_table` and rank the teams by utilization, by wasted millicores and by waste cost. Explain why the rankings differ.
- Compute the cost per environment of every team and find the team with the most expensive environments.
- Compute the idle environment cost of each team and the share of the total monthly cost it represents.
- Suppose `shuttle` reduces its requests to twice its use. Compute its new utilization and the saving, if cost falls in proportion to requested CPU.
- Divide the platform cost by the teams supported, then compare it with the total waste cost of the teams. Write one sentence on what the comparison does and does not show.
