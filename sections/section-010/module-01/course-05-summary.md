---
draft: true
exam_objectives:
  - Platform Efficiency and Team Productivity
---
# Summary

Platform efficiency describes whether shared capabilities help users finish a defined task. It is measured by outcomes: an environment became usable, a deployment reached production, an owner was found. Activity counts such as submitted requests or commits describe that something happened. They also rise when work is wasted, so they cannot stand in for efficiency.

A measure needs a task, a population and a denominator. The population is every attempt to do the task, and the denominator is the number of attempts. Each attempt ends in exactly one result, so the groups add up to the total. A completion rate divides completed attempts by all attempts. A rate built from successes only describes part of the experience and cannot be checked.

Time is the second half of the report. A mean is pulled by a few extreme values, so a report states the median and a high percentile, names the method and gives the number of values. Failed and abandoned attempts have waits of their own and are never mixed into the time to complete. Leaving them out is survivorship bias: the worst experiences vanish from the figure.

A breakdown by class or service shows where users meet friction. Every breakdown has fewer values, so the count must stay visible and a small group is a reason to collect more data.

A request spends its time working and waiting. Flow efficiency is the work time divided by the total time, and in manual processes most of the time is waiting, so removing a queue often saves more than speeding up a step. Work in progress, throughput and time in the system are linked, and limiting work in progress shortens the time.

Failed and abandoned requests are different outcomes. A failure is a platform error and ends quickly. Abandonment is a user decision after a long wait. Together they can use more user time than the requests that completed, and they usually concentrate in one class, which shows where to work first.

Key facts:

- The completion rate has all attempts in the denominator.
- The median is the 50th percentile and p90 is the time that 90 percent of requests meet.
- The nearest-rank percentile is the value at position `ceil(p x n)` of the sorted values.
- A time-to-complete figure and a completion rate belong in the same report.
- Flow efficiency = work time / total time x 100.
- Failed and abandoned requests are reported separately, with their time and class.

<!-- astrona:playground:destroy -->
