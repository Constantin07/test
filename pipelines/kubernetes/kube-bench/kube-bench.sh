#!/usr/bin/env bash

set -e

TARGET="$1"
NAMESPACE="${NAMESPACE:-default}"
JOB_NAME="kube-bench-${TARGET}"
TIMEOUT="120s"

function usage() {
    echo "Usage: $0 <master|node>"
    exit 1
}

function cleanup() {
    kubectl -n "${NAMESPACE}" delete -f ./job-${TARGET}.yaml --ignore-not-found=true
    kubectl -n "${NAMESPACE}" delete -f ./kube-bench-${TARGET}-configmap.yaml --ignore-not-found=true
}

if [ $# -ne 1 ]; then
    echo "One argumet is required!"
    usage
elif ! [[ $1 =~ ^(master|node)$ ]]; then
    echo "Provided argument must match one of expected values."
    usage
fi

trap cleanup ERR

# Validate definition files
kubeconform -strict -summary ./kube-bench-${TARGET}-configmap.yaml
kubeconform -strict -summary ./job-${TARGET}.yaml

# Run kube-bench job on node/master
kubectl apply -n "${NAMESPACE}" -f ./kube-bench-${TARGET}-configmap.yaml
kubectl apply -n "${NAMESPACE}" -f ./job-${TARGET}.yaml

# Wait for job completion
kubectl -n "${NAMESPACE}" wait --for=condition=complete --timeout=${TIMEOUT} job/${JOB_NAME}

# Get the report
kubectl -n "${NAMESPACE}" logs job/${JOB_NAME}
