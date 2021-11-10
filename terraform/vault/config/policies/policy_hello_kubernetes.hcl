path "secret/hello-kubernetes" {
  capabilities = ["read"]
}

# Allow to list top level
path "secret/" {
  capabilities = ["list"]
}

# Allow to issue certificates
path "pki_int/issue/test" {
  capabilities = ["update"]
}
