---
draft: true
exam_objectives:
  - Platform Efficiency and Team Productivity
---
# Platform Reliability Measures: SLIs, SLOs And Error Budgets

A platform is a product that other teams depend on. If the provisioning service is down, no team can create an environment. This module teaches how a platform team states how reliable its services must be, measures it, and decides what to do when a service falls short. The hands-on work uses event counts stored in ConfigMaps and read with `kubectl` and `jq`.

## Learning Goals

- Define a service level indicator (SLI) as good events divided by valid events and choose indicators that match what users of a platform feel.
- Set a service level objective (SLO) with a target and a window, and convert a target into allowed bad events and allowed downtime.
- Compute the share of an error budget that a service has used and apply a budget policy.
- Compute a burn rate, estimate the time until the budget is gone and explain multi-window alerting.

## Before You Start

You should know what a ConfigMap and a namespace are in Kubernetes. Terms are defined where they first appear.

## Reading Order

1. Service Level Indicators For A Platform
2. Service Level Objectives, Windows And The Nines
3. Error Budgets And Budget Policy
4. Burn Rate And Alerting On Budget Use
5. Summary

<!-- astrona:playground -->
