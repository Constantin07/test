#!/usr/bin/env bash

# Label namespace with Pod Security Admissions

set -eu -o pipefail

# Must be a valid Kubernetes minor version
K8S_VERSION="v1.28"

# List of namespaces in scope for the 'baseline' Pod Security Standard
NAMESPACES_BASELINE=(
)

# https://v1-24.docs.kubernetes.io/docs/tasks/configure-pod-container/enforce-standards-namespace-labels/

for ns in "${NAMESPACES_BASELINE[@]}"; do
  echo -n "Namespace: $ns, "
  kubectl label --overwrite namespace "$ns" \
    pod-security.kubernetes.io/enforce=baseline \
    pod-security.kubernetes.io/enforce-version=$K8S_VERSION \
    pod-security.kubernetes.io/warn=restricted \
    pod-security.kubernetes.io/warn-version=$K8S_VERSION
done

# List of namespaces in scope for the 'privileged' Pod Security Standard
NAMESPACES_PRIVILEGED=(
  default
  system
)

for ns in "${NAMESPACES_PRIVILEGED[@]}"; do
  echo -n "Namespace: $ns, "
  kubectl label --overwrite namespace "$ns" \
    pod-security.kubernetes.io/enforce=privileged \
    pod-security.kubernetes.io/enforce-version=$K8S_VERSION \
    pod-security.kubernetes.io/warn=restricted \
    pod-security.kubernetes.io/warn-version=$K8S_VERSION
done
