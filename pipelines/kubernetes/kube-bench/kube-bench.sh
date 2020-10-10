#!/usr/bin/env bash

set -eu

if [ $# -ne 1 ]; then
    echo "Usage: $0 <master|node>"
    exit 1
fi

TARGET="$1"
NAMESPACE="${NAMESPACE:-default}"
JOB_NAME="kube-bench-${TARGET}"
TIMEOUT="120s"

function cleanup() {
    kubectl -n "${NAMESPACE}" delete -f ./job-${TARGET}.yaml --ignore-not-found=true
    kubectl -n "${NAMESPACE}" delete -f ./kube-bench-${TARGET}-configmap.yaml --ignore-not-found=true
}

trap cleanup ERR

# Validate definition files
kubeval --strict ./kube-bench-${TARGET}-configmap.yaml
kubeval --strict ./job-${TARGET}.yaml

# Run kube-bench job on node/master
kubectl apply -n "${NAMESPACE}" -f ./kube-bench-${TARGET}-configmap.yaml
kubectl apply -n "${NAMESPACE}" -f ./job-${TARGET}.yaml

# Wait for job completion
kubectl -n "${NAMESPACE}" wait --for=condition=complete --timeout=${TIMEOUT} job/${JOB_NAME}

# Get the report
kubectl -n "${NAMESPACE}" logs job/${JOB_NAME}

# Delete job
cleanup
