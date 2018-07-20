terraform {
  backend "s3" {
    bucket         = "costea-states"
    key            = "company/project/core.tfstate"
    dynamodb_table = "costea-states"
    encrypt        = true
    region         = "eu-west-1"
  }
}

provider "aws" {
  region  = "eu-west-1"
  version = ">= 1.28.0"
}
