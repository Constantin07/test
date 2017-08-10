variable "region" {
  description = "AWS region"
  default     = "eu-west-1"
}

variable "vpc_cidr" {
  description = "VPC CIDR Block"
  default     = "10.0.0.0/16"
}

variable "environment" {
  description = "Environment name"
  default     = "dev"
}

variable "project" {
  description = "Project name"
  default     = "test"
}
