terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.5"
    }
  }
  required_version = "~> 1.1"
}
