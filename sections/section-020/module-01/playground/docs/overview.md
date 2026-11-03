# Overview: Delivery Metrics From Deployment Events (Playground)

This is a **playground**, not a lab. It starts a fresh cluster with one data set and waits. There is no task, no `astrona submit` and no pass or fail. Read the data, compute, change your mind, `astrona destroy`, start over.

## What's in the box

- A single-node `kind` cluster running Kubernetes 1.35. `kubectl` is already pointed at it, as the cluster administrator. You need `jq` on your machine.
- The namespace `delivery` with the ConfigMap `deployments`. Its key `deployments.json` is a JSON array of 20 deployments of the service `shuttle-api`, from 2026-10-05 to 2026-10-14. Each record has `committed_at`, `deployed_at`, `needed_intervention` and `unplanned_rework`. Records that needed intervention also have `recovered_at`.
- No report exists. The cluster runs no workloads.

## Helpers

Paste these once in each new terminal. `load_deployments` saves the data in `deployments.json`. `lead_hours` prints the change lead time of every deployment in hours.

```sh
load_deployments() {
  kubectl -n delivery get configmap deployments -o json | jq -r '.data["deployments.json"]' > deployments.json
}
lead_hours() {
  jq '[.[] | ((.deployed_at | fromdateiso8601) - (.committed_at | fromdateiso8601)) / 3600]' deployments.json
}
```

Use them like this: `load_deployments`, then `lead_hours`.

## Practice tasks

- Compute the deployment frequency per day and per week from the first and last `deployed_at`.
- Compute the mean and the median change lead time. Explain which one a team should report and why.
- Compute the change fail rate and the deployment rework rate. List the ids that are in one set and not in the other.
- Compute the failed deployment recovery time of each failed deployment and its median.
- Remove the three slowest changes from the data in a copy of the file and compute the median again. State what changed and what did not.
