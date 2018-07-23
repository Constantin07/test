Module used to generate SSH keypars


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| key_name_prefix | The prefix to add to SSH key name | string | `` | no |
| private_key_algorithm | The algorithm used for SSH key generation | string | `RSA` | no |
| private_key_ecdsa_curve | The name of the elliptic curve to use when ECDSA algorithm is used | string | `P224` | no |
| private_key_rsa_bits | The size in bits of SSH key | string | `2048` | no |

## Outputs

| Name | Description |
|------|-------------|
| key_name |  |
| private_key_pem |  |
| public_key_openssh |  |
| public_key_pem |  |

