#!/usr/bin/env bash

set -eu

NAMESPACE="${NAMESPACE:-kube-system}"
TIMEOUT="360s"

echo "Wait for calico-node to be deployed"
kubectl -n "${NAMESPACE}" rollout status "ds/calico-node" --watch=true --timeout=${TIMEOUT}

echo "Wait for calico-kube-controllers to be deployed"
kubectl -n "${NAMESPACE}" rollout status "deployment/calico-kube-controllers" --watch=true --timeout=${TIMEOUT}
