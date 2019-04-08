## Kubernetes

provider "kubernetes" {
  version                  = "~> 1.5.2"
  config_context_auth_info = "kubernetes-admin"
  config_context_cluster   = "kubernetes"
}

resource "vault_auth_backend" "kubernetes" {
  type                      = "kubernetes"
  description               = "K8s authentication"
  default_lease_ttl_seconds = "3600"
  max_lease_ttl_seconds     = "3600"
}

resource "kubernetes_service_account" "vault_auth" {
  metadata {
    name      = "vault-auth"
    namespace = "default"
  }

  automount_service_account_token = true
}

resource "kubernetes_cluster_role_binding" "vault_auth" {
  metadata {
    name = "role-tokenreview-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "system:auth-delegator"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "vault-auth"
    namespace = "default"
  }

  lifecycle {
    create_before_destroy = false
  }
}

# Get Kubernetes CA cert and cluster endpoint
data "external" "kube_config" {
  program = ["python", "${path.module}/get_kubeconfig.py"]

  query = {
    config_file = "${var.kube_config_file}"
  }
}

# TODO: get token_reviewer dynamically
resource "vault_kubernetes_auth_backend_config" "kubernetes" {
  backend            = "${vault_auth_backend.kubernetes.path}"
  kubernetes_host    = "${data.external.kube_config.result.server}"
  kubernetes_ca_cert = "${base64decode(data.external.kube_config.result.certificate-authority-data)}"
  token_reviewer_jwt = "${var.token_reviewer_jwt}"
}

resource "vault_kubernetes_auth_backend_role" "vault_auth" {
  backend                          = "${vault_auth_backend.kubernetes.path}"
  role_name                        = "vault-auth"
  bound_service_account_names      = ["vault-auth"]
  bound_service_account_namespaces = ["default"]
  ttl                              = 3600
  policies                         = ["default"]
}

resource "vault_kubernetes_auth_backend_role" "hello_kubernetes" {
  backend                          = "${vault_auth_backend.kubernetes.path}"
  role_name                        = "hello-kubernetes"
  bound_service_account_names      = ["hello-kubernetes"]
  bound_service_account_namespaces = ["default"]
  ttl                              = 3600
  policies                         = ["default", "hello-kubernetes"]
}
