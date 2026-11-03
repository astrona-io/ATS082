---
estimated_duration: 25m
---

# Lab: Report Task Outcomes With Denominators

Graded lab. **Status: UNTESTED.** It was built without booting the lab; run `astrona test -c .` before relying on it. Open risk: the check scripts rely on `jq` 1.6 or newer on the grading machine.

The cluster holds a ConfigMap with 20 environment requests and no report. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-010/module-01/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-010/module-01/labs/lab-01
astrona destroy ats-082-lab-010-01
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-requests-data-unchanged.sh` | The source ConfigMap still has 20 records and 12 completed ones (passes before any change) |
| `validate-attempts-and-completion.sh` | `attempts`, `completed` and `completion-rate-percent` match the live data |
| `validate-completed-percentiles.sh` | `p50-completed-seconds` and `p90-completed-seconds` match the nearest-rank values |
| `validate-failed-and-abandoned.sh` | `failed` and `abandoned` match the live data |
| `validate-worst-class.sh` | `worst-class` and `worst-class-completion-rate-percent` match the data |

Every check that compares a number recomputes the expected value from the live source data, so the grader never holds a fixed answer that the data could contradict.
