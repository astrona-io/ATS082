---
draft: true
exam_objectives:
  - Platform Efficiency and Team Productivity
---
# Burn Rate And Alerting On Budget Use

The share of budget used is known only at the end of the window, and by then the damage is done. A team needs a number that shows how fast the budget is being used now, so it can act while there is still budget left. That number is the burn rate.

## What a burn rate is

The **burn rate** is how fast a service uses its error budget compared with the rate that would use exactly the whole budget by the end of the window. A burn rate of 1 means the budget would be gone exactly at the end of the window. A burn rate of 2 means it would be gone in half the window. A burn rate below 1 means the budget would last.

The formula uses error ratios, which are bad events divided by total events:

```
burn rate = observed error ratio / allowed error ratio
```

The allowed error ratio is (100 - target) / 100. For a target of 99.5 percent it is 0.005.

## A worked example

The ConfigMap `recent-hour` holds the events of `provisioning-api` in the last hour: 10000 events and 100 bad events. The observed error ratio is 100 / 10000, which is 0.01. The allowed ratio is 0.005. The burn rate is 0.01 / 0.005, which is 2.

<!-- astrona:playground:renew -->

Save both data sets:

```sh
kubectl -n metrics get configmap service-events -o json | jq -r '.data["services.json"]' > services.json
kubectl -n metrics get configmap recent-hour -o json | jq -r '.data["hour.json"]' > hour.json
```

Compute the burn rate of the last hour:

```sh
jq -n --slurpfile svc services.json --slurpfile hr hour.json '($hr[0].bad_events / $hr[0].total_events) / (($svc[0][] | select(.service == $hr[0].service) | (100 - .slo_target_percent)) / 100)'
```

The output is `2`. If the service kept this rate, a full 30-day budget would last 30 divided by 2, which is 15 days. A burn rate of 2 for one hour is not urgent. The same rate for ten days would use the whole budget.

## Time to exhaust the budget

Time to exhaust is the window divided by the burn rate, applied to a full budget. At a burn rate of 1, a 30-day budget lasts 30 days. At 14.4, it lasts about 2 days. A high burn rate is an emergency even if the total used is small so far.

The share of budget used by a burn rate over a period is also simple: the burn rate times the period divided by the window. A burn rate of 14.4 for one hour uses 14.4 x 1 / 720 hours, which is 2 percent of a 30-day budget.

## Why alerts use burn rate

An alert on the SLI itself is noisy: a short spike fires it, and a slow leak does not. An alert on burn rate is tied to the budget. It fires when the rate would exhaust the budget soon, and it stays silent for a spike too small to matter.

Teams combine two windows to limit false alarms. A long window (for example one hour) shows that the problem is real. A short window (for example five minutes) shows that it is still happening. The alert fires only when both are above the threshold, and it stops quickly when the problem ends. Many teams use more than one pair:

| Burn rate | Long window | Action |
| --- | --- | --- |
| 14.4 | 1 hour | Page a person now |
| 6 | 6 hours | Page a person |
| 1 | 3 days | Open a ticket |

Those values come from a published approach for a 30-day window, and a team adjusts them to its own targets. The logic is what matters: a fast burn needs a fast response, and a slow burn needs a ticket.

## Checking your work

Change the hour in your local `hour.json` to 25 bad events and compute again. The error ratio is 0.0025, the burn rate is 0.5, and a full budget lasts 60 days, so the service is well within its budget at that rate. With 500 bad events the ratio is 0.05, the burn rate is 10 and a full budget lasts 3 days. The same formula gives each answer.

## What you know now

The burn rate compares the current error ratio with the allowed one, and time to exhaust follows from it. Alerts on burn rate over two windows warn early without firing on spikes. A platform team now has a way to state reliability, allow failure and react to a fast loss of budget.

## Common pitfalls

> [!WARNING]
> Do not alert on a single short window. Do not read a burn rate from too few events. Do not copy burn rate thresholds from another service without checking its target.
