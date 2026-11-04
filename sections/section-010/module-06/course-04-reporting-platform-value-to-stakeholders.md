---
draft: true
exam_objectives:
  - Platform Efficiency and Team Productivity
---
# Reporting Platform Value To Stakeholders

A platform team that measures well but reports badly still loses its budget. Different readers need different numbers, and some numbers look good but tell nothing. This part shows how to choose measures for each audience and how to avoid vanity figures.

## Outputs and outcomes

An **output** is something the platform team produces: the number of templates, the number of environments created, the number of features released. An **outcome** is a change in the result for the users: the time to first deployment fell, the change lead time fell, the tickets for environment requests fell. A **vanity metric** looks impressive but does not support a decision, such as the total number of environments ever created.

Outputs show effort, and outcomes show value. A report that has only outputs invites the question "so what?". The platform team pairs each output with the outcome it was meant to improve.

## Audiences

Three audiences ask different questions:

- **Developers and team leads** ask whether the platform makes their work easier. They need adoption, onboarding time, build waits and satisfaction.
- **Engineering leaders** ask whether delivery gets faster and safer. They need the delivery metrics, the reliability of the platform services and the cost trend.
- **Finance and executives** ask whether the money is well spent. They need the cost per team, the waste and its trend, and a comparison with a baseline.

One dashboard cannot serve all three. The platform team builds a short view for each audience and uses the same definitions in all of them.

## Baseline and comparison

A number needs something to compare with. A **baseline** is the value before a change, measured with the same method. Without it, a report cannot say if anything improved. The team records the baseline before it starts a project, and it states the period and the data source.

Suppose the platform team removes the idle environments in the playground data. The idle cost of 950 dollars per month is a saving of 11400 dollars over a year, if the idle environments stay removed and nothing else changes. The saving alone does not prove the platform pays for itself, because a team without a platform could remove its own idle environments, and the platform has other benefits and costs. The honest sentence is: "removing idle environments saved 950 dollars per month against a stated baseline".

<!-- astrona:playground:renew -->

Save the data:

```sh
kubectl -n metrics get configmap team-resources -o json | jq -r '.data["teams.json"]' > teams.json
```

Compute the idle cost and its share of the total spend:

```sh
jq '{idle_cost: (map(.monthly_cost / .environments * .idle_environments) | add), total_cost: (map(.monthly_cost) | add)}' teams.json
```

The output has `idle_cost` 950 and `total_cost` 4500. Idle environments are about 21 percent of the spend (950 over 4500). That share is a clear, checkable statement. It is easier to defend than a claim such as "the platform saves millions".

## Honest value statements

A good statement has a number, a period, a baseline and a method. It names what is not known. For example: "In October the idle environment cost was 950 dollars, 21 percent of team spend. The cost is estimated from the number of environments, not from per-environment billing." A reader can test this and can see its limit.

A value statement avoids claiming a cause it cannot show. If the cost fell after the platform launched a new feature, other changes may have caused the fall. The platform team says which part it can attribute and which part it cannot.

## Keeping the report useful

The report is short, uses the same definitions each time and shows a trend instead of a single month. It names an owner for each number and the decision the number supports. A metric that nobody uses to decide anything is removed, in the same way as in a balanced metric set.

## What you know now

A platform team reports outcomes with outputs as support, builds a view for each audience and states a baseline, a period and a method with every number. Idle cost and unit costs give figures that can be checked, and claims of cause are limited to what the evidence shows.

## Common pitfalls

> [!WARNING]
> Do not report outputs without outcomes. Do not claim savings without a baseline. Do not use one dashboard for every audience.
