---
draft: true
exam_objectives:
  - DORA Metrics for Platform Initiatives
---
# Computing Delivery Metrics From Deployment Events

A definition becomes a number only when someone writes down the steps: which records are in the set, which two timestamps are subtracted, which statistic is taken and in which unit the answer is printed. Two people who skip these decisions get two different numbers from the same data. This part computes all five metrics from the deployment records of `shuttle-api` and states every decision.

## Decisions before any calculation

Make four decisions first and write them next to the result.

1. **The service and the window.** The unit is one service and the window is 10 days, from 2026-10-05 to 2026-10-14.
2. **The set of records.** Every production deployment of that service in the window is one record. A deployment to a test environment is not in the set.
3. **The statistic for a duration.** Lead time and recovery time are durations. This module uses the median.
4. **The unit.** Lead time is in hours and recovery time is in minutes.

A report that says "lead time is 6" is incomplete. The same report says "median change lead time is 6 hours for `shuttle-api`, 2026-10-05 to 2026-10-14, 20 deployments".

<!-- astrona:playground:renew -->

Save the data again, so that this part works on its own:

```sh
kubectl -n delivery get configmap deployments -o json | jq -r '.data["deployments.json"]' > deployments.json
```

## Turning timestamps into durations

The timestamps are text in UTC, such as `2026-10-05T06:00:00Z`. `jq` converts them to seconds with `fromdateiso8601`. Subtracting two such numbers gives the duration in seconds, and dividing gives hours or minutes. Print the lead time of the first record:

```sh
jq '.[0] | ((.deployed_at | fromdateiso8601) - (.committed_at | fromdateiso8601)) / 3600' deployments.json
```

The result is `4`, which is the 4 hours between 06:00 and 10:00. The divisor 3600 is the number of seconds in an hour. For minutes the divisor is 60.

## The median needs a sorted list

A median is the middle value of a sorted list. With an odd number of values it is the single middle one. With an even number it is the average of the two middle ones. `jq` has no median function, so define one and use it:

```sh
jq 'def median: sort | if length % 2 == 1 then .[(length-1)/2] else (.[length/2-1] + .[length/2]) / 2 end;
    [.[] | ((.deployed_at | fromdateiso8601) - (.committed_at | fromdateiso8601)) / 3600] | median' deployments.json
```

The sorted lead times of the 20 changes are 2, 3, 3, 4, 4, 5, 5, 5, 6, 6, 6, 7, 7, 8, 9, 10, 12, 26, 30 and 48 hours. The 10th and 11th values are both 6, so the median is `6`. The mean of the same list is 10.3. Three slow changes of 26, 30 and 48 hours pull the mean far above the typical change, and the median stays at 6. A median describes the typical change and the mean describes the total waiting divided by the count. A report states which one it uses.

## Frequency and the two rates

Deployment frequency is the count divided by the days:

```sh
jq 'length / 10' deployments.json
```

The result is `2`, which is 2 deployments per day. The two rates are a count of marked records divided by the count of all records, times 100:

```sh
jq '([.[] | select(.needed_intervention)] | length) / length * 100' deployments.json
jq '([.[] | select(.unplanned_rework)] | length) / length * 100' deployments.json
```

The first result is `25` because 5 of 20 deployments needed intervention. The second is `10` because 2 of 20 were unplanned rework. Both rates use the same denominator, all deployments in the window.

## Recovery time uses failed deployments only

Failed deployment recovery time exists only for deployments that failed. A successful deployment has no `recovered_at`, and including it would either break the calculation or add a false zero. Select the failed records first, then subtract:

```sh
jq 'def median: sort | if length % 2 == 1 then .[(length-1)/2] else (.[length/2-1] + .[length/2]) / 2 end;
    [.[] | select(.needed_intervention) | ((.recovered_at | fromdateiso8601) - (.deployed_at | fromdateiso8601)) / 60] | median' deployments.json
```

The five recovery times are 20, 90, 35, 300 and 50 minutes for `d03`, `d08`, `d11`, `d15` and `d18`. Sorted they are 20, 35, 50, 90 and 300, so the median is `50`. The mean is 99 minutes, pulled up by the single recovery of 300 minutes. With only five failures the figure is fragile. One more long recovery changes the median noticeably, so a report shows the count next to the value.

## The five results together

| Metric | Value | Group |
| --- | --- | --- |
| Deployment frequency | 2 per day | Throughput |
| Change lead time, median | 6 hours | Throughput |
| Failed deployment recovery time, median | 50 minutes | Throughput |
| Change fail rate | 25 percent | Instability |
| Deployment rework rate | 10 percent | Instability |

A fail rate of 25 percent is high even though the throughput figures look good. The data shows a service that ships fast and often, and one deployment in four needs intervention. Reading only the throughput row would hide that.

## Where the platform shows up in these numbers

The platform changes these figures through its mechanisms. A faster pipeline and automated tests shorten lead time. A rollback that takes one command shortens recovery time. A progressive rollout that detects a bad version before full exposure lowers the fail rate. The numbers do not prove which mechanism did the work, and the next module explains why. Here the point is that each number has a mechanism the platform can act on.

## Checks before publishing a number

- The record count equals the count in the source system.
- Every timestamp is in the same time zone. Mixing local time and UTC shifts durations by hours.
- A `deployed_at` earlier than `committed_at` signals a data error, and the record needs a look before it is used.
- A failed deployment has a `recovered_at`, and no successful one has it.
- The window and the service appear next to the value.

## What you know now

A metric is a definition plus four decisions: the set of records, the two timestamps, the statistic and the unit. For `shuttle-api` over 10 days the results are 2 deployments per day, a median lead time of 6 hours, a median recovery time of 50 minutes, a fail rate of 25 percent and a rework rate of 10 percent. Medians describe the typical case, and a small count makes any value fragile.

## Common pitfalls

> [!WARNING]
> Do not include successful deployments in recovery time. Do not mix a mean and a median between reports. Do not compare a value from a 10-day window with a value from a 30-day window as if the windows were the same. Do not publish a rate without the count behind it.
