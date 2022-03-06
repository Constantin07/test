terraform {
  required_providers {
    external = {
      source  = "hashicorp/external"
      version = "2.1.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.6.1"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "3.3.1"
    }
  }
  required_version = "~> 1.0"
}
