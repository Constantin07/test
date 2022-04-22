terraform {
  required_providers {
    external = {
      source  = "hashicorp/external"
      version = "2.2.2"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.9.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "3.5.0"
    }
  }
  required_version = "~> 1.1"
}
