#!/usr/bin/env bash

set -e -o pipefail

echo "Create namespaces"
kubectl create ns system -o yaml --dry-run=client | kubectl apply -f -
kubectl label ns system name=system --overwrite=true

# Declarative way
kubectl apply -f namespaces.yaml
