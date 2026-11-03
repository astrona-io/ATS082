# Question

Solve this question on: `terminal`

Planning wants one organisation-wide delivery score and says: "The platform pipeline made every team better." The namespace `delivery` holds the data. Do not edit it.

- `service-metrics`, key `metrics.json`: one record for each of three services. Each record has `service`, `platform_pipeline` (`true` when the service deploys through the platform pipeline), and the objects `before` and `after` with the fields `lead_time_hours`, `deploys_per_week`, `change_fail_rate_percent`, `mttr_minutes` and `rework_rate_percent`.
- `platform-claim`, key `claim.json`: the statement from planning.

The field `mttr_minutes` comes from an old dashboard. Judge the claim for each service, not as one blended number.

Create a ConfigMap `delivery-interpretation` in `delivery` with these keys:

1. `recovery-metric-name`: the current name in the five-metric model for the metric the old data calls `mttr_minutes`.
2. `throughput-improved`: the services on the platform pipeline whose `lead_time_hours` fell and whose `deploys_per_week` rose. Names separated by commas.
3. `instability-worsened`: the services on the platform pipeline whose `change_fail_rate_percent` or `rework_rate_percent` rose. Names separated by commas.
4. `improved-without-platform`: the services not on the platform pipeline whose `lead_time_hours` fell anyway. Names separated by commas.
5. `platform-claim`: `proven` or `not-proven`. `scope-decision`: `per-service` or `organisation-wide`, the scope at which you would report the metrics. `claim-reason`: one sentence of at least 40 characters.

`kubectl` already points at the cluster as the cluster administrator. `jq` runs on your machine.
