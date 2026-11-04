---
estimated_duration: 25m
---

# Lab: Report Resource Waste And Unit Cost

Graded lab. **Status: UNTESTED.** It was built without booting the lab; run `astrona test -c .` before relying on it. Open risk: the check scripts rely on `jq` 1.6 or newer on the grading machine.

The cluster holds the source data and no report. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-010/module-06/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-010/module-06/labs/lab-01
astrona destroy ats-082-lab-010-06
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-source-data-unchanged.sh` | The source ConfigMaps are unchanged (passes before any change) |
| `validate-utilization.sh` | CPU utilization is recorded for each team and for the fleet |
| `validate-waste.sh` | Waste is recorded in cores and in money |
| `validate-unit-cost.sh` | Unit costs are recorded |

Every check recomputes the expected value from the live source data, so the grader never holds a fixed answer that the data could contradict.
