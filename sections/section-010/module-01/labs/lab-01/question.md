# Question

Solve this question on: `terminal`

The platform team runs an environment provisioning service. Its dashboard reports "average environment creation time: 125 seconds". The cluster holds the raw data behind the dashboard: the ConfigMap `provisioning-requests` in the namespace `metrics`. Its key `requests.json` is a JSON array with one record per request. Each record has an `id`, a `class` (`small` or `large`), an `outcome` (`completed`, `failed` or `abandoned`) and `seconds`, which is the time until the request ended, whatever the outcome.

Write an honest outcome report. Do not edit `provisioning-requests`.

Create a ConfigMap `outcome-report` in the namespace `metrics` with these keys, all computed from the data:

1. `attempts`: the number of requests. `completed`, `failed` and `abandoned`: the number of requests with each outcome.
2. `completion-rate-percent`: completed requests divided by all attempts, times 100.
3. `p50-completed-seconds` and `p90-completed-seconds`: the median and the 90th percentile of `seconds` over completed requests only. Use the nearest-rank method: sort the values, then take the value at position `ceil(p x n)` where `n` is the number of values and `p` is 0.5 or 0.9.
4. `worst-class`: the request class with the lowest completion rate, and `worst-class-completion-rate-percent`: that rate.

`kubectl` already points at the cluster as the cluster administrator. `jq` runs on your machine.
