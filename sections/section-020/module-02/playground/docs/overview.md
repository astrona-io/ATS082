# Overview: Interpreting DORA Metrics For Platform Initiatives (Playground)

This is a **playground**, not a lab. It starts a fresh cluster with two data sets and waits. There is no task, no `astrona submit` and no pass or fail. Read the data, compute, change your mind, `astrona destroy`, start over.

## What's in the box

- A single-node `kind` cluster running Kubernetes 1.35. `kubectl` is already pointed at it, as the cluster administrator. You need `jq` on your machine.
- The namespace `delivery` with two ConfigMaps:

  | ConfigMap | Key | What it holds |
  | --- | --- | --- |
  | `service-metrics` | `metrics.json` | Three services with metrics `before` and `after` a platform pipeline change. Two services use the pipeline, one does not |
  | `platform-claim` | `claim.json` | A statement from planning about the platform pipeline |

- The old field `mttr_minutes` is the legacy name of a metric that has a different name today.
- No report exists. The cluster runs no workloads.

## Helpers

Paste these once in each new terminal. `load_service_metrics` saves the data in `service-metrics.json`. `change_of` prints the change of one metric for each service. Its argument is a field name such as `lead_time_hours`.

```sh
load_service_metrics() {
  kubectl -n delivery get configmap service-metrics -o json | jq -r '.data["metrics.json"]' > service-metrics.json
}
change_of() {
  jq -r --arg field "$1" '.[] | .service + " " + (.before[$field] | tostring) + " -> " + (.after[$field] | tostring)' service-metrics.json
}
```

Use them like this: `load_service_metrics`, then `change_of deploys_per_week`.

## Practice tasks

- Print the change of every metric for every service and mark each change as better or worse.
- Compute the average lead time of all three services before and after. Explain what that blended number hides.
- Find the service where throughput improved and instability worsened. Describe in one sentence what that pattern means for a platform team.
- Look at the service that does not use the pipeline. Explain what its improvement means for a claim about the pipeline.
- Write one sentence for each service that says what the data supports and what it does not.
