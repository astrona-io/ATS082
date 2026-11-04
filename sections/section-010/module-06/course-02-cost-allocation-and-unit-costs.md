---
draft: true
exam_objectives:
  - Platform Efficiency and Team Productivity
---
# Cost Allocation And Unit Costs

A bill for a cluster shows one large number. Teams change their behaviour only when they see the part that belongs to them. This part explains how cost reaches the teams that cause it and which unit costs a platform team can compute from the data.

## Showback and chargeback

**Showback** means the platform team reports to each team what its resources cost, without charging it. **Chargeback** means the cost is moved to the team's budget. Showback is the first step: it makes cost visible and starts the discussion. Chargeback adds pressure and needs a trusted allocation method, or teams will dispute the bill.

Allocation needs a way to say which pod belongs to which team. In Kubernetes the usual keys are the namespace and labels such as `team` or `cost-center` on pods and namespaces. A rule that every namespace has a team label, enforced by an admission policy, makes the data reliable. Cost that has no label cannot be allocated and goes to an unallocated group, whose size is itself a metric of data quality.

## Direct and shared cost

**Direct cost** is cost that a team caused: the nodes its pods use, its storage and its load balancers. **Shared cost** is cost that nobody owns alone: the control plane, monitoring, the platform team's own tools and the people who run them. A method must decide how to split shared cost. Common choices are an equal split between teams, a split in proportion to each team's direct cost, or a split in proportion to resource requests. The platform team writes the method down, because each choice moves cost between teams.

## Unit costs

A unit cost divides a cost by a count of something that matters, so that teams of different size can be compared. Three unit costs are common for a platform:

- **Cost per environment:** the monthly cost of a team divided by its number of environments.
- **Cost per team:** the monthly cost of the platform divided by the teams it supports.
- **Cost per deployment or per request:** a cost divided by the work that was done.

<!-- astrona:playground:renew -->

Save the data:

```sh
kubectl -n metrics get configmap team-resources -o json | jq -r '.data["teams.json"]' > teams.json
kubectl -n metrics get configmap platform-cost -o json | jq -r '.data["cost.json"]' > cost.json
```

Compute the cost per environment:

```sh
jq -c '.[] | {team, monthly_cost, environments, cost_per_environment: (.monthly_cost / .environments)}' teams.json
```

The cost per environment is 200 dollars for `bridge` (1600 over 8), 225 for `scout`, 250 for `shuttle` and 250 for `probe`. The team with the largest total cost, `bridge`, has the cheapest environments. A ranking by total cost would put `bridge` first, but a ranking by cost per environment puts it last.

Now compute the cost of the platform for each team it supports:

```sh
jq '.platform_monthly_cost / .teams_supported' cost.json
```

The output is `3000`. The platform costs 12000 dollars per month and supports 4 teams. This number answers a question the leaders ask: what does it cost to serve one team? It does not say whether the platform is worth it. That needs a comparison with value, which the last part of this module discusses.

## Unit cost trends

A unit cost is most useful over time. If the platform cost per team falls as more teams join, the platform scales well. If it grows, each new team adds more work than it brings in efficiency. A single month shows little. The platform team records the same unit costs each month and looks at the direction.

## Limits of allocated cost

Allocated cost is an estimate. Two teams can share a node, and a split by requests ignores that one team's pods are busier. A cloud bill arrives with delay, and discounts such as reserved capacity are applied to the whole account, not to a team. A team that disputes a figure is often right about a detail. The platform team keeps a written method and a list of known errors, and it fixes the data before it argues about the number.

## What you know now

Cost reaches teams through namespaces and labels. Showback makes cost visible and chargeback moves it to a budget. Direct cost is allocated by use, shared cost needs a written rule, and unit costs such as cost per environment and cost per team allow comparison. The open question is which part of the cost is waste.

## Common pitfalls

> [!WARNING]
> Do not compare teams by total cost only. Do not charge back before the allocation method is trusted. Do not treat allocated cost as exact.
