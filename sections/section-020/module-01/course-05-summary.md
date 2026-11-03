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

A metric value is complete only with a window, a statistic, a unit and a count. Days are counted with both end days included, so 10 days from 5 to 14 October give 2 deployments per day. The median of an even count is the average of the two middle values. An empty window has no value, and a window without failures has no recovery time, which is not the same as 0 minutes. Timestamps are kept in UTC so that day boundaries do not move deployments.

Definitions must be written down before the numbers are compared. A deployment reaches production. A failed deployment needed an intervention such as a rollback or a hotfix. A deployment with rework was followed by an unplanned fix. The recovery time starts at the deployment, so it includes the time to detect the failure, and ends when the service is restored. In the example data five deployments failed and two needed rework, and the two sets share no deployment.

Key facts:

- Five metrics: three for throughput, two for instability.
- Recovery time is the current name of what was called MTTR.
- Compute recovery time over failed deployments only.
- Use a median for durations and state it.
- Always report the service, the window and the count.
- An even count has a median that is the average of the two middle values.
- Failures and rework are different sets and are counted separately.
- Recovery starts at the deployment, not at detection.

<!-- astrona:playground:destroy -->
