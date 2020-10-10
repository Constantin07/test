#!/usr/bin/env bash

oneTimeSetUp() {
  assertNotNull "Required environment variable KUBECONFIG is not set" "${KUBECONFIG}"
  APISERVER=`kubectl config view --minify | grep server | cut -f 2- -d ":" | tr -d " "`
  nodes=`kubectl get nodes -o=jsonpath='{.items[*].metadata.name}'`
}

test_ApiServerEndpointHealthCheck() {
  cluster_conn=`curl -ksSL ${APISERVER}/healthz`
  assertEquals "Cluster API health returned non-ok state" 'ok' "${cluster_conn}"
}

test_NodeReadinessCheck() {
  for node in $nodes; do
    node_status=`kubectl get node ${node} -o=jsonpath='{.status.conditions[?(@.type=="Ready")].status}'`
    assertEquals "Node ${node} is not in Ready state" 'True' "${node_status}"
  done
}

test_NodeNetworkUnavailableCheck() {
  for node in $nodes; do
    node_status=`kubectl get node ${node} -o=jsonpath='{.status.conditions[?(@.type=="NetworkUnavailable")].status}'`
    assertEquals "Node ${node} is in NetworkUnavailable state" 'False' "${node_status}"
  done
}

test_NodeMemoryPressureCheck() {
  for node in $nodes; do
    node_status=`kubectl get node ${node} -o=jsonpath='{.status.conditions[?(@.type=="MemoryPressure")].status}'`
    assertEquals "Node ${node} is in MemoryPressure state" 'False' "${node_status}"
  done
}

test_NodeDiskPressureCheck() {
  for node in $nodes; do
    node_status=`kubectl get node ${node} -o=jsonpath='{.status.conditions[?(@.type=="DiskPressure")].status}'`
    assertEquals "Node ${node} is in DiskPressure state" 'False' "${node_status}"
  done
}

test_NodePIDPressureCheck() {
  for node in $nodes; do
    node_status=`kubectl get node ${node} -o=jsonpath='{.status.conditions[?(@.type=="PIDPressure")].status}'`
    assertEquals "Node ${node} is in PIDPressure state" 'False' "${node_status}"
  done
}

# Load shUnit2
. /usr/local/bin/shunit2
