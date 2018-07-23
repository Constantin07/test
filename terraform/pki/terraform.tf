terraform {
  required_version = ">= 0.11.7"

  backend "s3" {
    bucket         = "costea-states"
    key            = "terraform/pki.tfstate"
    dynamodb_table = "costea-states"
    encrypt        = true
    region         = "eu-west-1"

    role_arn     = "arn:aws:iam::532814210204:role/TerraformAdmin"
    session_name = "Terraform"
  }
}

provider "tls" {
  version = ">= 1.1.0"
}
