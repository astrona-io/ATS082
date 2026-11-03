---
estimated_duration: 40m
---

# Capstone: DORA Metrics For Platform Initiatives

Graded integration lab. **Status: UNTESTED.** It was built without booting the lab; run `astrona test -c .` before relying on it. Open risk: the same `jq` version note as the first lab.

The cluster holds deployment events for one service and a legacy dashboard, and no report. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-020/capstone/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-020/capstone/labs/lab-01
astrona destroy ats-082-capstone-020
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-bridge-deployments-data-unchanged.sh` | The source ConfigMap has 25 deployments and 5 that needed intervention (passes before any change) |
| `validate-deployment-frequency.sh` | `service-scope`, `deployments`, `window-days` and `deployment-frequency-per-day` match |
| `validate-change-lead-time.sh` | `change-lead-time-median-hours` matches |
| `validate-instability-metrics.sh` | `change-fail-rate-percent` and `deployment-rework-rate-percent` match |
| `validate-failed-deployment-recovery.sh` | `failed-deployment-recovery-median-minutes` and `recovery-metric-name` match |
| `validate-metric-groups.sh` | `instability-metrics` is `change fail rate, deployment rework rate` |
| `validate-dashboard-judged.sh` | `dashboard-valid` is `no` and `dashboard-reason` is filled |

Every check that compares a number recomputes the expected value from the live source data, so the grader never holds a fixed answer that the data could contradict.
