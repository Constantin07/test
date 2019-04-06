resource "vault_auth_backend" "aws" {
  type                      = "aws"
  path                      = "aws"
  description               = "AWS authentication"
  default_lease_ttl_seconds = "3600"
  max_lease_ttl_seconds     = "3600"
}

resource "vault_auth_backend" "kubernetes" {
  type                      = "kubernetes"
  path                      = "kubernetes"
  description               = "K8s authentication"
  default_lease_ttl_seconds = "3600"
  max_lease_ttl_seconds     = "3600"
}
