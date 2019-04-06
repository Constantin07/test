## AWS

resource "vault_auth_backend" "aws" {
  type                      = "aws"
  description               = "AWS authentication"
  default_lease_ttl_seconds = "3600"
  max_lease_ttl_seconds     = "3600"
}

## Kubernetes

provider "kubernetes" {
  version                  = "~> 1.5.2"
  config_context_auth_info = "kubernetes-admin"
  config_context_cluster   = "kubernetes"
  load_config_file         = "${var.kube_config_file}"
}

resource "vault_auth_backend" "kubernetes" {
  type                      = "kubernetes"
  description               = "K8s authentication"
  default_lease_ttl_seconds = "3600"
  max_lease_ttl_seconds     = "3600"
}

# Get Kubernetes CA cert and cluster endpoint
data "external" "kube_config" {
  program = ["python", "${path.module}/get_kubeconfig.py"]

  query = {
    config_file = "${var.kube_config_file}"
  }
}

resource "vault_kubernetes_auth_backend_config" "kubernetes" {
  backend            = "${vault_auth_backend.kubernetes.path}"
  kubernetes_host    = "${data.external.kube_config.result.server}"
  kubernetes_ca_cert = "${data.external.kube_config.result.certificate-authority-data}"
}
