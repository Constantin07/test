#!/usr/bin/env bash

trap "kill 0" ERR INT TERM

oneTimeSetUp() {
  assertNotNull "Required environment variable KUBECONFIG is not set" "${KUBECONFIG}"
  assertNotNull "Required environment variable NAMESPACE is not set" "${NAMESPACE}"
  echo "Wait for kube-state-metrics to be up and running"
  kubectl -n "${NAMESPACE}" rollout status deploy/kube-state-metrics --timeout=120s --watch=true
  echo "Connect to kube-state-metrics"
  kubectl port-forward -n "${NAMESPACE}" svc/kube-state-metrics 9100:8080 &>/dev/null &
  export PID=$!
}

oneTimeTearDown() {
  ps -p $PID > /dev/null && kill $PID
  return 0
}

test_KubeStateMetricsIsWorking() {
  sleep 4
  result=`curl -sSf http://127.0.0.1:9100`
  assertContains "kube-state-metrics metrics" "${result}" 'metrics'
}

# Load shUnit2
. /usr/local/bin/shunit2
