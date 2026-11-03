---
estimated_duration: 40m
---

# Capstone: Platform Efficiency

Graded integration lab. **Status: UNTESTED.** It was built without booting the lab; run `astrona test -c .` before relying on it. Open risk: `fromdateiso8601` needs `jq` 1.6 or newer on the grading machine.

The cluster holds request events with timestamps, a claim from a dashboard and a proposal to rank engineers. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-010/capstone/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-010/capstone/labs/lab-01
astrona destroy ats-082-capstone-010
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-environment-requests-data-unchanged.sh` | The source ConfigMap has 20 requests and 13 completed ones (passes before any change) |
| `validate-outcome-counts.sh` | `attempts`, `completed`, `abandoned` and `completion-rate-percent` match the data |
| `validate-p90-from-timestamps.sh` | `p90-completed-seconds` matches |
| `validate-worst-class.sh` | `worst-class` and `worst-class-completion-rate-percent` match |
| `validate-latency-claim-judged.sh` | `claim-supported` follows from the data and `claim-reason` is filled |
| `validate-kpi-proposal-decided.sh` | `proposal-decision` is `reject` and `proposal-reason` is filled |

Every check that compares a number recomputes the expected value from the live source data, so the grader never holds a fixed answer that the data could contradict.
