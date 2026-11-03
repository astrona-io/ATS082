# Question

Solve this question on: `terminal`

The platform team wants to report on its environment provisioning service. A dashboard claims: "90 percent of environment requests are ready in under 5 minutes". Planning also proposes to rank engineers each quarter by the number of environments they requested. In the namespace `metrics`, three ConfigMaps hold the evidence. Do not edit them.

- `environment-requests`, key `requests.json`: 20 requests. Each has `id`, `class` (`small` or `large`), `outcome` (`completed`, `failed` or `abandoned`), `requested_at` and `ended_at` as UTC timestamps.
- `latency-claim`, key `claim.json`: the dashboard statement and its limit in seconds, `p90_limit_seconds`.
- `kpi-proposal`, key `proposal.json`: the ranking proposal and the reason planning gives.

The time to complete a request is `ended_at` minus `requested_at`.

Create a ConfigMap `outcome-evidence` in `metrics` with these keys:

1. `attempts`, `completed` and `abandoned`: the number of requests and the number with each of those outcomes.
2. `completion-rate-percent`: completed requests divided by all attempts, times 100.
3. `p90-completed-seconds`: the 90th percentile of the time to complete over completed requests only, by the nearest-rank method (sort, then take the value at position `ceil(0.9 x n)`).
4. `worst-class` and `worst-class-completion-rate-percent`: the request class with the lowest completion rate and that rate.
5. `claim-supported`: `yes` or `no`, whether the dashboard claim holds for your 90th percentile. `claim-reason`: one sentence of at least 30 characters.
6. `proposal-decision`: `accept` or `reject` for the ranking proposal. `proposal-reason`: one sentence of at least 40 characters about what the measure rewards.

`kubectl` already points at the cluster as the cluster administrator. `jq` runs on your machine.
