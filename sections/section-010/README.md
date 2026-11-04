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
- Measure flow, wait time and wasted time, and design a survey that limits response bias.
- Report platform adoption, onboarding time, self-service, CSAT and NPS from team records.
- Use the SPACE and DevEx frameworks to build a balanced metric set and to reason about cognitive load.
- Define SLIs and SLOs for platform services, compute error budget use and burn rate.
- Compute utilization, waste, idle environment cost and unit costs, and report platform value with a baseline.

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

### 3. Platform Adoption, Onboarding And Product Metrics
*   **Module Reader:** **[Module 3: Platform Adoption, Onboarding And Product Metrics](./module-03/course.md)**
*   **Hands-on Playground:** `sections/section-010/module-03/playground` - kind cluster, `jq` on your machine. The namespace `metrics` holds a ConfigMap `team-adoption` with one record per team: eligibility, onboarding, mandate, days to first deployment, tickets, self-service requests and survey scores.
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-010/module-03/playground
    ```
*   **Lab:** `sections/section-010/module-03/labs/lab-01` (UNTESTED)
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-010/module-03/labs/lab-01
    astrona submit -c .
    ```

### 4. Developer Productivity Frameworks: SPACE, DevEx And Cognitive Load
*   **Module Reader:** **[Module 4: Developer Productivity Frameworks: SPACE, DevEx And Cognitive Load](./module-04/course.md)**
*   **Hands-on Playground:** `sections/section-010/module-04/playground` - kind cluster, `jq` on your machine. The namespace `metrics` holds a ConfigMap `metric-catalogue` with 13 metrics, each tagged with a SPACE dimension, a level and a measure type, and a ConfigMap `team-measurements`.
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-010/module-04/playground
    ```
*   **Lab:** `sections/section-010/module-04/labs/lab-01` (UNTESTED)
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-010/module-04/labs/lab-01
    astrona submit -c .
    ```

### 5. Platform Reliability Measures: SLIs, SLOs And Error Budgets
*   **Module Reader:** **[Module 5: Platform Reliability Measures: SLIs, SLOs And Error Budgets](./module-05/course.md)**
*   **Hands-on Playground:** `sections/section-010/module-05/playground` - kind cluster, `jq` on your machine. The namespace `metrics` holds a ConfigMap `service-events` with 30 days of good and total events and an SLO target for four platform services, and a ConfigMap `recent-hour`.
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-010/module-05/playground
    ```
*   **Lab:** `sections/section-010/module-05/labs/lab-01` (UNTESTED)
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-010/module-05/labs/lab-01
    astrona submit -c .
    ```

### 6. Cost And Resource Efficiency Of The Platform
*   **Module Reader:** **[Module 6: Cost And Resource Efficiency Of The Platform](./module-06/course.md)**
*   **Hands-on Playground:** `sections/section-010/module-06/playground` - kind cluster, `jq` on your machine. The namespace `metrics` holds a ConfigMap `team-resources` with requested and used CPU, cost, environments and idle environments for four teams, and a ConfigMap `platform-cost`.
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-010/module-06/playground
    ```
*   **Lab:** `sections/section-010/module-06/labs/lab-01` (UNTESTED)
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-010/module-06/labs/lab-01
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
*   **Quiz:** 54 questions in `sections/section-010/quiz.yaml`. The pass score is 70 percent.
