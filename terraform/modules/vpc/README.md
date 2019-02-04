Terraform module to spin up a VPC


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| availability_zones_count | Number of avalability zones to use | string | `2` | no |
| environment | Environment name | string | - | yes |
| extra_tags | Extra tags to apply to the provisioned resources | map | `<map>` | no |
| internal_dns_domain | Internal DNS domain | string | `` | no |
| vpc_cidr | The CIDR IP block allocated for VPC | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| availability_zones |  |
| network_acl_private |  |
| private_subnets |  |
| private_subnets_cidr |  |
| public_subnets |  |
| public_subnets_cidr |  |
| vpc_cidr_block |  |
| vpc_dns_suffix |  |
| vpc_id |  |
| vpc_internet_gateway_id |  |

