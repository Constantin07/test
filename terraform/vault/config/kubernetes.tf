# Kubernetes

provider "kubernetes" {
  config_context_auth_info = "kubernetes-admin"
  config_context_cluster   = "kubernetes"
}

provider "external" {
}

# Get Kubernetes CA cert and cluster endpoint
data "external" "kube_config" {
  program = [".venv/bin/python3", "${path.module}/get_kubeconfig.py"]

  query = {
    config_file = var.kube_config_file
  }
}

# Get secret token name associated with vault-auth service account
data "external" "secret_name" {
  program = [".venv/bin/python3", "${path.module}/get_secret_name.py"]

  query = {
    namespace            = "default"
    service_account_name = "vault-auth"
  }
}

data "kubernetes_secret" "vault_auth" {
  metadata {
    name      = data.external.secret_name.result.token_name
    namespace = "default"
  }
}

# TODO: get token_reviewer dynamically
resource "vault_kubernetes_auth_backend_config" "kubernetes" {
  backend            = vault_auth_backend.kubernetes.path
  kubernetes_host    = data.external.kube_config.result.server
  kubernetes_ca_cert = base64decode(data.external.kube_config.result.certificate-authority-data)
  token_reviewer_jwt = data.kubernetes_secret.vault_auth.data.token
}

resource "vault_kubernetes_auth_backend_role" "vault_auth" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "vault-auth"
  bound_service_account_names      = ["vault-auth"]
  bound_service_account_namespaces = ["default"]
  token_ttl                        = 3600
  token_policies                   = ["default"]
}

resource "vault_kubernetes_auth_backend_role" "hello_kubernetes" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "hello-kubernetes"
  bound_service_account_names      = ["hello-kubernetes"]
  bound_service_account_namespaces = ["default"]
  token_ttl                        = 3600
  token_policies                   = ["default", "hello-kubernetes"]
}

## Rate-limit quotas

resource "vault_quota_rate_limit" "secret" {
  name = "hello-kubernetes-secret"
  path = "secret/hello-kubernetes/"
  rate = 50
}

resource "vault_quota_rate_limit" "auth" {
  name = "hello-kubernetes-auth"
  path = "auth/kubernetes/role/hello-kubernetes/"
  rate = 50
}
