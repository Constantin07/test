#!/usr/bin/env bash

oneTimeSetUp() {
  assertNotNull "Required environment variable KUBECONFIG is not set" "${KUBECONFIG}"
  NAMESPACE='default'
  SERVICE_ACCOUNT='vault-auth'
  SECRET_NAME='vault-auth-token'
  sa=`kubectl -n ${NAMESPACE} get sa/${SERVICE_ACCOUNT} -o json`
  SECRET=`kubectl -n ${NAMESPACE} get secret/${SECRET_NAME} -o json`
  cluster_role_binding=`kubectl get clusterrolebinding/${SERVICE_ACCOUNT} -o json`
}

test_VaultAuthSecretExists() {
  secret=`echo $SECRET | jq -r .metadata.name`
  assertEquals "Vault auth secret exists" "${secret}" 'vault-auth-token'
}

test_VaultServiceAccountExists() {
  sa=`echo ${sa} | jq -r .metadata.name`
  assertEquals "Vault service account exists" "${sa}" "${SERVICE_ACCOUNT}"
}

test_ClusterRoleBindingExists() {
  crb=`echo ${cluster_role_binding} | jq -r .metadata.name`
  assertEquals "ClusterRoleBinding exists" "${crb}" "${SERVICE_ACCOUNT}"
}

test_ClusterRoleBindingLinkedToServiceAccount() {
  crb_kind=`echo ${cluster_role_binding} | jq -r .subjects[0].kind`
  crb_name=`echo ${cluster_role_binding} | jq -r .subjects[0].name`
  crb_namespace=`echo ${cluster_role_binding} | jq -r .subjects[0].namespace`
  assertEquals "Subject kind is correct" "${crb_kind}" 'ServiceAccount'
  assertEquals "Subject name is correct" "${crb_name}" "${SERVICE_ACCOUNT}"
  assertEquals "Subject namespace is correct" "${crb_namespace}" "${NAMESPACE}"
}

# Load shUnit2
. /usr/local/bin/shunit2
