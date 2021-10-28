provider "vault" {
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
