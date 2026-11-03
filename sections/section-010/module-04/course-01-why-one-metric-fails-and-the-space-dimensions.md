---
draft: true
exam_objectives:
  - Platform Efficiency and Team Productivity
---
# Why One Metric Fails, And The SPACE Dimensions

Leaders often ask for one number that says whether developers are productive. Every single number that people have proposed fails in a known way. This part shows the failure with a concrete case and then introduces SPACE, a framework with five dimensions that makes the gaps visible.

## A single metric is easy to game and easy to misread

Take "lines of code per developer". It rises when developers copy code, when they write code that is longer than needed and when they avoid deleting old code. It falls when a developer removes a thousand lines of dead code, which is good work. The number measures the volume of typing, not the value of the result.

Take "deployments per day" alone. It rises when a team splits one change into five small deployments. That can be a healthy practice, but the number cannot tell a healthy split from an empty one. If failures rise at the same time, the number hides the harm. Any single measure used alone can improve while the real outcome gets worse, and a measure that is also a target changes the behaviour it was meant to describe.

## The SPACE framework

**SPACE** is a framework from researchers at GitHub, Microsoft and the University of Victoria. The name stands for five dimensions of developer productivity:

- **Satisfaction and well-being:** how fulfilled developers are with their work, their team and their tools, and how healthy they are.
- **Performance:** the outcome of the work, for example quality and the effect on customers.
- **Activity:** the count of actions or outputs, for example pull requests, deployments or incidents handled.
- **Communication and collaboration:** how people and teams work together, for example how fast a code review gets an answer.
- **Efficiency and flow:** the ability to finish work with little delay and few interruptions.

The framework recommends choosing metrics from several dimensions, and at least one of them should be a perceptual measure that comes from asking people.

## Workflow and perceptual measures

A **workflow measure** comes from systems: timestamps, counts and states in a pipeline, a repository or a ticket tool. A **perceptual measure** comes from people: a survey answer or an interview. Workflow measures are objective and cheap once collected. Perceptual measures show what the systems cannot, for example whether a fast pipeline still feels slow, or whether people feel exhausted.

<!-- astrona:playground:renew -->

The example catalogue holds 13 metrics. Each record has the metric name, its SPACE `dimension`, its `level` (`team` or `individual`), its `measure` type and its DevEx area. Save it:

```sh
kubectl -n metrics get configmap metric-catalogue -o json | jq -r '.data["metrics.json"]' > metrics.json
```

Count the metrics in each dimension:

```sh
jq -c 'group_by(.dimension) | map({dimension: .[0].dimension, n: length})' metrics.json
```

The output is `[{"dimension":"activity","n":4},{"dimension":"communication","n":1},{"dimension":"efficiency","n":4},{"dimension":"performance","n":2},{"dimension":"satisfaction","n":2}]`. The catalogue has four activity metrics and four efficiency metrics, and only one communication metric. A set that leans on one dimension gives a one-sided view.

Look at the communication dimension:

```sh
jq -c '.[] | select(.dimension == "communication") | .metric' metrics.json
```

The output is `"review turnaround hours"`. The catalogue has one way to see collaboration, and a team that wants to understand collaboration should add more, for example a survey question about how easy it is to get help.

## Examples per dimension

| Dimension | Workflow example | Perceptual example |
| --- | --- | --- |
| Satisfaction and well-being | Retention of developers | Developer satisfaction survey |
| Performance | Change fail rate | Customer satisfaction with the product |
| Activity | Pull requests merged per week | Not usually measured by asking |
| Communication and collaboration | Review turnaround time | Survey on ease of getting help |
| Efficiency and flow | Build wait time | Survey on interruptions and focus time |

The table does not say that every metric is good. It shows where each could come from. Each metric also needs the limit of its meaning: review turnaround says how long a review waits, not how good the review is.

## What you know now

One metric fails because it can be gamed and because it covers one view. SPACE lists five dimensions and asks for several measures from different dimensions, mixing workflow and perceptual data. The open question is what makes the daily experience of a developer good or bad, which the DevEx framework addresses next.

## Common pitfalls

> [!WARNING]
> Do not pick a metric set from one dimension only. Do not read an activity count as a measure of value. Do not drop the perceptual measures because they are harder to collect.
