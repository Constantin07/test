provider "vault" {
  version = "2.15.0"
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
    default_lease_ttl  = "360s"
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


## Policies

resource "vault_policy" "hello_kubernetes" {
  name   = "hello-kubernetes"
  policy = file("${path.module}/policies/policy_hello_kubernetes.hcl")
}

