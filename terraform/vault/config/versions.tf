terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "3.3.1"
    }
  }
  required_version = "~> 1.1"
}
