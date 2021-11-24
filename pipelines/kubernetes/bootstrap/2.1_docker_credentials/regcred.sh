#!/usr/bin/env bash

# Creates docker-registry crednetials to allow K8s to pull images from private registries.

set -eu -o pipefail

: ${DOCKERHUB_USERNAME:?variable is not defined}
: ${DOCKERHUB_TOKEN:?variable is not defined}

DOCKERHUB_SERVER='https://index.docker.io/v1/'

# List of namespaces to add docker credentials to
NAMESPACES=(
  default
  calico-apiserver
)

for ns in "${NAMESPACES[@]}"; do
  echo -n "Namespace: $ns, "
  kubectl -n "$ns" create secret docker-registry dockerhub \
    --docker-server="${DOCKERHUB_SERVER}" \
    --docker-username="${DOCKERHUB_USERNAME}" \
    --docker-password="${DOCKERHUB_TOKEN}" --dry-run=client -o yaml | kubectl apply -f -
done
