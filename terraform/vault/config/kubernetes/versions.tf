terraform {
  required_version = "~> 1.3"

  required_providers {
    external = {
      source  = "hashicorp/external"
      version = "2.3.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.20"
    }
  }
}
