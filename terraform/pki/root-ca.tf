/* Trusted root CA */

resource "tls_self_signed_cert" "ca" {
  key_algorithm   = "RSA"
  private_key_pem = "${file("${path.module}/files/ca-priv-key.pem")}"

  subject {
    common_name         = "Trusted Root CA"
    organization        = "Root CA"
    organizational_unit = "N/A"
    street_address      = ["N/A"]
    province            = "London"
    country             = "UK"
    postal_code         = "N/A"
  }

  is_ca_certificate     = true
  validity_period_hours = 87600
  early_renewal_hours   = 2160

  allowed_uses = [
    "cert_signing",
  ]
}

output "ca_cert_pem" {
  description = "The ROOT CA certificate in PEM format"
  value       = "${tls_self_signed_cert.ca.cert_pem}"
}

output "ca_validity" {
  description = "The ROOT CA certificates validity timeframe"

  value = {
    start = "${tls_self_signed_cert.ca.validity_start_time}"
    end   = "${tls_self_signed_cert.ca.validity_end_time}"
  }
}
