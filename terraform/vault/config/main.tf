provider "vault" {
  version = "2.11.0"
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
  type        = "aws"
  description = "AWS authentication"
  tune {
    default_lease_ttl  = "3600s"
    max_lease_ttl      = "3600s"
    listing_visibility = "unauth"
  }
}

resource "vault_auth_backend" "kubernetes" {
  type        = "kubernetes"
  description = "Kubernetes authentication"
  tune {
    default_lease_ttl  = "3600s"
    max_lease_ttl      = "3600s"
    listing_visibility = "unauth"
  }
}
