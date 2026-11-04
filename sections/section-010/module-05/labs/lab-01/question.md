# Question

Solve this question on: `terminal`

The platform team runs four services and has set a service level objective (SLO) for each one. The data is in the namespace `metrics`. The ConfigMap `service-events` has the key `services.json`, a JSON array. Each record has `service`, `slo_target_percent`, `total_events` and `good_events` for a 30-day window. The ConfigMap `recent-hour` has the key `hour.json` with the events of the service `provisioning-api` in the last hour: `total_events` and `bad_events`.

Do not edit the two source ConfigMaps. Create a ConfigMap `slo-review` in the namespace `metrics` with these keys, all computed from the data:

1. `provisioning-api-sli-percent`, `pipeline-runner-sli-percent`, `portal-sli-percent` and `artifact-registry-sli-percent`: the service level indicator (SLI) of each service in percent, which is good events divided by total events, times 100.
2. `provisioning-api-budget-used-percent`, `pipeline-runner-budget-used-percent`, `portal-budget-used-percent` and `artifact-registry-budget-used-percent`: the share of the error budget each service used, in percent. The error budget is the number of bad events the SLO allows in the window.
3. `services-missing-slo`: the names of the services whose SLI is below their own SLO target, sorted and joined with commas.
4. `most-budget-used-service`: the service that used the largest share of its error budget.
5. `provisioning-api-burn-rate`: the burn rate of `provisioning-api` in the last hour, which is the error ratio of that hour divided by the error ratio the SLO allows.
6. `days-to-exhaust-budget`: how many days a full 30-day budget of `provisioning-api` would last at that burn rate.

`kubectl` already points at the cluster as the cluster administrator. `jq` runs on your machine.
