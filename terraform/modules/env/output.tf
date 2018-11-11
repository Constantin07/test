output "accounts" {
  value = {
    "dev" = {
      "account"                  = "705505438149"
      "region"                   = "us-east-1"
      "availability_zones_count" = 2
      "description"              = "Development environment"
      "vpc_cidr"                 = "10.0.0.0/24"
      "internal_dns_domain"      = "dev.local"
      "alias"                    = "dev"
    }

    "uat" = {
      "account"                  = "705505438149"
      "region"                   = "us-east-1"
      "availability_zones_count" = 2
      "description"              = "Testing environment"
      "vpc_cidr"                 = "10.0.1.0/24"
      "internal_dns_domain"      = "uat.local"
      "alias"                    = "uat"
    }

    "prod" = {
      "account"                  = "705505438149"
      "region"                   = "us-east-1"
      "availability_zones_count" = 2
      "description"              = "Production environment"
      "vpc_cidr"                 = "10.0.2.0/24"
      "internal_dns_domain"      = "prod.local"
      "alias"                    = "prod"
    }
  }
}
