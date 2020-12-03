terraform {
  required_providers {
    external = {
      source  = "hashicorp/external"
      version = "2.0.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "1.13.3"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "2.16.0"
    }
  }
  required_version = ">= 0.13"
}
