# Vault policies

resource "vault_policy" "hello_kubernetes" {
  name   = "helloworld"
  policy = "${file("${path.module}/policies/policy_hello_kubernetes.hcl")}"
}
