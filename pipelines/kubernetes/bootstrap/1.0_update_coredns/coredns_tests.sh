#!/usr/bin/env bash

oneTimeSetUp() {
  assertNotNull "Required environment variable KUBECONFIG is not set" "${KUBECONFIG}"
  kubectl apply -f ./busybox.yaml
  kubectl wait --for=condition=Ready pod/busybox
  # Wait for CoreDNS to be up and running
  kubectl -n kube-system rollout status deploy/coredns --timeout=120s --watch=true
}

test_CoreDnsCanResolveKubernetes() {
  local HOST='kubernetes.default.svc.cluster.local'
  result=`kubectl exec busybox -- nslookup -type=a ${HOST} | tail -n +2 | grep Address | awk '{print $2}'`
  kube_dns_ip=`kubectl -n default get svc kubernetes -o=jsonpath='{.spec.clusterIP}'`
  assertContains "CoreDNS can resolve ${HOST}" "${result}" "$kube_dns_ip"
}

test_CoreDnsCheckLocalDomainConfigured() {
  domain='internal'
  result=`kubectl exec busybox -- cat /etc/resolv.conf`
  assertContains "/etc/resolve.conf contains ${domain}" "${result}" 'internal'
}

test_CoreDnsCanResolveInternal() {
  local HOST='centos7.internal'
  result=`kubectl exec busybox -- nslookup -type=a ${HOST} | tail -n +2 | grep Address | awk '{print $2}'`
  assertContains "CoreDNS can resolve ${HOST}" "${result}" '10.0.2.4'
}

test_CoreDnsCanResolveVault() {
  local HOST='vault.internal'
  result=`kubectl exec busybox -- nslookup -type=a ${HOST} | tail -n +2 | grep Address | awk '{print $2}'`
  assertContains "CoreDNS can resolve ${HOST}" "${result}" '10.0.2.26'
}

test_CoreDnsPodsAreRunning() {
  result=`kubectl get pods --namespace=kube-system -l k8s-app=kube-dns | grep Running | wc -l`
  assertEquals "At least 2 CoreDNS pods are running" '2' "$result"
}

#test_CoreDnsPodsNoErrorsInLogs() {
#  for pod in `kubectl get pods --namespace=kube-system -l k8s-app=kube-dns -o name`; do
#    logs=`kubectl logs --namespace=kube-system $pod`
#    assertNotContains "No errors in pod logs" "$logs" 'ERROR'
#  done
#}

oneTimeTearDown() {
  kubectl delete --ignore-not-found=true -f ./busybox.yaml
}

# Load shUnit2
. /usr/local/bin/shunit2
