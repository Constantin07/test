/* k8s api server certificate */

resource "tls_private_key" "k8s_api_server_priv_key" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

/*
resource "tls_cert_request" "k8s_api_server_cert_req" {
  key_algorithm   = "${tls_private_key.k8s_api_server_priv_key.algorithm}"
  private_key_pem = "${tls_private_key.k8s_api_server_priv_key.private_key_pem}"

  subject {
    common_name  = "k8s.internal"
    organization = "etcd"
  }

  dns_names = [
    "etcd-1.internal",
    "localhost",
  ]

  ip_addresses = [
    "10.0.2.24",
    "127.0.0.1",
  ]
}

*/

