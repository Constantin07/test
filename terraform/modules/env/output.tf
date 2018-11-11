output "accounts" {
  value = {
    "dev" = {
      "account"             = "705505438149"
      "region"              = "us-west-1"
      "description"         = "Development environment"
      "vpc_cidr"            = "10.0.0.0/24"
      "internal_dns_domain" = ".dev.local"
      "alias"               = "dev"
    }

    "test" = {
      "account"             = "705505438149"
      "region"              = "us-west-1"
      "description"         = "Testing environment"
      "vpc_cidr"            = "10.0.1.0/24"
      "internal_dns_domain" = ".test.local"
      "alias"               = "test"
    }

    "uat"  = "705505438149"
    "prod" = "705505438149"
  }
}
