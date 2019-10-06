#!/usr/bin/env bash

oneTimeSetUp() {
  assertNotNull "Required environment variable KUBECONFIG is not set" "${KUBECONFIG}"
  APISERVER=`kubectl config view --minify | grep server | cut -f 2- -d ":" | tr -d " "`
  # Disable as being depecated
  #status=`kubectl get componentstatuses`
}

test_ApiServerEndpointHealthCheck() {
  cluster_conn=`curl -ksSL ${APISERVER}/healthz`
  assertEquals "Cluster API health returned non-ok state" 'ok' "${cluster_conn}"
}

#test_ControllerManagerStatus() {
#  cm_status=`echo "${status}" | grep controller-manager | awk '{print $2}'`
#  assertEquals "Controller Manager is not in Healthy state" 'Healthy' "${cm_status}"
#}

#test_SchedulerStatus() {
#  s_status=`echo "${status}" | grep scheduler | awk '{print $2}'`
#  assertEquals "Scheduler is not in Healthy state" 'Healthy' "${s_status}"
#}

#test_EtcdStatus() {
#  e_status=`echo "${status}" | grep etcd | awk '{print $2}'`
#  assertEquals "Etcd is not in Healthy state" 'Healthy' "${e_status}"
#}

# Load shUnit2
. /usr/local/bin/shunit2
