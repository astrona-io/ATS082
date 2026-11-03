# Question

Solve this question on: `terminal`

The platform team reports to its sponsor that "the platform is adopted by most teams and everyone is happy". The cluster holds the data behind the claim: the ConfigMap `team-adoption` in the namespace `metrics`. Its key `teams.json` is a JSON array with one record per team. Each record has `team`, `eligible`, `onboarded`, `mandated`, `days_to_first_deploy` (`null` when the team did not finish), `manual_tickets` and `self_service_requests` (monthly counts), `csat` (1 to 5) and `nps` (0 to 10). A score is `null` when the team did not answer.

Write an honest adoption report. Do not edit `team-adoption`.

Create a ConfigMap `adoption-report` in the namespace `metrics` with these keys, all computed from the data:

1. `eligible-teams`: the number of eligible teams. `adopted-teams`: eligible teams that are onboarded. `adoption-rate-percent`: adopted teams divided by eligible teams, times 100.
2. `mandated-adopted-teams` and `voluntary-adopted-teams`: onboarded teams that are mandated and onboarded teams that are not.
3. `median-days-to-first-deploy` and `p90-days-to-first-deploy`: the median and the 90th percentile of `days_to_first_deploy` over onboarded teams. Use the nearest-rank method: sort the values, then take the value at position `ceil(p x n)`.
4. `self-service-rate-percent`: all `self_service_requests` divided by all `self_service_requests` plus all `manual_tickets`, times 100.
5. `csat-satisfied-percent`: the share of answering teams with a `csat` of 4 or 5. `nps`: the share of promoters (`nps` 9 or 10) minus the share of detractors (`nps` 0 to 6), over answering teams, times 100.

Rounding to two decimals is accepted. `kubectl` already points at the cluster as the cluster administrator. `jq` runs on your machine.
