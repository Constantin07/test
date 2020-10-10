output "vpc_id" {
  value = aws_vpc.default.id
}

output "vpc_cidr_block" {
  value = aws_vpc.default.cidr_block
}

output "vpc_dns_suffix" {
  value = aws_vpc_dhcp_options.default.domain_name
}

output "vpc_internet_gateway_id" {
  value = aws_internet_gateway.default.id
}

output "availability_zones" {
  value = local.availability_zones
}

output "private_subnets" {
  value = aws_subnet.private.*.id
}

output "private_subnets_cidr" {
  value = aws_subnet.private.*.cidr_block
}

output "public_subnets" {
  value = aws_subnet.public.*.id
}

output "public_subnets_cidr" {
  value = aws_subnet.public.*.cidr_block
}

output "network_acl_private" {
  value = aws_network_acl.private.id
}
