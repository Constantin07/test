variable "vpc_cidr" {
  description = "The CIDR IP block allocated for VPC"
  type        = string
}

variable "internal_dns_domain" {
  description = "Internal DNS domain"
  default     = ""
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "availability_zones_count" {
  description = "Number of avalability zones to use"
  type        = number
  default     = 2
}

variable "extra_tags" {
  description = "Extra tags to apply to the provisioned resources"
  type        = map(string)
  default     = {}
}
