terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.8"
    }
  }
  required_version = "~> 1.2"
}
