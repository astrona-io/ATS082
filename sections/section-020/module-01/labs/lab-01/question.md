# Question

Solve this question on: `terminal`

The platform team wants delivery metrics for one service, `shuttle-api`, for the 10 days from 2026-10-05 to 2026-10-14. The ConfigMap `deployments` in the namespace `delivery` holds the deployment events. Its key `deployments.json` is a JSON array. Each record has:

- `id` and `service`.
- `committed_at`: when the change was committed to version control (UTC).
- `deployed_at`: when the change reached production (UTC).
- `needed_intervention`: `true` when the deployment needed immediate intervention (a rollback, a fix or a manual step). Only these records have `recovered_at`, the time the service recovered.
- `unplanned_rework`: `true` when the deployment was unplanned and happened because of an incident in production.

Do not edit `deployments`. Create a ConfigMap `delivery-report` in `delivery` with these keys, all computed from the data:

1. `deployments`: the number of deployments. `window-days`: 10. `deployment-frequency-per-day`: deployments divided by the days.
2. `change-lead-time-median-hours`: the median of `deployed_at` minus `committed_at`, in hours. For an even number of values the median is the average of the two middle values.
3. `change-fail-rate-percent`: deployments that needed intervention, divided by all deployments, times 100.
4. `failed-deployment-recovery-median-minutes`: the median of `recovered_at` minus `deployed_at`, in minutes, over the failed deployments only.
5. `deployment-rework-rate-percent`: deployments with `unplanned_rework` true, divided by all deployments, times 100.

`kubectl` already points at the cluster as the cluster administrator. `jq` runs on your machine.
