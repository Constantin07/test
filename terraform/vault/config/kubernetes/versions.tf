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
      version = "3.4.1"
    }
  }
  required_version = "~> 1.1"
}
