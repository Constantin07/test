terraform {
  required_providers {
    external = {
      source  = "hashicorp/external"
      version = "2.2.3"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.16"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.12"
    }
  }
  required_version = "~> 1.3"
}
