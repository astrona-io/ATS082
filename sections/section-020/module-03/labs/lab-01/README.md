---
estimated_duration: 25m
---

# Lab: Read A Quarterly DORA Trend

Graded lab. **Status: UNTESTED.** It was built without booting the lab; run `astrona test -c .` before relying on it. Open risk: the check scripts rely on `jq` 1.6 or newer on the grading machine.

The cluster holds the ConfigMap `deployment-history` and no report. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-020/module-03/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-020/module-03/labs/lab-01
astrona destroy ats-082-lab-020-03
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-deployment-history-data-unchanged.sh` | The source ConfigMap is unchanged (passes before any change) |
| `validate-deployments-per-quarter.sh` | The deployments of each quarter are counted |
| `validate-lead-time-per-quarter.sh` | The median change lead time of each quarter is recorded |
| `validate-change-fail-rate-per-quarter.sh` | The change fail rate of each quarter is recorded |
| `validate-recovery-time-per-quarter.sh` | The median failed deployment recovery time of each quarter is recorded |
| `validate-trend-verdicts.sh` | The lead time and instability trends from Q2 to Q3 are named |

Every check recomputes the expected value from the live source data, so the grader never holds a fixed answer that the data could contradict.
