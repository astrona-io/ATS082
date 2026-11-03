---
draft: true
exam_objectives:
  - Platform Efficiency and Team Productivity
---
# Task Outcomes, Flow And Developer Productivity Evidence

This module explains how a platform team measures whether its shared capabilities help users finish useful work. It starts from a defined task, counts every attempt, and reports the time to complete with percentiles instead of a single average. The hands-on part works on a real data set of environment requests with `kubectl` and `jq`.

## Learning Goals

- Distinguish platform efficiency, which is about task outcomes and flow, from activity counts such as the number of requests or commits.
- Define a task outcome, a population and a denominator for one platform capability.
- Compute a completion rate that counts failed and abandoned attempts.
- Report the time to complete with the median and the 90th percentile, and say why a mean of completed requests misleads.
- Break a result down by request class to find where users meet the most friction.
- Split the time of a request into wait time and work time, compute flow efficiency and relate work in progress to throughput.
- Compare failed and abandoned requests by count, time and class.

## Before You Start

You should know what a ConfigMap and a namespace are in Kubernetes. The playground starts a kind cluster that holds the data in a ConfigMap, and you read it with `kubectl` and `jq`. Technical terms are defined where they first appear.

## Reading Order

1. Task Outcomes, Populations And Denominators
2. Time To Complete, Percentiles And Survivorship
3. Flow, Wait Time And Work In Progress
4. Failures, Abandonment And Wasted Time
5. Summary

<!-- astrona:playground -->
