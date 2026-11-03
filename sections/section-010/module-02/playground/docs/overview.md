# Overview: Developer Experience Evidence And Incentives (Playground)

This is a **playground**, not a lab. It starts a fresh cluster with three data sets and waits. There is no task, no `astrona submit` and no pass or fail. Read the data, compute, change your mind, `astrona destroy`, start over.

## What's in the box

- A single-node `kind` cluster running Kubernetes 1.35. `kubectl` is already pointed at it, as the cluster administrator. You need `jq` on your machine.
- The namespace `metrics` with three ConfigMaps:

  | ConfigMap | Key | What it holds |
  | --- | --- | --- |
  | `portal-usage` | `usage.json` | One record per month (2026-08 to 2026-11) with `sessions_started`, `tasks_completed` and `tickets` |
  | `survey-responses` | `survey.json` | 12 survey answers with `score`, `theme` and `comment` |
  | `platform-changes` | `changes.json` | Two dated changes: a portal redesign and a quota reduction |

- No report exists. The cluster runs no workloads.

## Helpers

Paste these once in each new terminal. `load_evidence` saves the three data sets in local files. `period_totals` prints the total sessions, tasks and tickets of the months that match a jq condition on `.month`.

```sh
load_evidence() {
  kubectl -n metrics get configmap portal-usage -o json | jq -r '.data["usage.json"]' > usage.json
  kubectl -n metrics get configmap survey-responses -o json | jq -r '.data["survey.json"]' > survey.json
  kubectl -n metrics get configmap platform-changes -o json | jq -r '.data["changes.json"]' > changes.json
}
period_totals() {
  jq --arg from "$1" --arg to "$2" '[.[] | select(.month >= $from and .month <= $to)] | {sessions: ([.[].sessions_started] | add), tasks: ([.[].tasks_completed] | add), tickets: ([.[].tickets] | add)}' usage.json
}
```

Use them like this: `load_evidence`, then `period_totals 2026-08 2026-09`.

## Practice tasks

- Compute tickets per 100 sessions started for each month and compare it with the raw ticket count.
- Compute the completion rate of each month and find the first month where it falls.
- Count the survey answers for each theme and compute the average `score` for each theme.
- Read `changes.json` and list every change that could explain a drop in completed tasks. Decide what extra data you would need to separate them.
- Write down one sentence that states what the evidence supports and one sentence that it does not support.
