terraform {
  required_version = "~> 1.3"

  required_providers {
    external = {
      source  = "hashicorp/external"
      version = "2.2.3"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.18"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.14"
    }
  }
}
