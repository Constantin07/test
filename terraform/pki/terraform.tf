terraform {
  required_version = ">= 0.11.3"

  backend "s3" {
    bucket         = "costea-states"
    key            = "terraform/pki.tfstate"
    dynamodb_table = "costea-states"
    encrypt        = true
    region         = "eu-west-1"
  }
}
