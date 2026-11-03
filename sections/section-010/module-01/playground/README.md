# Task Outcomes And Denominators - Playground

- **ID:** PLAYGROUND
- **Slug:** ats-082-playground-010-01
- **Author:** Paris Nakita Kejser
- **Type:** Astrona playground - clean environment, no task, no grading
- **Status:** built untested (never booted by the author)

A single-node kind cluster (Kubernetes 1.35, `kindest/node:v1.35.8`) with namespace metrics with the ConfigMap provisioning-requests (20 environment requests, 12 completed, 5 failed, 3 abandoned, two classes). No report exists. Nothing to submit.

## Run it

```sh
astrona run -c .
astrona destroy ats-082-playground-010-01
```

`astrona destroy` takes the environment name (`metadata.name`), not the config path.

## Layout

| Path | Purpose |
| --- | --- |
| `config.yaml` | Environment definition (runtime and starting manifests) |
| `manifests/data.yaml` | The namespace `metrics` and the source data ConfigMaps |
| `docs/overview.md` | What the environment contains and ideas to try |
