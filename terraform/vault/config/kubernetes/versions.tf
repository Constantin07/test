terraform {
  required_providers {
    external = {
      source  = "hashicorp/external"
      version = "2.2.3"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.15"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.11"
    }
  }
  required_version = "~> 1.3"
}
