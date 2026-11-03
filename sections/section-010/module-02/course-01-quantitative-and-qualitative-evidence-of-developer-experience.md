---
draft: true
exam_objectives:
  - Platform Efficiency and Team Productivity
---
# Quantitative And Qualitative Evidence Of Developer Experience

A platform team wants to know whether a change made life easier for the developers who use the platform. Developer experience is how a developer perceives and performs the work of building and running software with the tools the platform provides. No single number captures it. This part describes the kinds of evidence a team can collect, what each kind shows and misses, and how to read a support ticket count next to the data it depends on.

## Developer productivity has several dimensions

Developer productivity is the effect of developers' work on the products and on the people who build them. It is wider than the amount of code a person writes. A developer who deletes unneeded code, reviews the work of another team or removes a source of waiting can improve the system while writing very little new code of their own.

The SPACE framework, a model from published research on developer productivity, describes five dimensions. **Satisfaction and well-being** is how developers feel about their work and tools. **Performance** is the outcome of the work, such as quality and the effect on users. **Activity** is the count of actions, such as commits or deployments. **Communication and collaboration** is how people and teams work together and find information. **Efficiency and flow** is the ability to finish work with few interruptions and little waiting.

The practical rule from the framework is to use measures from several dimensions together. Activity is one dimension and is the easiest to count. A platform that removes waiting for environments improves efficiency and flow, and it may leave the number of commits unchanged. A report that only shows commits would then report no benefit.

## Quantitative evidence

**Quantitative evidence** is evidence you can count or time: completion rates, durations, ticket counts, adoption numbers and deployment counts. It scales to every user, it can be repeated, and it shows trends. It does not explain why a number moved. A count says that 30 tickets were opened. It does not say what the users wanted or whether they gave up instead.

A raw count also depends on how much the capability is used. Compare 40 tickets in a month where 200 sessions started with 40 tickets in a month where 2000 sessions started. The first is a much heavier burden per session. A rate such as tickets per 100 sessions started makes months with different usage comparable.

## Qualitative evidence

**Qualitative evidence** is what users say or what an observer sees: interview notes, free-text survey answers, support conversations and observed use of a task. It explains the cause of friction, such as a confusing form field or an error message that does not name the wrong value. It is harder to scale and it depends on who answered. A survey with few answers may not represent all users, and users who already left the platform do not answer it.

The best use of the two kinds is as a pair. Quantitative evidence finds where the problem is and how large it is. Qualitative evidence finds why. A team that only counts can fix the wrong thing, and a team that only listens can fix the problem of the loudest user.

## Reading the example data

<!-- astrona:playground:renew -->

The playground holds data for a portal that developers use to request environments. The ConfigMap `portal-usage` has one record per month. Save it to a local file:

```sh
kubectl -n metrics get configmap portal-usage -o json | jq -r '.data["usage.json"]' > usage.json
```

Compute tickets per 100 sessions and the completion rate for each month. `jq -c` prints one compact object per line:

```sh
jq -c '.[] | {month, tickets, tickets_per_100_sessions: (.tickets * 100 / .sessions_started), completion_rate_percent: (.tasks_completed * 100 / .sessions_started)}' usage.json
```

The four lines show tickets per 100 sessions of 20, 20, 15 and 12, and completion rates of 80, 80, 60 and 50 percent for 2026-08 to 2026-11. Tickets per session fell, and so did the share of sessions that finished a task. The two numbers move in the same direction, which is a warning. A fall in tickets can mean that fewer problems occur. It can also mean that users give up and do not ask for help.

Neither reading can be confirmed from the counts. A team needs a third source of evidence to decide, and here the survey provides it.

## Coding free-text answers into themes

The ConfigMap `survey-responses` has 12 answers. Each has a `score` from 1 to 5, a free-text `comment` and a `theme`, a short label that a person assigned after reading the comment. Assigning themes to comments is called **coding**. It turns text into a form that can be counted, and it keeps the comment next to the label so that another person can check the label.

```sh
kubectl -n metrics get configmap survey-responses -o json | jq -r '.data["survey.json"]' > survey.json
jq -c 'group_by(.theme) | map({theme: .[0].theme, answers: length, average_score: ((map(.score) | add) / length)}) | sort_by(-.answers)' survey.json
```

The first command saves the data and the second counts the answers for each theme. The theme `unclear-error` has 5 answers with an average score of 1.8, `confusing-field` has 4 with 2.75 and `workaround` has 3 with about 2.67. The most frequent theme is also the lowest scored one.

Read the comments of the theme `workaround`:

```sh
jq -r '[.[] | select(.theme == "workaround") | .comment] | unique[]' survey.json
```

The only comment text is "I create the environment with a script and skip the portal." That is evidence that some users do the task outside the platform. Those users do not appear in the portal's session count, and they do not open tickets.

## Combining the evidence

Put the three observations in one sentence. Tickets per session fell, the completion rate fell by 30 points over the four months, and the survey shows unclear error messages and users who bypass the portal. The combined reading is that users hit problems they cannot solve and some leave the portal. A team that read the ticket count alone would call the change a success.

State the limits too. The survey has 12 answers, and the counts do not say which users are missing from it. The data does not yet say why the completion rate fell. The next part covers that question.

## Matching the evidence to the question

Each question about a platform change needs the kind of evidence that can answer it. The table lists common questions and the evidence that fits them. It is a reference list, so it stays short.

| Question | Evidence that fits |
| --- | --- |
| Do users finish the task? | Completion rate with all attempts in the denominator |
| How long do they wait? | Median and a high percentile of the time to complete |
| Is the burden of support falling? | Tickets per 100 sessions, read with the completion rate |
| Why do users fail? | Coded survey comments, interviews and observed sessions |
| Do users avoid the platform? | Adoption numbers and comments about workarounds |

## Who is missing from the data

Every data source has users who are absent from it. A usage count has no record of users who never opened the portal. A ticket count has no record of users who gave up. A survey has no answers from users who stopped using the platform, and people who answer surveys can differ from people who do not. This is called **response bias**: the answers come from a group that is not the whole population.

A team cannot remove this bias, but it can name it. A good report says who the evidence covers, for example "12 survey answers from teams that used the portal in October", and does not write "developers say". It also looks for a source that covers the missing group, such as a count of environments created by scripts that bypass the portal.

## What you know now

Developer experience has several dimensions, and a count of activity covers only one of them. Quantitative evidence is counted and shows size and trend. Qualitative evidence explains the cause. A raw count needs a denominator, and a ticket count must be read next to completion and abandonment. The open question is what made the numbers move, and how a team avoids rewarding the wrong behaviour with the measure.

## Common pitfalls

> [!WARNING]
> Do not read a fall in support tickets as a gain without checking completion and abandonment. Do not treat a survey with few answers as a measure of all users. Do not use one dimension of productivity, such as activity, as a score.
