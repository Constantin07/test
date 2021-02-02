terraform {
  required_providers {
    external = {
      source  = "hashicorp/external"
      version = "2.0.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.0.1"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "2.18.0"
    }
  }
  required_version = ">= 0.14"
}
