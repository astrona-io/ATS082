# Question

Solve this question on: `terminal`

The platform team reviews how well four product teams use the compute they pay for. The data is in the namespace `metrics`. The ConfigMap `team-resources` has the key `teams.json`, a JSON array. Each record has `team`, `cpu_requested_millicores`, `cpu_used_millicores` (the average use over the month), `monthly_cost` (the cost of the team's environments in dollars), `environments` and `idle_environments` (environments with no deployment in 30 days). The ConfigMap `platform-cost` has the key `cost.json` with `platform_monthly_cost` (the monthly cost of running the platform) and `teams_supported`.

Do not edit the two source ConfigMaps. Create a ConfigMap `cost-review` in the namespace `metrics` with these keys, all computed from the data:

1. `bridge-utilization-percent`, `scout-utilization-percent`, `shuttle-utilization-percent` and `probe-utilization-percent`: used CPU divided by requested CPU, times 100, for each team.
2. `fleet-utilization-percent`: the same ratio over the sum of all teams.
3. `teams-below-40-percent`: the teams with utilization below 40 percent, sorted and joined with commas.
4. `most-wasted-cores-team`: the team with the largest difference between requested and used CPU.
5. `most-wasted-cost-team`: the team with the largest waste cost, where the waste cost of a team is its monthly cost times (requested CPU minus used CPU) divided by requested CPU. `waste-cost-total` is the sum of the waste cost of all teams.
6. `shuttle-cost-per-environment`: the monthly cost of the team `shuttle` divided by its environments.
7. `idle-environment-cost`: the cost of all idle environments, which is the cost per environment of each team times its idle environments, summed over the teams.
8. `platform-cost-per-team`: the platform monthly cost divided by the teams supported.

`kubectl` already points at the cluster as the cluster administrator. `jq` runs on your machine.
