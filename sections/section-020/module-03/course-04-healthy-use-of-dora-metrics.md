---
draft: true
exam_objectives:
  - DORA Metrics for Platform Initiatives
---
# Healthy Use Of DORA Metrics

Metrics change behaviour as soon as people know that they are used to judge them. A platform team must plan for this, report the numbers in a way that supports good decisions and be clear about what the numbers cannot show. This part gives practical rules.

## Goodhart's law in delivery metrics

**Goodhart's law** says that when a measure becomes a target, it stops being a good measure. For DORA metrics, the examples are easy to find. A team that is rewarded for deployment frequency splits one change into many empty deployments. A team that is judged on change fail rate stops reporting failures, or calls them something else. A team that is judged on lead time starts the clock later.

The numbers that result look better and the delivery gets no better. The protection is to use the metrics to start conversations and to find problems, and not to set a target for each team or tie the numbers to pay.

## Read throughput and instability together

DORA groups the metrics into **throughput** (change lead time, deployment frequency, failed deployment recovery time) and **instability** (change fail rate, deployment rework rate). A report always shows both groups. A platform initiative that raises throughput and raises instability has moved the problem, not solved it.

<!-- astrona:playground:renew -->

Save the data from the ConfigMap if you do not have the file:

```sh
kubectl -n delivery get configmap deployment-history -o json | jq -r '.data["deployments.json"]' > deployments.json
```

Put the throughput and instability numbers of Q2 and Q3 side by side:

```sh
jq -c 'def med: sort | (length) as $n | if ($n % 2) == 1 then .[($n-1)/2] else (.[$n/2-1] + .[$n/2]) / 2 end; [.[] | select(.quarter != "Q1")] | group_by(.quarter) | map({quarter: .[0].quarter, deployments: length, median_lead_hours: ([.[].lead_time_hours] | med), fail_rate: (([.[] | select(.failed)] | length) * 100 / length)})' deployments.json
```

The output is `[{"quarter":"Q2","deployments":8,"median_lead_hours":37,"fail_rate":12.5},{"quarter":"Q3","deployments":10,"median_lead_hours":22.5,"fail_rate":20}]`. Throughput improved: more deployments and a lower lead time. Instability is higher: 20 percent against 12.5 percent. The correct sentence is "Q3 is faster and failed more often", and the numbers do not justify "Q3 improved".

## Small samples

The change from 12.5 to 20 percent is a difference of one deployment out of eight and two out of ten. With so few records, random variation can explain it. A platform team states the counts and does not claim a trend from one quarter. It looks at the next quarter and at the failing deployments themselves, for example whether the two failures share a cause.

## Reporting to leadership

A report for leaders states, for each metric, the value, the previous value, the number of deployments, the window and the definition. It states what the platform team will do next and what it does not know. Leaders may ask for one score. The honest answer is that the five metrics describe two sides of delivery and one score would hide the trade-off.

## What the metrics cannot show

DORA metrics describe the delivery of changes. They do not show whether the changes were the right ones, whether customers value them or whether developers are well. They cannot show why the numbers moved. A team that wants those answers adds measures of product outcomes and developer experience and talks to the people. The metrics also say nothing about a service that deploys rarely because it is stable and finished, where a low deployment frequency is not a problem.

## What you know now

Delivery metrics are used to find problems and ask questions, not to set targets or rank people. Throughput and instability are read together, small samples are shown with their counts and the report says what is unknown. The metrics describe delivery only and need other evidence to judge the value of the work.

## Common pitfalls

> [!WARNING]
> Do not set a target for each DORA metric and tie it to pay. Do not claim an improvement when only throughput improved. Do not present a one-quarter change in a small sample as a trend.
