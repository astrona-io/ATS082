---
draft: true
exam_objectives:
  - DORA Metrics for Platform Initiatives
---
# Summary

The five delivery metrics need reliable data. Version control, the deployment pipeline, incident tools and change records supply it, and a platform that writes the same deployment record for every service makes the numbers comparable. The definitions of deployment, failure, recovery and service are written down and stay the same.

A metric is read over time. The team computes each metric over the same window with the same definition, shows the number of deployments behind it and compares the service with its own past. Teams with different products are not ranked against one another, because a ranking invites a change in how people count.

When a number is weak, the team finds the constraint, looks at the failing records for a pattern and maps the cause to a platform capability: faster pipelines for lead time, automated tests and progressive delivery for the change fail rate, observability and rollback for recovery time. It changes one thing, measures again and states how limited the evidence is.

Throughput and instability are always read together. A change that raises throughput and raises failures has moved the problem. Small samples are shown with their counts, and one quarter is not a trend.

Metrics used as targets get gamed, so they are used to start conversations and not to judge people. They describe the delivery of changes only and cannot say whether the changes were the right ones.

Key facts:

- Change lead time, deployment frequency and failed deployment recovery time are throughput measures; change fail rate and deployment rework rate are instability measures.
- The median of an even number of values is the average of the two middle values.
- Report the count of deployments next to every metric.
- A service is compared with its own history.

<!-- astrona:playground:destroy -->
