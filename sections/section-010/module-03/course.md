---
draft: true
exam_objectives:
  - Platform Efficiency and Team Productivity
---
# Platform Adoption, Onboarding And Product Metrics

A platform only helps when teams use it. This module explains how a platform team measures adoption, onboarding time, self-service and user satisfaction, and how it reads those numbers without fooling itself. The hands-on work uses a table of twelve teams stored in a ConfigMap, which you read with `kubectl` and `jq`.

## Learning Goals

- Compute an adoption rate with eligible teams in the denominator and separate mandated adoption from voluntary adoption.
- Measure onboarding as the time from the first request to the first successful deployment, and report it with the median and the 90th percentile.
- Compute a self-service rate from self-service requests and manual tickets, and explain what a manual ticket costs.
- Compute a satisfaction score and a Net Promoter Score (NPS) from survey answers and read them together with adoption.
- Explain why the platform is run as a product with feedback loops.

## Before You Start

You should know what a ConfigMap and a namespace are in Kubernetes. The playground starts a kind cluster with the data in a ConfigMap. Technical terms are defined where they first appear.

## Reading Order

1. Adoption Rate And Active Use
2. Onboarding And Time To First Deployment
3. Self-Service, Tickets And Toil
4. The Platform As A Product: Satisfaction And Feedback
5. Summary

<!-- astrona:playground -->
