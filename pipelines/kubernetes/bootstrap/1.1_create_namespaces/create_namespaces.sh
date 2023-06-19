#!/usr/bin/env bash

set -e -o pipefail

kubectl create ns system -o yaml --dry-run=client | kubectl apply -f -
kubectl label ns system name=system --overwrite=true

kubectl apply -f namespaces.yaml
