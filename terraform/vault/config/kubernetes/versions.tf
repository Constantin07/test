terraform {
  required_version = "~> 1.8"

  required_providers {
    external = {
      source  = "hashicorp/external"
      version = "2.3.3"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.30"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 4.2"
    }
  }
}
