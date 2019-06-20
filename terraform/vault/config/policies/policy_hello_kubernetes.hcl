path "secret/hello-kubernetes/*" {
  capabilities = ["read", "list"]
}

path "secret/hello-kubernetes/" {
  capabilities = ["list"]
}
