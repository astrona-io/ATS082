# Prerequisites

- The `astrona` command-line tool, installed and working (`astrona check` passes).
- A container engine that kind can use (Podman or Docker) with about 2 GiB of free memory.
- `kubectl` and `jq`.
- You can read JSON with `jq` (`select`, `length`, `sort`, `add`) and you can create a ConfigMap from a YAML file.

The lab starts a single-node kind cluster (Kubernetes 1.35). It runs no workloads: the data to analyse is stored in ConfigMaps.
