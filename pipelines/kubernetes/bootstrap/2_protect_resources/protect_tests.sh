#!/usr/bin/env bash

oneTimeSetUp() {
  assertNotNull "Required environment variable KUBECONFIG is not set" "${KUBECONFIG}"
  coredns_resources=`kubectl -n kube-system get deploy/coredns -o json | jq -r .spec.template.spec.containers[0].resources`
}

test_CoreDnsResourceProtectionSet() {
  limits_cpu=`echo ${coredns_resources} | jq -r .limits.cpu`
  limits_memory=`echo ${coredns_resources} | jq -r .limits.memory`
  requests_cpu=`echo ${coredns_resources} | jq -r .requests.cpu`
  requests_memory=`echo ${coredns_resources} | jq -r .requests.memory`
  assertEquals "CPU limit is set" "${limits_cpu}" "100m"
  assertEquals "Memory limit is set" "${limits_memory}" "170Mi"
  assertEquals "CPU request is set" "${requests_cpu}" "100m"
  assertEquals "Memory request is set" "${requests_memory}" "170Mi"
}

# Load shUnit2
. /usr/local/bin/shunit2
