path "secret/hello-kubernetes" {
  capabilities = ["read"]
}

# Allow to list top level
path "secret/" {
  capabilities = ["list"]
}
