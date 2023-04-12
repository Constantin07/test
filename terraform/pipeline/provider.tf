terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.62"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0"
    }
  }
}

provider "aws" {
  region = lookup(module.env.accounts[var.environment], "region")
}
