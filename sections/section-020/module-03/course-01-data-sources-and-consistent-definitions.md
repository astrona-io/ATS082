---
draft: true
exam_objectives:
  - DORA Metrics for Platform Initiatives
---
# Data Sources And Consistent Definitions

DORA metrics are only as good as the data under them. A platform team that wants the numbers for many services needs the same events from every service, collected in the same way. This part lists the data sources, describes the record that a platform should keep for each deployment, and reads a data set of deployments.

## Where the data comes from

Five metrics need data from four kinds of system:

- **Version control** gives the time of the commit or merge that starts the change, which is the start of the change lead time.
- **The continuous integration and delivery (CI/CD) pipeline** gives the time a change reached production and which change it was, which gives the deployment frequency and the end of the lead time.
- **Incident or alerting tools** give the time a failure was detected and the time service was restored, which gives the failed deployment recovery time.
- **Change records and tickets** link a failure or an unplanned fix to the deployment that caused it, which gives the change fail rate and the deployment rework rate.

A platform helps here because every service that deploys through the platform pipeline produces the same events. A deployment record that the pipeline writes is more reliable than a spreadsheet that people fill in by hand.

## A deployment record

The example data has one record per deployment of the service `probe-api`. A record has `id`, `quarter`, `lead_time_hours`, `failed`, `recovery_minutes` and `rework`. A real record has more fields, such as the commit identifier, the environment and the timestamps from which the lead time is computed. The record must use the same meaning of each field for every service.

<!-- astrona:playground:renew -->

Save the data from the ConfigMap:

```sh
kubectl -n delivery get configmap deployment-history -o json | jq -r '.data["deployments.json"]' > deployments.json
```

Look at the first record:

```sh
jq -c '.[0]' deployments.json
```

The output is `{"id":"p01","quarter":"Q1","lead_time_hours":48,"failed":false,"recovery_minutes":null,"rework":true}`. The deployment did not fail, so `recovery_minutes` is `null`. It is still marked as rework, which means that an unplanned deployment followed it to fix something that was not a failure of the deployment itself. The two flags are separate facts.

Count the records and the quarters:

```sh
jq 'length' deployments.json
jq -c 'group_by(.quarter) | map({quarter: .[0].quarter, deployments: length})' deployments.json
```

The output is `24` and `[{"quarter":"Q1","deployments":6},{"quarter":"Q2","deployments":8},{"quarter":"Q3","deployments":10}]`.

## Consistent definitions

The numbers can only be compared when the definitions do not change. The platform team writes down, and enforces in the pipeline:

- **What counts as a deployment:** a change that reaches production and is available to users. A deployment to a test environment is not counted.
- **What counts as a failure:** a deployment that needs intervention, for example a rollback, a hotfix or a patch, because it degraded the service.
- **When recovery starts and ends:** it starts at the deployment that failed and ends when the service is restored to normal operation.
- **What belongs to one service:** the unit of reporting, for example one deployable application.

If one team counts a failed deployment only after a customer complaint and another counts it after an alert, the numbers cannot be compared. A mismatch of this kind is a common cause of arguments about the numbers.

Check the failed deployments and their recovery times:

```sh
jq -c '[.[] | select(.failed) | {id, quarter, recovery_minutes}]' deployments.json
```

The output has five records: `p02` and `p04` in Q1 with 180 and 240 minutes, `p09` in Q2 with 90 minutes, and `p20` and `p23` in Q3 with 45 and 400 minutes. Only failed deployments have a recovery time. Any record that is not failed and has a recovery value would be a data error.

## Data quality checks

A platform team adds checks to the pipeline: every deployment has a commit and a timestamp, every failed deployment has a recovery end time, and no deployment is recorded twice. A weekly check that counts deployments with missing fields finds problems early. Without these checks, a metric can look like it improved only because records are missing.

## What you know now

The data for the five metrics comes from version control, the pipeline, incident tools and change records, and a platform that writes the same record for every service makes the data reliable. The definitions of deployment, failure and recovery must be written down and kept the same. The open question is how to read the numbers once there are several quarters of them.

## Common pitfalls

> [!WARNING]
> Do not let each team define a failed deployment in its own way. Do not count test environment deployments. Do not compare numbers from services whose records are built with different rules.
