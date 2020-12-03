/* etcd-1 server certificate */

provider "tls" {
}

resource "tls_private_key" "etcd-1_server_priv_key" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "tls_cert_request" "etcd-1_server_cert_req" {
  key_algorithm   = tls_private_key.etcd-1_server_priv_key.algorithm
  private_key_pem = tls_private_key.etcd-1_server_priv_key.private_key_pem

  subject {
    common_name  = "etcd-1.internal"
    organization = var.organisation
  }

  dns_names = [
    "etcd-1.internal",
    var.etcd_cluster_name,
    "localhost",
  ]

  ip_addresses = [
    "10.0.2.24",
    "127.0.0.1",
  ]
}

resource "tls_locally_signed_cert" "etcd-1_server_cert" {
  cert_request_pem   = tls_cert_request.etcd-1_server_cert_req.cert_request_pem
  ca_key_algorithm   = local.ca_key_algorithm
  ca_private_key_pem = local.ca_private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca.cert_pem

  is_ca_certificate     = false
  validity_period_hours = 87600
  early_renewal_hours   = 3160

  allowed_uses = [
    "digital_signature",
    "server_auth",
    "client_auth",
    "data_encipherment",
    "key_encipherment",
  ]
}

/* etcd-2 server certificate */

resource "tls_private_key" "etcd-2_server_priv_key" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "tls_cert_request" "etcd-2_server_cert_req" {
  key_algorithm   = tls_private_key.etcd-2_server_priv_key.algorithm
  private_key_pem = tls_private_key.etcd-2_server_priv_key.private_key_pem

  subject {
    common_name  = "etcd-2.internal"
    organization = var.organisation
  }

  dns_names = [
    "etcd-2.internal",
    var.etcd_cluster_name,
    "localhost",
  ]

  ip_addresses = [
    "10.0.2.25",
    "127.0.0.1",
  ]
}

resource "tls_locally_signed_cert" "etcd-2_server_cert" {
  cert_request_pem   = tls_cert_request.etcd-2_server_cert_req.cert_request_pem
  ca_key_algorithm   = local.ca_key_algorithm
  ca_private_key_pem = local.ca_private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca.cert_pem

  is_ca_certificate     = false
  validity_period_hours = 87600
  early_renewal_hours   = 3160

  allowed_uses = [
    "digital_signature",
    "server_auth",
    "client_auth",
    "data_encipherment",
    "key_encipherment",
  ]
}

/* etcd-3 server certificate */

resource "tls_private_key" "etcd-3_server_priv_key" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "tls_cert_request" "etcd-3_server_cert_req" {
  key_algorithm   = tls_private_key.etcd-3_server_priv_key.algorithm
  private_key_pem = tls_private_key.etcd-3_server_priv_key.private_key_pem

  subject {
    common_name  = "etcd-3.internal"
    organization = var.organisation
  }

  dns_names = [
    "etcd-3.internal",
    var.etcd_cluster_name,
    "localhost",
  ]

  ip_addresses = [
    "10.0.2.26",
    "127.0.0.1",
  ]
}

resource "tls_locally_signed_cert" "etcd-3_server_cert" {
  cert_request_pem   = tls_cert_request.etcd-3_server_cert_req.cert_request_pem
  ca_key_algorithm   = local.ca_key_algorithm
  ca_private_key_pem = local.ca_private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca.cert_pem

  is_ca_certificate     = false
  validity_period_hours = 87600
  early_renewal_hours   = 3160

  allowed_uses = [
    "digital_signature",
    "server_auth",
    "client_auth",
    "data_encipherment",
    "key_encipherment",
  ]
}

/* etcd client certificate */

resource "tls_private_key" "etcd-client_priv_key" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "tls_cert_request" "etcd-client_cert_req" {
  key_algorithm   = tls_private_key.etcd-client_priv_key.algorithm
  private_key_pem = tls_private_key.etcd-client_priv_key.private_key_pem

  subject {
    common_name  = "etcd-client"
    organization = var.organisation
  }
}

resource "tls_locally_signed_cert" "etcd-client_cert" {
  cert_request_pem   = tls_cert_request.etcd-client_cert_req.cert_request_pem
  ca_key_algorithm   = local.ca_key_algorithm
  ca_private_key_pem = local.ca_private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca.cert_pem

  is_ca_certificate     = false
  validity_period_hours = 87600
  early_renewal_hours   = 3160

  allowed_uses = [
    "digital_signature",
    "client_auth",
    "data_encipherment",
    "key_encipherment",
  ]
}

