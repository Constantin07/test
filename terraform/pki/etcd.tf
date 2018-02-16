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
