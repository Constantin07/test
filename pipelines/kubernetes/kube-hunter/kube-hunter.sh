#!/usr/bin/env bash

set -eu -o pipefail

NAMESPACE="${NAMESPACE:-system}"
JOB_NAME="kube-hunter"
TIMEOUT="120s"

function cleanup() {
    kubectl -n "${NAMESPACE}" delete job/${JOB_NAME} --ignore-not-found=true
}

trap cleanup ERR

echo "Run kube-hunter in '${NAMESPACE}' namespace."
kubectl create -n "${NAMESPACE}" -f job.yaml

echo "Waiting for job completion ..."
kubectl -n "${NAMESPACE}" wait --for=condition=complete --timeout=${TIMEOUT} job/${JOB_NAME}

echo "Getting report"
kubectl -n "${NAMESPACE}" logs job/${JOB_NAME}

cleanup
