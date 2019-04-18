provider "vault" {
  version = "~> 1.7.0"
}

resource "vault_audit" "file" {
  type = "file"

  options = {
    file_path = "/vault/logs/audit.log"
  }
}

## Secret engines

resource "vault_mount" "secret" {
  path = "secret"
  type = "kv"
}

## Auth

resource "vault_auth_backend" "aws" {
  type                      = "aws"
  description               = "AWS authentication"
  default_lease_ttl_seconds = "3600"
  max_lease_ttl_seconds     = "3600"
}

resource "vault_auth_backend" "kubernetes" {
  type                      = "kubernetes"
  description               = "Kubernetes authentication"
  default_lease_ttl_seconds = "3600"
  max_lease_ttl_seconds     = "3600"
}
