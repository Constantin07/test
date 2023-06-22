#!/usr/bin/env bash

set -eu -o pipefail

echo "Remove automount for default service account(s)."

NAMESPACES=(
  default
  system
  gatekeeper-system
)

SA="default"

for ns in "${NAMESPACES[@]}"; do
    echo -n "Namespace: $ns, "
    kubectl -n "$ns" patch serviceaccount "$SA" -p '{"automountServiceAccountToken": false}'
done
