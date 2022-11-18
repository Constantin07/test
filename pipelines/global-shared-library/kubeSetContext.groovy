#!groovy

// Set k8s configuration context

def call(String cluster = 'kubernetes', String user = 'kubernetes-admin', String namespace) {
  sh """
    set +x
    kubectl config set-context ${namespace} --namespace=${namespace} --cluster=${cluster} --user=${user}
    kubectl config use-context ${namespace}
  """
}
