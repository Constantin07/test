terraform {
  required_version = ">= 0.14"
}

terraform {
  backend "s3" {
    bucket = "dev-710782875474-terraform-state"
    key    = "pipeline.tfstate"

    dynamodb_table = "terraform-lock"
    encrypt        = true
    region         = "eu-west-1"
  }
}
