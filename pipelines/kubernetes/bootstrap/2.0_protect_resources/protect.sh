#!/usr/bin/env bash

set -eu

kubectl set resources deploy/coredns -n ${NAMESPACE} --limits='cpu=100m,memory=170Mi' --requests='cpu=100m,memory=170Mi' || true
