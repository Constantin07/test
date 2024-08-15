#!/usr/bin/env bash

set -eu

kubectl set resources deploy/coredns -n ${NAMESPACE} --requests='cpu=100m,memory=170Mi' --limits='cpu=100m,memory=170Mi' || true
