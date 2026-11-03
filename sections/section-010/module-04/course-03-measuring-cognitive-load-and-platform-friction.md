---
draft: true
exam_objectives:
  - Platform Efficiency and Team Productivity
---
# Measuring Cognitive Load And Platform Friction

Cognitive load is the hardest of the three DevEx areas to measure because it happens in a person's head. A platform team still needs a way to tell whether the platform lowers the load or adds to it. This part shows indirect measures that can be taken from workflows and from surveys, and it reads a small data set that mixes both.

## What cognitive load is

**Cognitive load** is the amount of mental effort a person needs to finish a task. A developer who must learn a new tool, remember a long checklist and switch between five systems to ship a change carries a high load. Part of the load is needed to solve the real problem. The rest comes from the environment: unclear steps, many tools and rules that nobody explains. A platform removes the second part. It does not make the first part disappear.

## Indirect measures from workflows

Nobody can read cognitive load from a log. A team measures what causes it:

- **Steps in a workflow:** the number of steps a developer takes to do a common task, for example to create a service.
- **Tools per workflow:** the number of different tools involved.
- **Handoffs:** the number of times the task waits for another team.
- **Time to first deployment:** how long a new team needs to learn enough to ship.
- **Documentation search success:** how often a developer finds an answer in the documentation without asking a person.

Each is a proxy. Fewer steps and fewer tools usually mean lower load, but a proxy can be fooled. One long script that hides ten steps lowers the step count and may make failures harder to understand.

## Measures from surveys

A survey asks directly. A common question is "How much mental effort does it take to deploy a change?", answered on a scale from 1 (very little) to 5 (very much). A team asks the same question on a fixed schedule so that it can compare rounds. The same survey asks how often developers are interrupted, which shows flow. Survey answers are subjective, and that is the point: they show how the work feels.

<!-- astrona:playground:renew -->

The playground holds a second ConfigMap, `team-measurements`, with data from three teams. Save it:

```sh
kubectl -n metrics get configmap team-measurements -o json | jq -r '.data["teams.json"]' > teams.json
```

Look at three values that relate to friction and satisfaction:

```sh
jq -c '.[] | {team, satisfaction, build_wait_minutes, interruptions_per_day}' teams.json
```

The output has one line for each team. The team `bridge` has satisfaction 4.2, a build wait of 9 minutes and 2 interruptions per day. The team `scout` has satisfaction 2.6, a build wait of 31 minutes and 7 interruptions per day. The team `shuttle` has satisfaction 3.4, a build wait of 14 minutes and 4 interruptions per day.

The three teams are ordered the same way by satisfaction and by friction: the team with the longest build wait and the most interruptions is the least satisfied. Three teams do not prove that friction causes dissatisfaction. They show that the measures move together, which is a reason to study the team `scout` first.

## Finding the highest friction

Select the team with the lowest satisfaction and show its other measures:

```sh
jq -c '[.[] | select(.satisfaction < 3) | .team]' teams.json
```

The output is `["scout"]`. The next step is not another metric. It is a conversation with the team to find what the build wait and the interruptions consist of. A number says where the problem is, and the people who live with it say what it is.

## How a platform lowers cognitive load

A platform lowers the load with **golden paths**, which are supported, well-documented ways to do a common task, and with defaults that are right for most cases. A service template that includes a pipeline, logging and an alert replaces many decisions with one. A service catalogue answers who owns a service and where its documentation is, so that nobody has to ask around. A measure of success is that the number of steps and tools for a common task goes down and the survey answer about effort goes down with it.

A platform can also raise the load. A platform with many abstractions that need their own training, or a platform that leaks every detail of the layer below it, adds new things to learn. The platform team therefore asks the same survey question about the platform itself.

## What you know now

Cognitive load cannot be logged, so a team measures its causes (steps, tools, handoffs, time to first deployment) and asks about the effort in a recurring survey. Measures that move together point to the place to investigate, and interviews give the reason. The open question is how to assemble these measures into one set that stays honest, which is the last part.

## Common pitfalls

> [!WARNING]
> Do not claim that a proxy such as the step count is the cognitive load. Do not conclude a cause from three teams. Do not change the survey question between rounds and then compare the answers.
