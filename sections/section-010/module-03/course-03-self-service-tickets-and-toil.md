---
draft: true
exam_objectives:
  - Platform Efficiency and Team Productivity
---
# Self-Service, Tickets And Toil

A platform exists to remove work from teams and from the platform team. When a team can get what it needs by itself, without waiting for a person, the platform has done its job. This part defines the self-service rate, shows how to compute it from requests and tickets, and explains toil and the cost of a manual step.

## Self-service and manual requests

A request is **self-service** when the team completes it through the platform without a person on the platform team doing a step. Examples are creating a namespace from a template or starting a pipeline. A request is **manual** when a person must act, usually through a ticket. The example data has two monthly counts for each team: `self_service_requests` and `manual_tickets`.

The **self-service rate** is self-service requests divided by all requests, which are self-service requests plus manual tickets, times 100. The denominator holds every request for the capability, so a team that files many tickets lowers the rate.

<!-- astrona:playground:renew -->

Save the data from the ConfigMap if you do not have the file:

```sh
kubectl -n metrics get configmap team-adoption -o json | jq -r '.data["teams.json"]' > teams.json
```

Add up both counts over all 12 teams:

```sh
jq '[.[].self_service_requests] | add' teams.json
jq '[.[].manual_tickets] | add' teams.json
```

The output is `64` and `55`. The self-service rate is 64 divided by 119, which is 53.8 percent. The same rate in one command is:

```sh
jq '([.[].self_service_requests] | add) as $s | ([.[].manual_tickets] | add) as $m | $s * 100 / ($s + $m)' teams.json
```

The output is `53.78151260504202`. A report rounds it to 53.8 percent and states the month.

## Where the tickets come from

A rate over all teams hides who still files tickets. The adopted teams and the teams that did not adopt have different counts:

```sh
jq '[.[] | select(.onboarded) | .manual_tickets] | add' teams.json
jq '[.[] | select(.onboarded | not) | .manual_tickets] | add' teams.json
```

The output is `33` and `22`. Teams that have not onboarded file 22 manual tickets, from only 5 teams. The teams `t06` and `t07` file 10 and 7 tickets and have no self-service requests. These are the teams that benefit most from the platform, and they are the teams it has not reached. The adopted teams still file 33 tickets, so even they meet steps that the platform does not automate. The ticket text shows which steps those are.

## Toil and the cost of a manual step

**Toil** is repetitive manual work that grows with the size of the system and brings no lasting value. A ticket that asks a person to create the same kind of resource each time is toil. Every manual ticket has a cost in the time of the requester, who waits, and in the time of the platform engineer, who acts. A team can estimate the cost: tickets per month times average minutes of handling. Fifty-five tickets at 30 minutes of handling cost 27.5 hours a month, which is a figure that supports a decision to automate the top ticket type.

The estimate rests on an assumption, the average handling time, which should come from a sample of real tickets and be stated in the report. The waiting time of the requester is often larger than the handling time and is measured separately with timestamps.

## Reading the rate with care

A rising self-service rate is good only when the requests are useful. If a team creates many unused environments because it is easy, the rate rises and cost rises with it. The rate also needs a stable definition of manual: if the platform team starts to approve requests by chat instead of tickets, the rate rises while the manual work stays. The number must be read together with the onboarding time and the satisfaction score.

## What you know now

The self-service rate is self-service requests over all requests for a capability. It shows the work that the platform removes. Tickets show the steps that remain manual, and an estimate of their cost helps a team decide what to automate first. The open question is whether the teams are satisfied, which the next part measures.

## Common pitfalls

> [!WARNING]
> Do not count only self-service requests and leave out manual tickets in the denominator. Do not estimate toil cost without stating the handling time and where it came from. Do not celebrate a rising self-service rate without checking that the requests are useful.
