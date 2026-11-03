---
estimated_duration: 25m
---

# Lab: Review A Metric Catalogue With SPACE

Graded lab. **Status: UNTESTED.** It was built without booting the lab; run `astrona test -c .` before relying on it. Open risk: the check scripts rely on `jq` 1.6 or newer on the grading machine.

The cluster holds the ConfigMap `metric-catalogue` and no report. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-010/module-04/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-010/module-04/labs/lab-01
astrona destroy ats-082-lab-010-04
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-metric-catalogue-data-unchanged.sh` | The source ConfigMap is unchanged (passes before any change) |
| `validate-catalogue-size.sh` | metrics-total and individual-level-count are recorded |
| `validate-team-metrics-per-dimension.sh` | Team-level metrics are counted per SPACE dimension |
| `validate-thinnest-dimension.sh` | thinnest-dimension names the team-level dimension with the fewest metrics |
| `validate-measure-types.sh` | perceptual-team-count and workflow-team-count are recorded |
| `validate-devex-areas.sh` | Team-level metrics are counted per DevEx area |

Every check recomputes the expected value from the live source data, so the grader never holds a fixed answer that the data could contradict.
