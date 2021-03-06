# Kubernetes

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "kubernetes-admin@kubernetes"
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

data "kubernetes_service_account" "vault_auth" {
  metadata {
    name      = "vault-auth"
    namespace = "default"
  }
}

# Get secret token name associated with vault-auth service account
data "kubernetes_secret" "vault_auth" {
  metadata {
    name      = data.kubernetes_service_account.vault_auth.default_secret_name
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
