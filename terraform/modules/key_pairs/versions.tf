terraform {
  required_version = ">= 1.3"

  required_providers {
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.60"
    }
  }
}