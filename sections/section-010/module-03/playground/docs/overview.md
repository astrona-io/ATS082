# Overview: Platform Adoption And Onboarding (Playground)

This is a **playground**, not a lab. It starts a fresh cluster with one data set and waits. There is no task, no `astrona submit` and no pass or fail. Read the data, compute, change your mind, `astrona destroy`, start over.

## What's in the box

- A single-node `kind` cluster running Kubernetes 1.35. `kubectl` is already pointed at it, as the cluster administrator. You need `jq` on your machine.
- The namespace `metrics` with the ConfigMap `team-adoption`. Its key `teams.json` is a JSON array of 12 teams. Each record has `team`, `eligible`, `onboarded`, `mandated`, `days_to_first_deploy` (`null` when the team did not finish), `manual_tickets`, `self_service_requests`, `csat` (1 to 5) and `nps` (0 to 10). A score is `null` when the team did not answer.
- No report exists. The cluster runs no workloads.

## Helpers

Paste these once in each new terminal. `load_teams` saves the data in `teams.json`. `pctl_days` prints the nearest-rank percentile of the days to first deployment over onboarded teams. Its argument is a fraction such as `0.5` or `0.9`.

```sh
load_teams() {
  kubectl -n metrics get configmap team-adoption -o json | jq -r '.data["teams.json"]' > teams.json
}
pctl_days() {
  jq --argjson p "$1" '[.[] | select(.onboarded) | .days_to_first_deploy] | sort | .[((length * $p) | ceil) - 1]' teams.json
}
```

Use them like this: `load_teams`, then `pctl_days 0.9`.

## Practice tasks

- Compute the adoption rate with eligible teams in the denominator, then with all 12 teams. Explain the difference.
- Split the adopted teams into mandated and voluntary and compare their median onboarding days and their average `csat`.
- Compute the self-service rate for all teams, then only for onboarded teams. Which teams hold most of the manual tickets?
- Compute the NPS after removing the three mandated teams. Explain why the value changes.
- Estimate the monthly toil cost of the manual tickets with a handling time of 45 minutes, and write down where a real value would come from.
