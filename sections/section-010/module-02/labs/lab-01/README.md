---
estimated_duration: 25m
---

# Lab: Weigh Developer Experience Evidence

Graded lab. **Status: UNTESTED.** It was built without booting the lab; run `astrona test -c .` before relying on it. Open risk: the same `jq` version note as the first lab.

The cluster holds usage numbers, survey answers and a change log, and no report. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-010/module-02/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-010/module-02/labs/lab-01
astrona destroy ats-082-lab-010-02
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-usage-data-unchanged.sh` | `portal-usage` has 4 months and 134 tickets in total (passes before any change) |
| `validate-survey-data-unchanged.sh` | `survey-responses` has 12 answers and 3 themes (passes before any change) |
| `validate-ticket-counts.sh` | `tickets-before` and `tickets-after` match the usage data |
| `validate-completion-rates.sh` | `completion-rate-before-percent` and `completion-rate-after-percent` match |
| `validate-top-survey-theme.sh` | `top-survey-theme` is the theme with the most answers |
| `validate-confounder-named.sh` | `confounders` mentions the quota change |
| `validate-verdict.sh` | `verdict` is `worse` when the completion rate fell |

Every check that compares a number recomputes the expected value from the live source data, so the grader never holds a fixed answer that the data could contradict.
