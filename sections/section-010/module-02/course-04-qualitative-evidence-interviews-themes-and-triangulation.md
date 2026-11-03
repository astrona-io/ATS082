---
draft: true
exam_objectives:
  - Platform Efficiency and Team Productivity
---
# Qualitative Evidence: Interviews, Themes And Triangulation

Numbers say what happened. They do not say why. A platform team needs the reasons behind the numbers, and these come from the words of users: comments, interviews and observation of work. This part shows how to turn comments into themes, how to count them without misusing the counts and how to combine them with the numbers.

## Qualitative evidence

**Qualitative evidence** is evidence in words and observations. It comes from open survey comments, interviews, observation of a developer using the platform and support conversations. It is rich and it answers "why". It is hard to generalise, because each source reaches few people.

## From comments to themes

A **theme** is a short label for a group of comments that describe the same problem. To build themes, the team reads all comments, groups similar ones and names each group. The data in this module has a `theme` for each of 12 comments.

<!-- astrona:playground:renew -->

Save the survey from the ConfigMap if you do not have the file:

```sh
kubectl -n metrics get configmap survey-responses -o json | jq -r '.data["survey.json"]' > survey.json
```

Count the answers in each theme and compute the average score of each:

```sh
jq -c 'group_by(.theme) | map({theme: .[0].theme, n: length, avg: (([.[].score] | add) / length)}) | sort_by(-.n)' survey.json
```

The output is `[{"theme":"unclear-error","n":5,"avg":1.8},{"theme":"confusing-field","n":4,"avg":2.75},{"theme":"workaround","n":3,"avg":2.6666666666666665}]`. The theme `unclear-error` has the most comments and the lowest average score. The theme `workaround` has 3 comments: users say that they skip the portal and create the environment with a script.

Read the comments of the largest theme once:

```sh
jq -r '[.[] | select(.theme == "unclear-error") | .comment] | unique | .[]' survey.json
```

The output is the single sentence "The error message does not say which field is wrong." All five users report the same defect. A repeated comment is stronger evidence for a cause than a number alone.

## Counting themes with care

A theme count shows how often a topic came up in the answers. It does not show how many users in total have the problem, because the survey reached only some of them. Five of twelve answers is 42 percent of the answers and not 42 percent of the users. A single comment can also describe a serious problem, such as a security risk, and a team should not ignore it because it appeared once.

## Interviews

An interview with five to eight users, held in a structured way, finds problems that surveys miss. The interviewer asks the user to show the last time they did the task, and asks open questions such as "What happened next?" and "What did you expect?". The interviewer does not defend the platform. Notes are shared with the team and grouped into themes in the same way as survey comments.

## Triangulation

**Triangulation** means checking one conclusion against several independent sources. A claim becomes stronger when different kinds of evidence agree. The usage data shows the completion rate by month:

```sh
kubectl -n metrics get configmap portal-usage -o json | jq -c '.data["usage.json"] | fromjson | .[] | {month, completion_percent: (.tasks_completed * 100 / .sessions_started)}'
```

The output has four lines. The completion rate is 80 percent in 2026-08 and 2026-09, 60 percent in 2026-10 and 50 percent in 2026-11. The numbers show a drop in October. The comments show unclear errors, confusing fields and workarounds. Together they support a story: users hit errors, cannot tell what to fix and leave the portal. They do not prove that the redesign caused the drop. The team would need the dates of the changes, a look at the error logs and interviews to rule out other causes such as the reduction of the environment quota.

## What you know now

Qualitative evidence explains the numbers. Themes group comments, counts show how often a topic appeared in the answers, interviews give depth and triangulation combines sources to make a conclusion stronger. Evidence from several sources can support a story, but a cause needs more than agreement of sources.

## Common pitfalls

> [!WARNING]
> Do not turn the share of comments into the share of users. Do not ignore a serious problem because only one person reported it. Do not treat agreement between sources as proof of a cause.
