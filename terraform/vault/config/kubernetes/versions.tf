terraform {
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
  required_version = "~> 1.3"
}
