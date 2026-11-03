---
estimated_duration: 25m
---

# Lab: Compute The Five Delivery Metrics

Graded lab. **Status: UNTESTED.** It was built without booting the lab; run `astrona test -c .` before relying on it. Open risk: the same `jq` version note as the first lab.

The cluster holds deployment events for one service and no report. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-020/module-01/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-020/module-01/labs/lab-01
astrona destroy ats-082-lab-020-01
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-deployments-data-unchanged.sh` | The source ConfigMap has 20 deployments and 5 that needed intervention (passes before any change) |
| `validate-deployment-frequency.sh` | `deployments`, `window-days` (10) and `deployment-frequency-per-day` match |
| `validate-change-lead-time.sh` | `change-lead-time-median-hours` matches |
| `validate-change-fail-rate.sh` | `change-fail-rate-percent` matches |
| `validate-failed-deployment-recovery.sh` | `failed-deployment-recovery-median-minutes` matches |
| `validate-deployment-rework-rate.sh` | `deployment-rework-rate-percent` matches |

Every check that compares a number recomputes the expected value from the live source data, so the grader never holds a fixed answer that the data could contradict.
