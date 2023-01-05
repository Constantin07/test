terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.12"
    }
  }
  required_version = "~> 1.3"
}
