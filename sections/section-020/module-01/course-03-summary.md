---
draft: true
exam_objectives:
  - DORA Metrics for Platform Initiatives
---
# Summary

The DORA model describes software delivery with five metrics in two groups. Throughput contains change lead time, deployment frequency and failed deployment recovery time. Instability contains change fail rate and deployment rework rate. The groups answer two separate questions, how fast and often changes reach production, and how often delivery goes wrong. Reading one group alone gives half of the picture.

Each metric has a precise definition and needs specific events. Change lead time is the time from commit to production deployment. Deployment frequency is the number of production deployments in a period. Failed deployment recovery time is the time from a failed deployment to recovery, and the older name for it is mean time to recovery. Change fail rate is the share of deployments that needed immediate intervention. Deployment rework rate is the share of deployments that were unplanned and caused by a production incident. Rework and failure are different sets of deployments.

A number needs four decisions written next to it: the service and window, the set of records, the statistic and the unit. Durations are summarised with a median because a few slow changes pull a mean far from the typical case. Recovery time is computed over failed deployments only. A rate needs its denominator, which is all deployments in the window. A small count, such as five failures, makes a value fragile and a report shows the count.

For `shuttle-api` over 10 days the result is 2 deployments per day, a median lead time of 6 hours, a median recovery time of 50 minutes, a fail rate of 25 percent and a rework rate of 10 percent. Fast delivery with a high fail rate is a finding that the throughput row alone would hide.

Key facts:

- Five metrics: three for throughput, two for instability.
- Recovery time is the current name of what was called MTTR.
- Compute recovery time over failed deployments only.
- Use a median for durations and state it.
- Always report the service, the window and the count.

<!-- astrona:playground:destroy -->
