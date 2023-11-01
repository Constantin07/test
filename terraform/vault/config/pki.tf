# PKI

## Root CA

resource "vault_mount" "pki" {
  path        = "pki"
  type        = "pki"
  description = "PKI backend for Root CA"

  # 10 years
  max_lease_ttl_seconds = 315360000
}

resource "vault_pki_secret_backend_crl_config" "crl_config" {
  backend      = vault_mount.pki.path
  expiry       = "72h"
  disable      = false
  auto_rebuild = true
}

resource "vault_pki_secret_backend_config_urls" "config_urls" {
  backend                 = vault_mount.pki.path
  issuing_certificates    = ["http://vault.internal:8200/v1/pki/ca"]
  crl_distribution_points = ["http://vault.internal:8200/v1/pki/crl"]
}

## Intermediate CA

resource "vault_mount" "pki_int" {
  path        = "pki_int"
  type        = "pki"
  description = "PKI backend for Intermediate CA"

  # 5 years
  max_lease_ttl_seconds = 157680000
}

resource "vault_pki_secret_backend_crl_config" "crl_config_int" {
  backend      = vault_mount.pki_int.path
  expiry       = "72h"
  disable      = false
  auto_rebuild = true
}

resource "vault_pki_secret_backend_config_urls" "config_urls_int" {
  backend                 = vault_mount.pki_int.path
  issuing_certificates    = ["http://vault.internal:8200/v1/pki_int/ca"]
  crl_distribution_points = ["http://vault.internal:8200/v1/pki_int/crl"]
}

# Short living certificates
resource "vault_pki_secret_backend_role" "test" {
  backend         = vault_mount.pki_int.path
  name            = "test"
  ttl             = 604800  # 7 days
  max_ttl         = 1814400 # 21 days
  allow_localhost = true
  allow_ip_sans   = true
  key_type        = "rsa"
  key_bits        = 2048
  key_usage = [
    "DigitalSignature",
    "KeyAgreement",
    "KeyEncipherment",
    "DataEncipherment",
  ]
  ext_key_usage = [
    "UsageServerAuth",
  ]
  allowed_domains = [
    "internal"
  ]
  allowed_domains_template           = true
  allow_subdomains                   = true
  allow_glob_domains                 = true
  enforce_hostnames                  = true
  server_flag                        = true
  client_flag                        = true
  code_signing_flag                  = true
  email_protection_flag              = true
  generate_lease                     = true
  no_store                           = true
  basic_constraints_valid_for_non_ca = false
}

# Long living certificates
resource "vault_pki_secret_backend_role" "server" {
  backend         = vault_mount.pki_int.path
  name            = "server"
  ttl             = 2592000  # 30 days
  max_ttl         = 31536000 # 365 days
  allow_localhost = true
  allow_ip_sans   = true
  key_type        = "rsa"
  key_bits        = 2048
  key_usage = [
    "DigitalSignature",
    "KeyAgreement",
    "KeyEncipherment",
    "DataEncipherment",
  ]
  ext_key_usage = [
    "UsageServerAuth",
  ]
  allowed_domains = [
    "internal"
  ]
  allowed_domains_template           = true
  allow_subdomains                   = true
  allow_glob_domains                 = true
  enforce_hostnames                  = true
  server_flag                        = true
  client_flag                        = true
  code_signing_flag                  = true
  email_protection_flag              = true
  generate_lease                     = true
  no_store                           = true
  basic_constraints_valid_for_non_ca = false
}
