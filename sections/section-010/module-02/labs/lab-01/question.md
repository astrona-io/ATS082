# Question

Solve this question on: `terminal`

The platform team released a redesigned environment portal on 2026-10-01. A status report says: "Support tickets fell from 80 to 54 after the redesign, so the redesign worked." Check that claim with the evidence in the namespace `metrics`. All values are JSON stored in ConfigMaps. Do not edit them.

- `portal-usage`, key `usage.json`: one record per month with `month`, `sessions_started`, `tasks_completed` and `tickets`.
- `survey-responses`, key `survey.json`: one record per answer with `score`, `theme` and `comment`.
- `platform-changes`, key `changes.json`: the dated changes to the platform in the period.

"Before" is the months August and September 2026. "After" is October and November 2026.

Create a ConfigMap `experience-report` in the namespace `metrics` with these keys:

1. `tickets-before` and `tickets-after`: the total tickets of each period.
2. `completion-rate-before-percent` and `completion-rate-after-percent`: total tasks completed divided by total sessions started, times 100, for each period.
3. `top-survey-theme`: the theme that appears most often in the survey.
4. `confounders`: one sentence that names the other change in the same period that could explain the numbers.
5. `verdict`: `improved`, `worse` or `unclear`. Use `worse` when the completion rate fell, `improved` when it did not fall and the tickets fell, and `unclear` in other cases.

`kubectl` already points at the cluster as the cluster administrator. `jq` runs on your machine.
