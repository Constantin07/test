#!/usr/bin/env bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <master|node>"
    exit 1
fi

TARGET=$1
NAMESPACE="${NAMESPACE:-default}"
JOB_NAME="kube-bench-${TARGET}"
TIMEOUT="60s"

# Run kube-bench on node/master
kubectl apply -n ${NAMESPACE} -f job-${TARGET}.yaml

# Wait for job completion
kubectl -n ${NAMESPACE} wait --for=condition=complete --timeout=${TIMEOUT} job/${JOB_NAME}

# Get the report
kubectl -n ${NAMESPACE} logs job/${JOB_NAME}

# Delete job
kubectl -n ${NAMESPACE} delete job/${JOB_NAME}
