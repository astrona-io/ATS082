# Question

Solve this question on: `terminal`

A platform team proposes a set of metrics to measure developer productivity. The proposal is the ConfigMap `metric-catalogue` in the namespace `metrics`. Its key `metrics.json` is a JSON array of 13 metrics. Each record has `metric`, `dimension` (a SPACE dimension: `satisfaction`, `performance`, `activity`, `communication` or `efficiency`), `level` (`team` or `individual`), `measure` (`workflow` or `perceptual`) and `devex` (`feedback loops`, `cognitive load`, `flow state` or `none`).

Review the proposal. Do not edit `metric-catalogue`. Individual-level metrics are not allowed in the final set, so every count below that is described as team-level ignores records with level `individual`.

Create a ConfigMap `metric-review` in the namespace `metrics` with these keys, all computed from the data:

1. `metrics-total`: the number of metrics in the proposal. `individual-level-count`: the number of metrics with level `individual`.
2. `satisfaction-count`, `performance-count`, `activity-count`, `communication-count` and `efficiency-count`: the number of team-level metrics in each dimension.
3. `thinnest-dimension`: the team-level dimension with the fewest metrics (the value is unique).
4. `perceptual-team-count` and `workflow-team-count`: the number of team-level metrics of each measure type.
5. `feedback-loops-count`, `cognitive-load-count` and `flow-state-count`: the number of team-level metrics for each DevEx area.

`kubectl` already points at the cluster as the cluster administrator. `jq` runs on your machine.
