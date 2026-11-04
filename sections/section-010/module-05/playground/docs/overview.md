# Overview: Platform Reliability Measures (Playground)

This is a **playground**, not a lab. It starts a fresh cluster with two data sets and waits. There is no task, no `astrona submit` and no pass or fail. Read the data, compute, change your mind, `astrona destroy`, start over.

## What's in the box

- A single-node `kind` cluster running Kubernetes 1.35. `kubectl` is already pointed at it, as the cluster administrator. You need `jq` on your machine.
- The namespace `metrics` with the ConfigMap `service-events`. Its key `services.json` is a JSON array of four platform services: `provisioning-api`, `pipeline-runner`, `portal` and `artifact-registry`. Each record has `service`, `slo_target_percent`, `total_events` and `good_events` for a 30-day window.
- The ConfigMap `recent-hour` with key `hour.json`: the `total_events` and `bad_events` of `provisioning-api` in the last hour.
- No report exists. The cluster runs no workloads.

## Helpers

Paste these once in each new terminal. `load_services` and `load_hour` save the data in local files. `budget_table` prints the SLI, the allowed bad events and the share of budget used for each service.

```sh
load_services() {
  kubectl -n metrics get configmap service-events -o json | jq -r '.data["services.json"]' > services.json
}
load_hour() {
  kubectl -n metrics get configmap recent-hour -o json | jq -r '.data["hour.json"]' > hour.json
}
budget_table() {
  jq -c '.[] | {service, sli: (.good_events * 100 / .total_events), allowed: (.total_events * (100 - .slo_target_percent) / 100), bad: (.total_events - .good_events)}' services.json
}
```

## Practice tasks

- Run `budget_table` and list the services that meet their SLO. Check each one against its own target, because the targets differ.
- Compute the share of budget used for each service and decide which services should stop risky changes under a budget policy.
- Change the SLO target of one service in your local `services.json` copy (not in the cluster) to 99 and see how the budget and the verdict change.
- Compute the burn rate of `provisioning-api` from `hour.json`. Then compute the burn rate if the last hour had 25 bad events and if it had 500.
- For each burn rate, compute how many days a full 30-day budget would last.
