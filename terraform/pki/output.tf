output "etcd-1_server_cert_pem" {
  description = "etcd-1 server certificate in PEM format"
  value       = "${tls_locally_signed_cert.etcd-1_server_cert.cert_pem}"
}

output "etcd-2_server_cert_pem" {
  description = "etcd-2 server certificate in PEM format"
  value       = "${tls_locally_signed_cert.etcd-2_server_cert.cert_pem}"
}

output "etcd-3_server_cert_pem" {
  description = "etcd-3 server certificate in PEM format"
  value       = "${tls_locally_signed_cert.etcd-3_server_cert.cert_pem}"
}

output "etcd-client_cert_pem" {
  description = "etcd-client certificate in PEM format"
  value       = "${tls_locally_signed_cert.etcd-client_cert.cert_pem}"
}
