terraform {
  required_providers {
    external = {
      source  = "hashicorp/external"
      version = "2.1.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.5.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "2.24.1"
    }
  }
  required_version = ">= 0.14"
}
