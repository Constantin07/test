terraform {
  required_version = ">= 0.11.10"

  backend "s3" {
    bucket = "costea2-states"
    key    = "terraform/pki.tfstate"

    //dynamodb_table = "costea-states"
    encrypt = true
    region  = "eu-west-1"

    role_arn     = "arn:aws:iam::705505438149:role/TerraformAdmin"
    session_name = "Terraform"
  }
}
