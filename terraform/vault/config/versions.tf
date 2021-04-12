terraform {
  required_providers {
    external = {
      source  = "hashicorp/external"
      version = "2.1.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.0.3"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "2.19.0"
    }
  }
  required_version = ">= 0.14"
}
