/* etcd certificate */

resource "tls_private_key" "etcd_priv_key" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "tls_cert_request" "etcd_cert_req" {
  key_algorithm   = "${tls_private_key.etcd_priv_key.algorithm}"
  private_key_pem = "${tls_private_key.etcd_priv_key.private_key_pem}"

  subject {
    common_name  = "etcd.local"
    organization = "None"
  }

  dns_names = [
    "etcd1.internal",
    "etcd2.internal",
    "etcd3.internal",
    "etcd.internal",
    "localhost",
  ]

  ip_addresses = [
    "127.0.0.1",
  ]
}

resource "tls_locally_signed_cert" "etcd_cert" {
  cert_request_pem   = "${tls_cert_request.etcd_cert_req.cert_request_pem}"
  ca_key_algorithm   = "${tls_self_signed_cert.ca.ca_key_algorithm}"
  ca_private_key_pem = "${tls_self_signed_cert.ca.ca_private_key_pem}"
  ca_cert_pem        = "${tls_self_signed_cert.ca.ca_cert_pem}"

  is_ca_certificate     = false
  validity_period_hours = 87600
  early_renewal_hours   = 3160

  allowed_uses = [
    "server_auth",
    "data_encipherment",
    "key_encipherment",
  ]
}
