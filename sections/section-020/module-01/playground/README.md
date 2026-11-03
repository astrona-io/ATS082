# Delivery Metrics From Deployment Events - Playground

- **ID:** PLAYGROUND
- **Slug:** ats-082-playground-020-01
- **Author:** Paris Nakita Kejser
- **Type:** Astrona playground - clean environment, no task, no grading
- **Status:** built untested (never booted by the author)

A single-node kind cluster (Kubernetes 1.35, `kindest/node:v1.35.8`) with namespace delivery with the ConfigMap deployments (20 deployments of shuttle-api over 10 days). No report exists. Nothing to submit.

## Run it

```sh
astrona run -c .
astrona destroy ats-082-playground-020-01
```

`astrona destroy` takes the environment name (`metadata.name`), not the config path.

## Layout

| Path | Purpose |
| --- | --- |
| `config.yaml` | Environment definition (runtime and starting manifests) |
| `manifests/data.yaml` | The namespace `delivery` and the source data ConfigMaps |
| `docs/overview.md` | What the environment contains and ideas to try |
