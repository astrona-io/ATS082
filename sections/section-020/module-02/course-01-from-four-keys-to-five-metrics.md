---
draft: true
exam_objectives:
  - DORA Metrics for Platform Initiatives
---
# From Four Keys To Five Metrics

Older material about DORA lists four key metrics, and current material lists five. A reader who meets both needs to know what changed, because the older names still appear in dashboards and in exam questions. This part describes the four keys, the current five-metric model and the reasoning behind the changes, then reads a set of metric values for three services.

## The four keys

The early DORA research named four measures of software delivery performance: lead time for changes, deployment frequency, time to restore service and change failure rate. Two of them described speed, lead time and frequency. Two described stability, time to restore and change failure. Teams were grouped into performance levels such as elite, high, medium and low, based on where their values fell.

## The current model

The current model keeps the idea of speed and stability and adjusts the definitions:

- **Change lead time** and **deployment frequency** stay as throughput measures.
- **Time to restore service**, also written MTTR, becomes **failed deployment recovery time**. The measure now starts at a failed deployment and not at any incident. An outage caused by a cloud provider has little to do with the delivery process, and the new definition keeps the metric about delivery.
- **Change failure rate** becomes **change fail rate**, the share of deployments that need immediate intervention.
- **Deployment rework rate** is new. It counts the unplanned deployments that happen because of a production incident, and it captures repair work that the fail rate does not show.

Recovery time moved into the throughput group because it describes how fast a team returns to a working state. The instability group then holds the two measures of how often delivery goes wrong, fail rate and rework rate.

## Why the rename matters in practice

Dashboards built years ago often show a panel called MTTR. Such a panel may count every incident, including incidents unrelated to a deployment, and it may use a mean. A reader who sees MTTR has to ask three questions before trusting the number. Which events does it count? Does it start at a failed deployment? Is it a mean or a median? A panel that cannot answer these is not failed deployment recovery time, even if the values look similar.

<!-- astrona:playground:renew -->

## Reading the data of three services

The playground holds metric values for three services, before and after a change to the platform pipeline. Two of the services deploy through the pipeline and one does not. Save the data:

```sh
kubectl -n delivery get configmap service-metrics -o json | jq -r '.data["metrics.json"]' > service-metrics.json
```

Print the lead time before and after for every service:

```sh
jq -r '.[] | .service + " " + (.platform_pipeline | tostring) + " " + (.before.lead_time_hours | tostring) + " -> " + (.after.lead_time_hours | tostring)' service-metrics.json
```

The services and values are `scout-api` with 48 hours before and 8 after, `probe-api` with 24 before and 6 after, and `drifter-api` with 40 before and 30 after. The two pipeline services improved strongly, and the service outside the pipeline improved as well.

## Reading throughput and instability together

Print the change fail rate for the same services:

```sh
jq -r '.[] | .service + " " + (.before.change_fail_rate_percent | tostring) + " -> " + (.after.change_fail_rate_percent | tostring)' service-metrics.json
```

`scout-api` moved from 10 to 20 percent, `probe-api` from 15 to 10 percent and `drifter-api` stayed at 10 percent. The rework rate of `scout-api` rose from 5 to 15 percent, the rate of `probe-api` fell from 10 to 5 percent and the rate of `drifter-api` stayed at 5 percent. The picture differs by service:

| Service | Throughput | Instability |
| --- | --- | --- |
| `scout-api` | Lead time fell and deployments per week rose from 2 to 10 | Fail rate and rework rate rose |
| `probe-api` | Lead time fell and deployments per week rose from 4 to 12 | Fail rate and rework rate fell |
| `drifter-api` | Lead time fell from 40 to 30 and deployments per week rose from 3 to 4 | Unchanged |

`scout-api` shows the pattern the research warns about. It ships five times as often and breaks twice as often. It reads as a gain in speed paid for with stability, and the platform team has a reason to look at whether the pipeline checks too little before release. `probe-api` improved on both groups.

## Blending hides the difference

Compute the average lead time of the three services after the change:

```sh
jq '[.[] | .after.lead_time_hours] | add / length' service-metrics.json
```

The result is `14.666666666666666`. That figure sits between 6 and 30 and describes none of the services. The average of the fail rate hides `scout-api` in the same way, because one rising value and one falling value partly cancel. A blended number answers a question nobody asked.

## The recovery metric in the same data

The field `mttr_minutes` holds the old metric. `scout-api` went from 120 to 60 minutes and `probe-api` from 90 to 45, and `drifter-api` stayed at 100. Read as failed deployment recovery time, this is an improvement for both pipeline services. It is a separate result from the fail rate. A service can recover faster and still fail more often, and `scout-api` does exactly that. Recovery time says how bad a failure is, and the fail rate says how often failures happen. Both matter to the people on call.

## Performance levels and why they are not a goal

Early reports sorted teams into levels such as elite and low. Levels help a reader see where a value sits among many teams. They do not say what a particular team should do next. A team with a lead time of two days may be in a good state if its service is a payment system with legal review, and in a poor state if its service is an internal tool. A platform initiative uses the levels as orientation and sets its own targets from the team's context.

## What the research says about each metric alone

A high deployment frequency with a high fail rate is a warning. A low fail rate with a deployment frequency of one per quarter may mean that the team avoids risk and delivers little. The research reports that speed and stability go together in the teams that perform best, and the metrics are only informative as a set. A platform initiative that moves one group and ignores the other has not shown an improvement.

## What you know now

The four keys became five metrics. MTTR became failed deployment recovery time, and rework rate was added. Throughput and instability must be read together, and a service can improve on one group while the other group worsens. A blended average across services hides these differences.

## Common pitfalls

> [!WARNING]
> Do not treat an old MTTR panel as failed deployment recovery time without checking what it counts. Do not report an improvement in throughput when instability worsened and leave the second part out. Do not average values across services to produce one score.
