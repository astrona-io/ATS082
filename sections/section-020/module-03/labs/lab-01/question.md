# Question

Solve this question on: `terminal`

The platform team of the service `probe-api` tells its sponsor that "delivery improved in every quarter". The cluster holds the data behind the claim: the ConfigMap `deployment-history` in the namespace `delivery`. Its key `deployments.json` is a JSON array with one record per deployment. Each record has `id`, `quarter` (`Q1`, `Q2` or `Q3`), `lead_time_hours`, `failed`, `recovery_minutes` (`null` unless the deployment failed) and `rework`.

Write an honest trend report. Do not edit `deployment-history`.

Create a ConfigMap `trend-report` in the namespace `delivery` with these keys, all computed from the data. Replace `qN` with `q1`, `q2` and `q3`:

1. `qN-deployments`: the number of deployments in each quarter.
2. `qN-median-lead-time-hours`: the median of `lead_time_hours` in each quarter. For an even number of values, use the average of the two middle values.
3. `qN-change-fail-rate-percent`: failed deployments divided by all deployments of the quarter, times 100.
4. `qN-median-recovery-minutes`: the median of `recovery_minutes` over the failed deployments of each quarter.
5. `lead-time-trend-q2-to-q3`: `faster` or `slower`. `fail-rate-trend-q2-to-q3` and `recovery-trend-q2-to-q3`: `better` or `worse`. Compare Q3 with Q2.

Rounding to two decimals is accepted. `kubectl` already points at the cluster as the cluster administrator. `jq` runs on your machine.
