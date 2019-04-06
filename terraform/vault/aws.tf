## AWS

resource "vault_auth_backend" "aws" {
  type                      = "aws"
  description               = "AWS authentication"
  default_lease_ttl_seconds = "3600"
  max_lease_ttl_seconds     = "3600"
}
