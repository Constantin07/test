config {
  module = true
}

plugin "terraform" {
  enabled = true
  version = "0.7.0"
  preset  = "recommended"
  source  = "github.com/terraform-linters/tflint-ruleset-terraform"
}

plugin "aws" {
  enabled = true
  version = "0.31.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}
