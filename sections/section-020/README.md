---
draft: true
exam_objectives:
  - DORA Metrics for Platform Initiatives
---
# Section 020: DORA Metrics for Platform Initiatives

This section teaches you to compute the five DORA delivery metrics from deployment events and to interpret them for a platform initiative. You will work from deployment records with `kubectl` and `jq`, and you will judge a claim from planning against data for several services.

**Exam objective covered:** DORA Metrics for Platform Initiatives

---

## What You Will Master

- Name the five metrics and sort them into throughput and instability.
- Define change lead time, deployment frequency, failed deployment recovery time, change fail rate and deployment rework rate.
- Compute each metric from deployment events with a stated window, statistic and unit.
- Explain the move from four key metrics to five and the rename of MTTR.
- Explain why metrics belong to a service and why a blended score hides differences.
- Explain the limits of a before-and-after comparison and the effect of Goodhart's law.
- Write down definitions of deployment, failure and recovery and handle windows, even counts and empty windows.
- Collect the metrics from consistent sources, read quarterly trends and find the constraint to improve.

---

## The Learning Path

### 1. Delivery Metrics From Deployment Events
*   **Module Reader:** **[Module 1: Delivery Metrics From Deployment Events](./module-01/course.md)**
*   **Hands-on Playground:** `sections/section-020/module-01/playground` - kind cluster, `jq` on your machine. The namespace `delivery` holds 20 deployment records of the service `shuttle-api`.
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-020/module-01/playground
    ```
*   **Lab:** `sections/section-020/module-01/labs/lab-01` (UNTESTED)
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-020/module-01/labs/lab-01
    astrona submit -c .
    ```

### 2. Interpreting DORA Metrics For Platform Initiatives
*   **Module Reader:** **[Module 2: Interpreting DORA Metrics For Platform Initiatives](./module-02/course.md)**
*   **Hands-on Playground:** `sections/section-020/module-02/playground` - kind cluster, `jq` on your machine. The namespace `delivery` holds metrics before and after a pipeline change for three services, and a claim from planning.
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-020/module-02/playground
    ```
*   **Lab:** `sections/section-020/module-02/labs/lab-01` (UNTESTED)
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-020/module-02/labs/lab-01
    astrona submit -c .
    ```

### 3. Collecting And Improving DORA Metrics With A Platform
*   **Module Reader:** **[Module 3: Collecting And Improving DORA Metrics With A Platform](./module-03/course.md)**
*   **Hands-on Playground:** `sections/section-020/module-03/playground` - kind cluster, `jq` on your machine. The namespace `delivery` holds a ConfigMap `deployment-history` with deployments from three quarters.
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-020/module-03/playground
    ```
*   **Lab:** `sections/section-020/module-03/labs/lab-01` (UNTESTED)
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-020/module-03/labs/lab-01
    astrona submit -c .
    ```

### Section Capstone Challenge
*   **Comprehensive Challenge:** DORA Metrics Capstone - `sections/section-020/capstone/labs/lab-01` (UNTESTED)
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS082.git -c sections/section-020/capstone/labs/lab-01
    astrona submit -c .
    ```
*   **Hands-on Objective:** Report the five metrics for the service `bridge-api` from 25 deployment events, name the instability metrics and the current name of the recovery metric, and judge a legacy `MTTR` dashboard panel against its definition. The grader recomputes every value from the live data.

### Knowledge Check
*   **Quiz:** 26 questions in `sections/section-020/quiz.yaml`. The pass score is 70 percent.
*   **Final Knowledge Check:** 24 questions in `sections/final-domain-quiz.yaml` across both sections. The pass score is 70 percent.
