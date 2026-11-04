---
draft: true
exam_objectives:
  - Platform Efficiency and Team Productivity
---
# Service Level Objectives, Windows And The Nines

An SLI says how reliable a service was. It does not say whether that was good enough. A service level objective states the target and the period in advance, so that the team and its users agree before a failure what "good enough" means.

## What a service level objective is

A **service level objective (SLO)** is a target for an SLI over a time window. For example, "99.5 percent of provisioning API requests succeed over 30 days". It has three parts: the SLI it applies to, the target value and the window. A **service level agreement (SLA)** is different: it is a contract with consequences, such as a refund, and it is usually less strict than the internal SLO so that the team notices a problem before it breaks the contract.

A window can be a rolling window (always the last 30 days) or a calendar window (a month). A rolling window moves gradually and avoids a sudden reset on the first of the month. A calendar window is easy to report. Both are valid if the team states which one it uses.

## From a target to allowed bad events

The target converts to a number of events that may fail. The rule is:

```
allowed bad events = total events x (100 - target) / 100
```

Use the playground data. The `provisioning-api` had 200000 events in the window with a target of 99.5. The allowed bad events are 200000 x 0.5 / 100, which is 1000. The `pipeline-runner` had 50000 events with the same target, so it may have 250 bad events.

<!-- astrona:playground:renew -->

Save the data if you do not have it:

```sh
kubectl -n metrics get configmap service-events -o json | jq -r '.data["services.json"]' > services.json
```

Compute the allowed bad events and the actual bad events:

```sh
jq -c '.[] | {service, target: .slo_target_percent, allowed: (.total_events * (100 - .slo_target_percent) / 100), bad: (.total_events - .good_events)}' services.json
```

The output shows allowed 1000 and bad 600 for `provisioning-api`, allowed 250 and bad 300 for `pipeline-runner`, allowed 100 and bad 50 for `portal`, and allowed 100 and bad 110 for `artifact-registry`. A service meets its SLO when the bad events are no more than the allowed bad events. Here `provisioning-api` and `portal` meet it, and `pipeline-runner` and `artifact-registry` do not.

## The nines and allowed downtime

Targets are often called by their number of nines. For a service that is either up or down, a target converts to allowed downtime in a 30-day window of 43200 minutes:

| Target | Allowed downtime in 30 days |
| --- | --- |
| 99 percent | 432 minutes |
| 99.5 percent | 216 minutes |
| 99.9 percent | 43.2 minutes |
| 99.95 percent | 21.6 minutes |
| 99.99 percent | 4.32 minutes |

Each extra nine cuts the allowed failure by ten times, and it usually costs much more to reach. A move from 99.9 to 99.99 percent cannot be reached by a human who restarts a service by hand, because the whole allowance is under five minutes.

## How to pick a target

A target must be set from the needs of users and from what the service can reach, not from a wish for perfection. A target of 100 percent is wrong: it leaves no room for any change, and users cannot tell the difference between 100 and 99.99 percent because their own networks fail more often. A good process starts with the current SLI over a few months, asks what users need, and sets a target a little below what the service already achieves, then raises it if users need more.

Different services deserve different targets. In the data, the `portal` and the `artifact-registry` have 99.9, because a failed image pull stops deployments. The `provisioning-api` and `pipeline-runner` have 99.5, because a developer can retry a request. The target follows the cost of a failure to the user.

## Comparing the SLI with the target

Compare each SLI with its own target, not with the other services. An SLI of 99.89 percent looks better than 99.7 percent, but the first belongs to a service with a 99.9 target and the second to one with a 99.5 target. The first misses its objective and the second meets it.

```sh
jq -c '.[] | {service, sli: (.good_events * 100 / .total_events), target: .slo_target_percent, met: ((.good_events * 100 / .total_events) >= .slo_target_percent)}' services.json
```

The output shows `met` true for `provisioning-api` (99.7 against 99.5) and `portal` (99.95 against 99.9), and false for `pipeline-runner` (99.4 against 99.5) and `artifact-registry` (99.89 against 99.9).

## What you know now

An SLO is a target for an SLI over a window. The target converts to allowed bad events and allowed downtime, each extra nine costs ten times less failure, and every service is compared with its own target. The open question is what the team does with the allowed failures, which is the idea of the error budget.

## Common pitfalls

> [!WARNING]
> Do not set a target of 100 percent. Do not compare services with different targets by their raw SLI. Do not confuse an internal SLO with an SLA.
