---
draft: true
exam_objectives:
  - Platform Efficiency and Team Productivity
---
# Summary

A request reserves capacity in Kubernetes, a limit caps use, and usage is what a container really consumes. Utilization is usage divided by the request. The fleet value comes from sums over all teams, not from an average of percentages, and a monthly average can hide peaks that need headroom.

Cost reaches teams through namespaces and labels. Showback reports cost without charging it, and chargeback moves it to a budget. Direct cost is allocated by use, shared cost needs a written rule, and unit costs such as cost per environment and cost per supported team allow teams of different size to be compared. Allocated cost is an estimate, and the method and its known errors are written down.

Waste has two forms: capacity that is requested and not used, and environments that nobody uses. It is measured in a stated unit, because the largest waste in cores and the largest waste in money can belong to different teams. Idle cost and waste cost overlap, so they are not added. Rightsizing, a default time to live and a staged removal process reduce waste without harming owners.

Reports separate outputs from outcomes, give each audience the numbers it needs and state a baseline, a period and a method with every figure. A claim of savings or value is limited to what the evidence shows.

Key facts:

- Utilization = used / requested x 100.
- Waste cost = monthly cost x (requested - used) / requested.
- Cost per environment = monthly cost / environments.
- Idle cost and waste cost overlap.

<!-- astrona:playground:destroy -->
