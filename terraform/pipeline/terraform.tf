terraform {
  required_version = ">= 0.13"

  backend "s3" {
    bucket = "costea2-states"
    key    = "test/core.tfstate"

    dynamodb_table = "costea2-states"
    encrypt        = true
    region         = "eu-west-1"

    role_arn     = "arn:aws:iam::705505438149:role/TerraformAdmin"
    session_name = "Terraform"
  }
}
