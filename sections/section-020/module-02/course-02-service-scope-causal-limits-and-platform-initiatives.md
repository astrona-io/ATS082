---
draft: true
exam_objectives:
  - DORA Metrics for Platform Initiatives
---
# Service Scope, Causal Limits And Platform Initiatives

A platform team wants to show that its work helped. Delivery metrics look like the right evidence, and they are, within limits. This part covers three limits that decide whether a claim holds: the metrics belong to one service, a before-and-after change does not prove a cause, and a metric used as a target changes behaviour. It then writes a claim that matches the data of the three services.

## The service is the unit

The five metrics describe how one application is delivered: one code base, one pipeline, one set of deployments and one set of failures. The DORA material states that the metrics are meant for a single application or service. Three reasons explain why.

1. **The inputs differ by service.** A service with a database migration on every release has a different lead time from a stateless web front end. Both teams can work equally well.
2. **A blend has no owner.** A score for the organisation cannot be improved by any team, because no team controls it.
3. **A blend moves for the wrong reasons.** When a team with many small deployments is added, the organisation's frequency rises and no team delivers faster.

A platform sees many services, and that makes a blended number tempting. The platform should keep a table with one row for each service and read it row by row. A summary of the table can say how many services improved on each metric.

<!-- astrona:playground:renew -->

Save the data of the three services and count the services that improved on lead time and on fail rate:

```sh
kubectl -n delivery get configmap service-metrics -o json | jq -r '.data["metrics.json"]' > service-metrics.json
jq '[.[] | select(.after.lead_time_hours < .before.lead_time_hours)] | length' service-metrics.json
jq '[.[] | select(.after.change_fail_rate_percent < .before.change_fail_rate_percent)] | length' service-metrics.json
```

The first count is `3` because every service has a lower lead time. The second is `1` because only `probe-api` has a lower fail rate. Counting services keeps the unit visible. A statement such as "three of three services shipped faster and one of three failed less often" is accurate and has no blended average.

## A change after an event is not a result of the event

The claim from planning says that the platform pipeline made every team better. The data shows that lead time fell for `scout-api` and `probe-api` after the pipeline change. Two things make that insufficient.

First, other changes happen in the same period. A team may have split a large service, hired a person or removed a manual approval. A change like that is called a confounder. The comparison cannot separate its effect from the effect of the pipeline.

Second, find a service that did not change. `drifter-api` does not use the pipeline, and its lead time still fell from 40 to 30 hours. Some of the improvement across the organisation has a cause that is not the pipeline, such as a general effort, a quieter period or a shared change in review practice.

Check which services improved without the pipeline:

```sh
jq -r '.[] | select(.platform_pipeline == false and .after.lead_time_hours < .before.lead_time_hours) | .service' service-metrics.json
```

The output is `drifter-api`. A service outside the change is a comparison group. It does not make a proof, and it shows how much improvement to expect without the change. The pipeline services improved from 48 to 8 hours and from 24 to 6, which is much more than 40 to 30. That difference supports the pipeline as one cause. It does not show that the pipeline is the only cause, and it says nothing about the other metrics.

## What a defensible claim looks like

A claim has three parts: what the data shows, what it does not show and what the platform team proposes. For this data:

- Shows: lead time fell and deployments per week rose for both pipeline services, with larger gains than the service outside the pipeline.
- Shows: the fail rate and the rework rate rose for `scout-api`.
- Does not show: that the pipeline caused the changes, because no one controlled for other changes, and the sample is three services over one period.
- Proposes: report each service separately, investigate the checks in the pipeline for `scout-api` and keep `drifter-api` as a comparison.

The claim "made every team better" fails on two counts. The word every is wrong for `scout-api` on instability. The word made states a cause that the data cannot prove. The decision for the report is `not-proven` and the scope is per service.

## Metrics used as targets

A delivery metric that becomes a target stops describing delivery. This is Goodhart's law. If deployment frequency is a target, a team can split every change into trivial deployments. If change fail rate is a target, a team can stop calling failures failures, or can avoid releasing. If lead time is a target, a team can start the clock later by opening the change late. Each response improves the number and not the delivery.

The research recommends using the metrics to see where a team is and where to look, and not as a ranking between teams or a performance review input. A platform team applies this by showing the metrics to the team that owns the service, by pairing them with a conversation, and by checking the instability group whenever a throughput value is pushed up.

## Platform changes and what to expect

A platform change tends to move the metrics in recognisable ways:

| Change | Metric it can move | Check next |
| --- | --- | --- |
| Faster build and test in the pipeline | Change lead time | Change fail rate, in case checks were removed |
| Automated promotion between environments | Deployment frequency | Rework rate |
| One-command rollback | Failed deployment recovery time | Change fail rate stays the same or falls |
| Progressive rollout with an automatic stop | Change fail rate | Lead time, in case the rollout adds waiting |

The last column is the point. Every change has a side to check in the other group.

## Questions that test a claim

Before a platform team repeats a result, it asks a short list of questions about it.

1. Which service does the number describe, and for which window?
2. What else changed for that service in the same window?
3. Is there a similar service that did not change, and what did it do?
4. Did the other group of metrics move in the wrong direction?
5. How many deployments and failures stand behind each rate?

A claim that survives all five is still a statement about a few services in one period. It supports a decision to continue the work and to keep measuring. It does not support a statement that the platform always improves delivery.

## What to put in a report

A report for a platform initiative lists the service, the window, the five values before and after, the count of deployments and failures behind each rate, the other changes known in the period, a comparison service if one exists, and a statement of what the data cannot say. It avoids the words proves and every unless the evidence supports them.

## What you know now

The service is the unit of measurement, and a blended score has no owner and hides differences. A before-and-after change shows that numbers differ and cannot separate the effect of the platform from other changes. A service outside the change gives a comparison. Targets on metrics invite gaming. For the three services the supported statement is that both pipeline services shipped faster and more often, that `scout-api` became less stable, and that `drifter-api` improved without the pipeline, so the claim is not proven.

## Common pitfalls

> [!WARNING]
> Do not report one organisation-wide score. Do not write that a platform change caused an improvement when only a before-and-after comparison exists. Do not use delivery metrics to rank teams. Do not leave out the instability group when a throughput value rose.
