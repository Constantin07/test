variable "region" {
  description = "AWS region"
}

variable "vpc_cidr" {
  description = "The CIDR IP block allocated for VPC"
  type        = "string"
}

variable "newbits" {
  description = "The new mask for the subnet within the virtual network"
  type        = "string"
}

variable "internal_dns_domain" {
  description = "Internal DNS domain"
  type        = "string"
}

variable "availability_zones_count" {
  description = "Number of avalability zones"
  type        = "string"
}

variable "environment" {
  description = "Environment name"
  type        = "string"
}

variable "project" {
  description = "Project name"
  type        = "string"
}
