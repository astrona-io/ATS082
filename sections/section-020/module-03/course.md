---
draft: true
exam_objectives:
  - DORA Metrics for Platform Initiatives
---
# Collecting And Improving DORA Metrics With A Platform

A platform team that wants to use DORA metrics must first collect the data in a reliable way, then read the numbers over time, then decide what to improve and avoid the traps that make the numbers misleading. This module follows that path. The hands-on work uses 24 deployment records of one service over three quarters, stored in a ConfigMap and read with `kubectl` and `jq`.

## Learning Goals

- Name the data sources for the five DORA metrics and say what a platform must record in each.
- Compute each metric per quarter and compare a service with its own past, not with other teams.
- Find the weakest metric of a service and name platform capabilities that move it.
- Explain how throughput and instability are read together, and what DORA metrics cannot show.

## Before You Start

You should know what a ConfigMap and a namespace are in Kubernetes, and the five delivery metrics. Terms are defined where they first appear.

## Reading Order

1. Data Sources And Consistent Definitions
2. Trends Over Time And Performance Profiles
3. Finding The Constraint And Improving It With The Platform
4. Healthy Use Of DORA Metrics
5. Summary

<!-- astrona:playground -->
