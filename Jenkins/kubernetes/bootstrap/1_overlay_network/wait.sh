#!/usr/bin/env bash

set -eu

NAMESPACE="${NAMESPACE:-kube-system}"
NAME="calico-node"
TIMEOUT="120s"

# Wait for Calico to be deployed
kubectl -n "${NAMESPACE}" rollout status "ds/${NAME}" --watch=true --timeout=${TIMEOUT}
