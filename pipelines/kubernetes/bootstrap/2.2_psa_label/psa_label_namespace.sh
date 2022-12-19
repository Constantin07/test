#!/usr/bin/env bash

# Label namespace with Pod Security Admissions

set -eu

# List of namespaces in scope
NAMESPACES=(
  default
)

K8S_VERSION="v1.24"

# https://v1-24.docs.kubernetes.io/docs/tasks/configure-pod-container/enforce-standards-namespace-labels/

for ns in "${NAMESPACES[@]}"; do
  echo -n "Namespace: $ns, "
  kubectl label --overwrite namespace "$ns" \
    pod-security.kubernetes.io/enforce=baseline \
    pod-security.kubernetes.io/enforce-version=$K8S_VERSION \
    pod-security.kubernetes.io/warn=restricted \
    pod-security.kubernetes.io/warn-version=$K8S_VERSION
done
