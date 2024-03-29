## Auth backends

resource "vault_auth_backend" "aws" {
  type        = "aws"
  description = "AWS authentication backend"
  tune {
    default_lease_ttl  = "360s"
    max_lease_ttl      = "3600s"
    listing_visibility = "unauth"
  }
}

resource "vault_auth_backend" "userpass" {
  type        = "userpass"
  description = "Userpass authentication backend"
  tune {
    default_lease_ttl  = "3600s" // 1 hour
    max_lease_ttl      = "28800s"
    listing_visibility = "unauth"
  }
}
