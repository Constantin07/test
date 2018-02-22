/* etcd server certificate */

resource "tls_private_key" "etcd_server_priv_key" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "tls_cert_request" "etcd_server_cert_req" {
  key_algorithm   = "${tls_private_key.etcd_server_priv_key.algorithm}"
  private_key_pem = "${tls_private_key.etcd_server_priv_key.private_key_pem}"

  subject {
    common_name  = "etcd server"
    organization = "etcd"
  }

  dns_names = [
    "etcd-1.internal",
    "etcd-2.internal",
    "etcd-3.internal",
    "etcd.internal",
    "localhost",
  ]

  ip_addresses = [
    "127.0.0.1",
    "10.0.2.24",
  ]
}

resource "tls_locally_signed_cert" "etcd_server_cert" {
  cert_request_pem   = "${tls_cert_request.etcd_server_cert_req.cert_request_pem}"
  ca_key_algorithm   = "${local.ca_key_algorithm}"
  ca_private_key_pem = "${local.ca_private_key_pem}"
  ca_cert_pem        = "${tls_self_signed_cert.ca.cert_pem}"

  is_ca_certificate     = false
  validity_period_hours = 87600
  early_renewal_hours   = 3160

  allowed_uses = [
    "server_auth",
    "data_encipherment",
    "key_encipherment",
  ]
}

/* etcd client certificate */

resource "tls_private_key" "etcd_client_priv_key" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "tls_cert_request" "etcd_client_cert_req" {
  key_algorithm   = "${tls_private_key.etcd_client_priv_key.algorithm}"
  private_key_pem = "${tls_private_key.etcd_client_priv_key.private_key_pem}"

  subject {
    common_name  = "etcd client"
    organization = "etcd"
  }
}

resource "tls_locally_signed_cert" "etcd_client_cert" {
  cert_request_pem   = "${tls_cert_request.etcd_client_cert_req.cert_request_pem}"
  ca_key_algorithm   = "${local.ca_key_algorithm}"
  ca_private_key_pem = "${local.ca_private_key_pem}"
  ca_cert_pem        = "${tls_self_signed_cert.ca.cert_pem}"

  is_ca_certificate     = false
  validity_period_hours = 87600
  early_renewal_hours   = 3160

  allowed_uses = [
    "client_auth",
    "data_encipherment",
    "key_encipherment",
  ]
}

/* etcd peer certificate */

resource "tls_private_key" "etcd_peer_priv_key" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "tls_cert_request" "etcd_peer_cert_req" {
  key_algorithm   = "${tls_private_key.etcd_peer_priv_key.algorithm}"
  private_key_pem = "${tls_private_key.etcd_peer_priv_key.private_key_pem}"

  subject {
    common_name  = "etcd peer"
    organization = "etcd"
  }
}

resource "tls_locally_signed_cert" "etcd_peer_cert" {
  cert_request_pem   = "${tls_cert_request.etcd_peer_cert_req.cert_request_pem}"
  ca_key_algorithm   = "${local.ca_key_algorithm}"
  ca_private_key_pem = "${local.ca_private_key_pem}"
  ca_cert_pem        = "${tls_self_signed_cert.ca.cert_pem}"

  is_ca_certificate     = false
  validity_period_hours = 87600
  early_renewal_hours   = 3160

  allowed_uses = [
    "client_auth",
    "data_encipherment",
    "key_encipherment",
  ]
}

output "etcd_server_cert_pem" {
  description = "Etcd server certificate in PEM format"
  value       = "${tls_locally_signed_cert.etcd_server_cert.cert_pem}"
}

output "etcd_server_cert_validity" {
  description = "Etcd server certificate validity timeframe"

  value = {
    start = "${tls_locally_signed_cert.etcd_server_cert.validity_start_time}"
    end   = "${tls_locally_signed_cert.etcd_server_cert.validity_end_time}"
  }
}

output "etcd_client_cert_pem" {
  description = "Etcd client certificate in PEM format"
  value       = "${tls_locally_signed_cert.etcd_client_cert.cert_pem}"
}

output "etcd_client_cert_validity" {
  description = "Etcd client certificate validity timeframe"

  value = {
    start = "${tls_locally_signed_cert.etcd_client_cert.validity_start_time}"
    end   = "${tls_locally_signed_cert.etcd_client_cert.validity_end_time}"
  }
}

output "etcd_peer_cert_pem" {
  description = "Etcd peer certificate in PEM format"
  value       = "${tls_locally_signed_cert.etcd_peer_cert.cert_pem}"
}

output "etcd_peer_cert_validity" {
  description = "Etcd peer certificate validity timeframe"

  value = {
    start = "${tls_locally_signed_cert.etcd_peer_cert.validity_start_time}"
    end   = "${tls_locally_signed_cert.etcd_peer_cert.validity_end_time}"
  }
}
