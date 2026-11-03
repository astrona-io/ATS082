# Overview: Task Outcomes And Denominators (Playground)

This is a **playground**, not a lab. It starts a fresh cluster with one data set and waits. There is no task, no `astrona submit` and no pass or fail. Read the data, compute, change your mind, `astrona destroy`, start over.

## What's in the box

- A single-node `kind` cluster running Kubernetes 1.35. `kubectl` is already pointed at it, as the cluster administrator. You need `jq` on your machine.
- The namespace `metrics` with the ConfigMap `provisioning-requests`. Its key `requests.json` is a JSON array of 20 environment requests. Each record has an `id`, a `class` (`small` or `large`), an `outcome` (`completed`, `failed` or `abandoned`) and `seconds`, the time until the request ended.
- No report exists. The cluster runs no workloads.

## Helpers

Paste these once in each new terminal. `load_requests` saves the data in `requests.json`. `pctl_completed` prints the nearest-rank percentile of the time to complete, over completed requests only. Its argument is a fraction such as `0.5` or `0.9`.

```sh
load_requests() {
  kubectl -n metrics get configmap provisioning-requests -o json | jq -r '.data["requests.json"]' > requests.json
}
pctl_completed() {
  jq --argjson p "$1" '[.[] | select(.outcome == "completed") | .seconds] | sort | .[((length * $p) | ceil) - 1]' requests.json
}
```

Use them like this: `load_requests`, then `pctl_completed 0.5`.

## Practice tasks

- Count the requests for each outcome and compute the completion rate with all attempts in the denominator.
- Compute the mean `seconds` of the completed requests and compare it with the median. Explain the difference.
- Compute the mean `seconds` of all 20 requests and explain why that number is not a time to complete.
- Compute the completion rate for each class and decide which class a platform team should look at first.
- Change `pctl_completed` to take one class as a second argument. Check that the 90th percentile of one class differs from the 90th percentile of all requests.
