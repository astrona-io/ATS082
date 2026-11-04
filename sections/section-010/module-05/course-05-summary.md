---
draft: true
exam_objectives:
  - Platform Efficiency and Team Productivity
---
# Summary

A platform team states reliability with numbers that users can feel. A service level indicator is the share of good events among valid events, measured where the user meets the service. Availability, latency, correctness and job timeliness cover most platform services, and the source of the events and the rule for valid events belong to the definition.

A service level objective sets a target for an indicator over a window. The target converts to allowed bad events and to allowed downtime, and each extra nine cuts the allowed failure by ten times. Each service is compared with its own target, so a higher indicator can still miss a stricter objective. A target of 100 percent is not useful.

An error budget is the number of bad events the objective allows. The share used is the bad events divided by the allowed bad events. A budget policy, agreed in advance and owned by a person, turns that share into actions: normal work, extra care or a stop on risky changes. A service that uses none of its budget may be too reliable for its target.

The burn rate is the observed error ratio divided by the allowed error ratio. It shows how fast the budget is used and how long it will last. Alerts on the burn rate over a long and a short window warn early and do not fire on short spikes.

Key facts:

- SLI = good events / valid events x 100.
- Allowed bad events = total events x (100 - target) / 100.
- Budget used = bad events / allowed bad events x 100.
- Burn rate = observed error ratio / allowed error ratio.

<!-- astrona:playground:destroy -->
