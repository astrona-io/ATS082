# Curriculum Coverage

Exam: Certified Cloud Native Platform Engineering Associate (CNPA). Domain: Measuring your Platform (8%).

The [official objectives](https://training.linuxfoundation.org/certification/certified-cloud-native-platform-engineering-associate-cnpa/) were checked on 2026-10-11. Teaching structure is independently authored and does not add official requirements.

| Section | Official objective | Modules | Status |
| --- | --- | --- | --- |
| 010 | Platform Efficiency and Team Productivity | 4 + capstone | Built; labs untested |
| 020 | DORA Metrics for Platform Initiatives | 3 + capstone | Built; labs untested |

| Section / module | Module | Teaching lessons | Measurable outcomes |
| --- | --- | --- | --- |
| 010 / 01 | Task Outcomes, Flow And Developer Productivity Evidence | 4 | Distinguish platform efficiency from activity counts.; Compute a completion rate over all attempts.; Compute a median and a percentile over completed attempts and explain survivorship bias. |
| 010 / 02 | Developer Experience Evidence And Incentives | 4 | Combine quantitative and qualitative evidence of developer experience.; Explain why a measure used as a target is gamed.; State the limits of a before-and-after comparison and name a confounder. |
| 010 / 03 | Platform Adoption, Onboarding And Product Metrics | 4 | Compute an adoption rate over eligible teams and separate mandated from voluntary adoption.; Measure onboarding time and self-service with medians and percentiles.; Read CSAT and NPS with their response rates. |
| 010 / 04 | Developer Productivity Frameworks: SPACE, DevEx And Cognitive Load | 4 | Name the five SPACE dimensions and the three DevEx areas.; Explain why one metric is not enough.; Build a balanced metric set across dimensions and levels. |
| 020 / 01 | Delivery Metrics From Deployment Events | 4 | Define the five delivery metrics and their two groups.; Compute each metric from deployment events with a stated window, statistic and unit.; Compute recovery time over failed deployments only. |
| 020 / 02 | Interpreting DORA Metrics For Platform Initiatives | 4 | Explain the move from four keys to five metrics and the rename of MTTR.; Explain why metrics are reported per service.; Judge a platform claim against evidence and its causal limits. |
| 020 / 03 | Collecting And Improving DORA Metrics With A Platform | 4 | Name data sources and keep definitions consistent.; Read quarterly trends per metric.; Find the constraint and use the metrics without gaming. |

Every section begins with an introduction. Every module has a playground, a graded lab and a summary. Each section ends with a capstone lab and `quiz.yaml`; `sections/final-domain-quiz.yaml` closes the course.

AUTHORING.yaml records measurable goals. The labs and playgrounds are built untested: static checks only, no runtime execution is claimed. Technical content remains draft until review.
