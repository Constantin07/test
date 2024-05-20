# Requires VAULT_ADDR and VAULT_TOKEN environment variables to be set.
provider "vault" {
}

# Kubernetes

resource "vault_auth_backend" "kubernetes" {
  type        = "kubernetes"
  description = "Kubernetes authentication backend"
  tune {
    default_lease_ttl  = "3600s"
    max_lease_ttl      = "3600s"
    listing_visibility = "unauth"
  }
}

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

# Get secret token name associated with vault-auth service account
data "kubernetes_secret" "vault_auth" {
  metadata {
    name      = "vault-auth-token"
    namespace = "default"
  }
}

resource "vault_kubernetes_auth_backend_config" "kubernetes" {
  backend                = vault_auth_backend.kubernetes.path
  kubernetes_host        = data.external.kube_config.result.server
  kubernetes_ca_cert     = base64decode(data.external.kube_config.result.certificate-authority-data)
  token_reviewer_jwt     = data.kubernetes_secret.vault_auth.data.token
  issuer                 = "api"
  disable_iss_validation = "true"
  disable_local_ca_jwt   = "true"
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
  token_ttl                        = 7200
  token_policies                   = ["default", "hello-kubernetes"]
  token_type                       = "service"
}
