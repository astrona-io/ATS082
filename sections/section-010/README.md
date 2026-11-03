---
draft: true
exam_objectives:
  - Platform Efficiency and Team Productivity
---
# Section 010: Platform Efficiency and Team Productivity

This section teaches you to report how well a platform works from raw task data and user evidence without misleading numbers. You will compute completion rates and percentiles with `kubectl` and `jq`, separate quantitative from qualitative evidence, and test a claim that a platform change worked.

**Exam objective covered:** Platform Efficiency and Team Productivity

---

## What You Will Master

- Distinguish platform efficiency from individual activity counts.
- Count task outcomes and compute a completion rate over all attempts.
- Compute a median and a percentile of the time to complete, over completed attempts only.
- Explain survivorship bias and name who is missing from a data set.
- Combine quantitative and qualitative evidence of developer experience.
- Explain why a measure used as a target is gamed, and why a before-and-after comparison cannot prove a cause.

---

## The Learning Path

### 1. Task Outcomes, Flow And Developer Productivity Evidence
*   **Module Reader:** **[Module 1: Task Outcomes, Flow And Developer Productivity Evidence](./module-01/course.md)**
*   **Hands-on Playground:** `sections/section-010/module-01/playground` - kind cluster, `jq` on your machine. The namespace `metrics` holds a ConfigMap with the raw records of an environment provisioning service. No report exists yet.
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-010/module-01/playground
    ```
*   **Lab:** `sections/section-010/module-01/labs/lab-01` (UNTESTED)
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-010/module-01/labs/lab-01
    astrona submit -c .
    ```

### 2. Developer Experience Evidence And Incentives
*   **Module Reader:** **[Module 2: Developer Experience Evidence And Incentives](./module-02/course.md)**
*   **Hands-on Playground:** `sections/section-010/module-02/playground` - kind cluster, `jq` on your machine. The namespace `metrics` holds monthly usage and ticket data, survey answers and a dated list of platform changes.
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-010/module-02/playground
    ```
*   **Lab:** `sections/section-010/module-02/labs/lab-01` (UNTESTED)
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-010/module-02/labs/lab-01
    astrona submit -c .
    ```

### Section Capstone Challenge
*   **Comprehensive Challenge:** Platform Efficiency Capstone - `sections/section-010/capstone/labs/lab-01` (UNTESTED)
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-010/capstone/labs/lab-01
    astrona submit -c .
    ```
*   **Hands-on Objective:** Report on an environment provisioning service from 20 requests: completion rate, the 90th percentile of the time to complete over completed requests, the worst request class, a verdict on a dashboard claim and a decision on a proposal to rank engineers by activity. The grader recomputes every value from the live data.

### Knowledge Check
*   **Quiz:** 8 questions in `sections/section-010/quiz.yaml`. The pass score is 70 percent.
