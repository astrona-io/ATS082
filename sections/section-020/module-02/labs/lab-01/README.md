---
estimated_duration: 25m
---

# Lab: Interpret Delivery Metrics For A Platform Change

Graded lab. **Status: UNTESTED.** It was built without booting the lab; run `astrona test -c .` before relying on it. Open risk: the same `jq` version note as the first lab.

The cluster holds before and after delivery metrics for three services and a claim. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-020/module-02/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-020/module-02/labs/lab-01
astrona destroy ats-082-lab-020-02
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-service-metrics-data-unchanged.sh` | `service-metrics` has 3 services, 2 of them on the platform pipeline (passes before any change) |
| `validate-current-metric-name.sh` | `recovery-metric-name` is `failed deployment recovery time` |
| `validate-throughput-improved.sh` | `throughput-improved` lists exactly the matching services |
| `validate-instability-worsened.sh` | `instability-worsened` lists exactly the matching services |
| `validate-improved-without-platform.sh` | `improved-without-platform` lists exactly the matching services |
| `validate-claim-and-scope-decided.sh` | `platform-claim` is `not-proven`, `scope-decision` is `per-service` and `claim-reason` is filled |

Every check that compares a number recomputes the expected value from the live source data, so the grader never holds a fixed answer that the data could contradict.
