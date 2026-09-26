terraform {
  required_version = "~> 1.8"

  required_providers {
    external = {
      source  = "hashicorp/external"
      version = "2.4.2"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 3.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 4.2"
    }
  }
}
