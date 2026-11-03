---
draft: true
exam_objectives:
  - DORA Metrics for Platform Initiatives
---
# Delivery Metrics From Deployment Events

This module explains the five software delivery metrics of the DORA research programme and computes them from raw deployment events. It defines each metric, says which events it needs, and shows how the choice of statistic and the handling of failed deployments change the result. The hands-on part works on a list of deployments of one service with `kubectl` and `jq`.

## Learning Goals

- Name the five delivery metrics and sort them into the throughput group and the instability group.
- Define change lead time, deployment frequency, failed deployment recovery time, change fail rate and deployment rework rate.
- List the events and timestamps that each metric needs.
- Compute the five metrics from deployment events with `jq`, with a stated statistic and a stated window.
- Explain why a median is preferred to a mean for durations and why the service is the unit of measurement.
- State the window, the statistic, the unit and the count for every metric value, and handle empty windows and even counts.
- Write down definitions of deployment, failed deployment, rework and recovery start and end.

## Before You Start

You should know what a deployment is and what a ConfigMap is in Kubernetes. The playground holds deployment events in a ConfigMap and you read them with `kubectl` and `jq`. Technical terms are defined where they first appear.

## Reading Order

1. The Five Delivery Metrics
2. Computing The Metrics From Deployment Events
3. Windows, Medians And Edge Cases In Deployment Data
4. Defining Deployment, Failure And Recovery In Deployment Events
5. Summary

<!-- astrona:playground -->
