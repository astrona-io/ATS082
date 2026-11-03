# Question

Solve this question on: `terminal`

The platform team reports delivery metrics for the service `bridge-api` for the 5 days from 2026-10-19 to 2026-10-23. The namespace `delivery` holds the data. Do not edit it.

- `deployments`, key `deployments.json`: 25 deployment events. Each record has `committed_at`, `deployed_at`, `needed_intervention` (`true` when the deployment needed immediate intervention; only these records have `recovered_at`) and `unplanned_rework` (`true` when the deployment was unplanned and caused by a production incident).
- `legacy-dashboard`, key `dashboard.json`: an old dashboard with a panel `MTTR` of 12 minutes and a note about how that panel is calculated.

Create a ConfigMap `bridge-api-report` in `delivery` with these keys:

1. `service-scope`: `bridge-api`. `window-days`: 5. `deployments`: the number of deployments. `deployment-frequency-per-day`: deployments divided by days.
2. `change-lead-time-median-hours`: the median of `deployed_at` minus `committed_at`, in hours.
3. `change-fail-rate-percent` and `deployment-rework-rate-percent`: each as the share of all deployments, times 100.
4. `failed-deployment-recovery-median-minutes`: the median of `recovered_at` minus `deployed_at`, in minutes, over failed deployments only. `recovery-metric-name`: the current name of this metric in the five-metric model.
5. `instability-metrics`: the two metrics of the instability group, separated by a comma.
6. `dashboard-valid`: `yes` or `no`, whether the `MTTR` panel can be trusted. `dashboard-reason`: one sentence of at least 40 characters.

`kubectl` already points at the cluster as the cluster administrator. `jq` runs on your machine.
