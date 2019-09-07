#!/usr/bin/env bash

oneTimeSetUp() {
  assertNotNull "Required environment variable KUBECONFIG is not set" "${KUBECONFIG}"
  status=`kubectl get componentstatuses`
}

test_ControllerManagerStatus() {
  cm_status=`echo "${status}" | grep controller-manager | awk '{print $2}'`
  assertEquals "Controller Manager is not in Healthy state" 'Healthy' "${cm_status}"
}

test_SchedulerStatus() {
  s_status=`echo "${status}" | grep scheduler | awk '{print $2}'`
  assertEquals "Scheduler is not in Healthy state" 'Healthy' "${s_status}"
}

test_EtcdStatus() {
  e_status=`echo "${status}" | grep etcd | awk '{print $2}'`
  assertEquals "Etcd is not in Healthy state" 'Healthy' "${e_status}"
}

# Load shUnit2
. /usr/local/bin/shunit2
