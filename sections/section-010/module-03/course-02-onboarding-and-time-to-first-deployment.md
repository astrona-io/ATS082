---
draft: true
exam_objectives:
  - Platform Efficiency and Team Productivity
---
# Onboarding And Time To First Deployment

Teams that want to use a platform must first get started. A long and painful start stops teams from adopting, and it is the first experience of the platform that every team has. This part defines the onboarding time, computes its median and 90th percentile, and shows how to compare groups of teams.

## The onboarding time

**Onboarding** is the process that takes a team from its first request for the platform to a working result. The result must be something the team can verify. A common choice is the first successful deployment of a real service through the platform. The **time to first deployment** is the number of days from the first request to that deployment. The field `days_to_first_deploy` holds it in the example data.

Choosing the end event matters. "The account was created" is easy to measure but proves nothing about value. "The first successful deployment" proves that the team can use the platform to ship. A report states the start event, the end event and the unit.

## Teams that did not finish

Only teams that finished have a value. The three eligible teams that have not onboarded have `null` for the days. They are the teams with the worst experience, so leaving them out of the statistics is survivorship bias, the same error as ignoring failed requests in a completion time. The report must show the number of teams that finished next to the time they needed.

<!-- astrona:playground:renew -->

Save the data from the ConfigMap if you do not have the file:

```sh
kubectl -n metrics get configmap team-adoption -o json | jq -r '.data["teams.json"]' > teams.json
```

List the days of the teams that finished, in sorted order:

```sh
jq -c '[.[] | select(.onboarded) | .days_to_first_deploy] | sort' teams.json
```

The output is `[3,4,5,6,9,12,20]`. There are 7 values.

## Median and 90th percentile

The median is the middle value. With 7 values the middle is position 4, which is 6 days. The 90th percentile with the nearest-rank method is the value at position `ceil(0.9 x 7)`, which is `ceil(6.3)`, so 7. That value is 20 days. Define a function that returns a percentile of the sorted values and run it:

```sh
jq -c 'def pctl($p): sort | .[((length * $p) | ceil) - 1]; [.[] | select(.onboarded) | .days_to_first_deploy] | {p50: pctl(0.5), p90: pctl(0.9)}' teams.json
```

The output is `{"p50":6,"p90":20}`. The report can say: half of the teams that finished needed 6 days or less, and 90 percent needed 20 days or less, and 3 of 10 eligible teams have not finished at all.

The mean of the same values is 8.43 days. It is higher than the median because of the 20-day team. A mean can hide that most teams were fast. The median and p90 describe both the usual start and the slow start.

## Comparing groups

An overall number hides differences between groups. Compare the teams that were mandated with the teams that chose the platform:

```sh
jq -c '[.[] | select(.onboarded and .mandated) | .days_to_first_deploy] | sort' teams.json
jq -c '[.[] | select(.onboarded and (.mandated | not)) | .days_to_first_deploy] | sort' teams.json
```

The mandated teams needed `[9,12,20]` days and the voluntary teams needed `[3,4,5,6]` days. The slowest teams are the mandated ones. Possible reasons are legacy code that is hard to move or less motivation, and the data alone cannot decide between them. The comparison shows where to look, and the team must collect more evidence before it claims a cause. With 3 and 4 teams in the groups, a difference of a few days is also weak evidence.

```mermaid
flowchart LR
  R["First request"] -->|"access"| A["Account and access"]
  A -->|"setup"| T["Template and pipeline"]
  T -->|"deploy"| D["First successful deployment"]
```

The diagram shows the stages of onboarding. The time to first deployment is the whole chain from the first request to the deployment, and a team can add a timestamp for each stage to find which stage waits longest.

## Using the number

A target for onboarding must fit the capability. A platform that offers a ready template can aim for hours. A platform that needs network approval may need days. The number is most useful as a trend and as a list of stuck teams. A team that waits for 20 days is a case to study with an interview, because the number says that it is slow but not why.

## What you know now

Onboarding time is measured from a defined first request to a defined first successful deployment, reported with the median, a high percentile and the count of teams that finished. Groups are compared with care, because small groups give weak evidence. The open question is how much work the platform removes after onboarding, which the next part measures with the self-service rate.

## Common pitfalls

> [!WARNING]
> Do not compute onboarding statistics over finished teams without saying how many teams did not finish. Do not use an account creation as the end event. Do not explain a difference between two small groups with one cause without more evidence.
