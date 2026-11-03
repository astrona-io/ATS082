#!/usr/bin/env bash
# Starting state: namespace delivery with the ConfigMap deployment-history. Environment only: it does not create the report the learner must write.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

kubectl apply -f "$DIR/manifests/lab-start.yaml"
echo "[lab] Ready."
