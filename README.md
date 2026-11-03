# Measuring your Platform (ATS082)

Certified Cloud Native Platform Engineering Associate (CNPA) — Measuring your Platform, 8% of the published curriculum. This course is part of ATP016.

Concept lessons explain each official objective with worked calculations and scenario reasoning. Every module has a playground (a clean kind cluster with data to explore), a graded lab and a summary. Every section ends with a capstone lab and a knowledge check. A final knowledge check closes the course.

## Course Outline

| Section | Objective | Modules | Tools used in the labs |
| --- | --- | --- | --- |
| 010 | Platform Efficiency and Team Productivity | 4 + capstone | kubectl, jq (completion rate, percentiles, adoption, onboarding, survey and ticket evidence, SPACE and DevEx metric sets) |
| 020 | DORA Metrics for Platform Initiatives | 3 + capstone | kubectl, jq (five DORA metrics, quarterly trends, interpretation of claims) |

See [the curriculum map](CURRICULUM.md) for module outcomes. The manifest `astrona.yaml` registers readings, labs and quizzes in teaching order.

## Authoring Status

Readings are drafts for review. The playgrounds and labs are built untested: only static checks were run (`astrona validate -c`, `bash -n`, YAML parsing). Every lab README says UNTESTED. Technical sections and the ATP016 registration remain draft until the maintainer approves publication.

## Run A Lab

```sh
astrona run -c sections/section-010/module-01/labs/lab-01
astrona submit -c sections/section-010/module-01/labs/lab-01
astrona destroy ats-082-lab-010-01
```

Playgrounds are started the same way with `astrona run -c <playground dir>`.

## Sources And Contributions

Author references are recorded in [SOURCES.md](SOURCES.md) and contribution rules in [CONTRIBUTING.md](CONTRIBUTING.md). Report corrections through this repository's issues. The material uses the repository license.
