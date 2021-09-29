#!/usr/bin/env bash

# Kill randomly pods in a K8s cluster

NAMESPACE=${NAMESPACE:-default}

while true; do
    echo "Choosing a pod to kill ..."
    PODS="$(kubectl -n ${NAMESPACE} get pods | grep -v NAME | awk '{print $1}')"
    POD_COUNT="$(kubectl -n ${NAMESPACE} get pods | grep -v NAME | wc -l)"

    K=$(( ( RANDOM % $POD_COUNT ) + 1 ))
    TARGET_POD="$(kubectl -n ${NAMESPACE} get pods | grep -v NAME | awk '{print $1}' | head -n ${K} | tail -n 1)"

    echo "Killing pod ${TARGET_POD}"
    kubectl delete pod "${TARGET_POD}" --wait=true

    sleep 30
done
