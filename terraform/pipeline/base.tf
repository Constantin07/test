module "env" {
  source = "../modules/env"
}

module "core" {
  source = "../modules/vpc"

  vpc_cidr                 = lookup(module.env.accounts[var.environment], "vpc_cidr")
  internal_dns_domain      = lookup(module.env.accounts[var.environment], "internal_dns_domain")
  availability_zones_count = lookup(module.env.accounts[var.environment], "availability_zones_count")

  environment = var.environment

  extra_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

module "key_pairs" {
  source = "../modules/key_pairs"

  key_name_prefix = var.environment
}
