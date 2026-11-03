---
estimated_duration: 25m
---

# Lab: Report Platform Adoption And Onboarding

Graded lab. **Status: UNTESTED.** It was built without booting the lab; run `astrona test -c .` before relying on it. Open risk: the check scripts rely on `jq` 1.6 or newer on the grading machine.

The cluster holds the ConfigMap `team-adoption` and no report. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-010/module-03/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-010/module-03/labs/lab-01
astrona destroy ats-082-lab-010-03
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-team-adoption-data-unchanged.sh` | The source ConfigMap is unchanged (passes before any change) |
| `validate-adoption-rate.sh` | eligible-teams, adopted-teams and adoption-rate-percent are recorded |
| `validate-mandated-and-voluntary.sh` | mandated-adopted-teams and voluntary-adopted-teams are recorded |
| `validate-onboarding-time.sh` | The median and p90 of days to first deployment are recorded |
| `validate-self-service-rate.sh` | self-service-rate-percent is recorded |
| `validate-satisfaction.sh` | csat-satisfied-percent and nps are recorded |

Every check recomputes the expected value from the live source data, so the grader never holds a fixed answer that the data could contradict.
