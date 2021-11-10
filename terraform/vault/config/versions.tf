terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "2.24.1"
    }
  }
  required_version = "~> 1.0"
}
