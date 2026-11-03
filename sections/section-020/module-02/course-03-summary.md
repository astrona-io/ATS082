---
draft: true
exam_objectives:
  - DORA Metrics for Platform Initiatives
---
# Summary

The early DORA research named four keys, and the current model has five metrics. Time to restore service, written MTTR, became failed deployment recovery time, which starts at a failed deployment. Change failure rate became change fail rate, and deployment rework rate was added to count the unplanned repair deployments. Throughput and instability are read together. A service can ship faster and fail more often, and a result that reports only the first group is incomplete.

The service is the unit of measurement. Inputs differ between services, a blended score has no owner, and a blend moves when the mix of services moves. A platform keeps one row for each service and counts how many services improved on each metric. An old dashboard panel called MTTR is checked for the events it counts, the start of the measure and the statistic before it is treated as recovery time.

A before-and-after change shows that numbers differ. Other changes in the same period, called confounders, can produce the same effect. A service that did not receive the change gives a comparison and shows how much improvement happened without it. Neither proves a cause. A claim states what the data shows, what it does not show and what the team proposes.

For the three services in this module both pipeline services improved lead time and frequency, one of them became less stable, and the service outside the pipeline also improved. The claim that the pipeline made every team better is not proven, and the scope for reporting is per service.

A metric used as a target is gamed, which is Goodhart's law. Delivery metrics show a team where to look, and they are not a ranking. Every platform change is paired with a check on the other group of metrics.

Key facts:

- Five metrics: lead time, frequency, recovery time, fail rate, rework rate.
- MTTR is the old name of failed deployment recovery time.
- Report each service separately and never one blended score.
- A comparison service helps and does not prove a cause.
- Check the instability group whenever throughput rises.

<!-- astrona:playground:destroy -->
