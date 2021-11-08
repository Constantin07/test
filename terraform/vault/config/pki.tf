# PKI

resource "vault_mount" "pki" {
  path        = "pki"
  type        = "pki"
  description = "PKI backend"

  max_lease_ttl_seconds = 315360000
}


resource "vault_pki_secret_backend_crl_config" "crl_config" {
  backend = vault_mount.pki.path
  expiry  = "72h"
  disable = false
}

resource "vault_pki_secret_backend_config_urls" "config_urls" {
  backend                 = vault_mount.pki.path
  issuing_certificates    = ["http://vault.internal:8200/v1/pki/ca"]
  crl_distribution_points = ["http://vault.internal:8200/v1/pki/crl"]
}

/*
resource "vault_pki_secret_backend_root_cert" "test" {
  depends_on = [vault_mount.pki]

  backend = vault_mount.pki.path

  type                 = "internal"
  common_name          = "Root CA"
  ttl                  = "315360000"
  format               = "pem"
  private_key_format   = "der"
  key_type             = "rsa"
  key_bits             = 2048
  max_path_length      = 0
  exclude_cn_from_sans = true
  ou                   = "My OU"
  organization         = "My organization"
}
*/