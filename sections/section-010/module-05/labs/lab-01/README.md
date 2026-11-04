---
estimated_duration: 25m
---

# Lab: Report Error Budgets For Platform Services

Graded lab. **Status: UNTESTED.** It was built without booting the lab; run `astrona test -c .` before relying on it. Open risk: the check scripts rely on `jq` 1.6 or newer on the grading machine.

The cluster holds the source data and no report. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-010/module-05/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-010/module-05/labs/lab-01
astrona destroy ats-082-lab-010-05
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-source-data-unchanged.sh` | The source ConfigMaps are unchanged (passes before any change) |
| `validate-slis.sh` | SLI percentages are recorded |
| `validate-budget-used.sh` | Error budget used is recorded for each service |
| `validate-services-missing-slo.sh` | services-missing-slo lists the services below their SLO |
| `validate-most-budget-used.sh` | most-budget-used-service names the service with the largest share of budget used |
| `validate-burn-rate.sh` | The burn rate and the days to exhaust the budget are recorded |

Every check recomputes the expected value from the live source data, so the grader never holds a fixed answer that the data could contradict.
