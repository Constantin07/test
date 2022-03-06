## Policies

resource "vault_policy" "admin" {
  name   = "admin"
  policy = file("${path.module}/policies/admin.hcl")
}

resource "vault_policy" "hello_kubernetes" {
  name   = "hello-kubernetes"
  policy = file("${path.module}/policies/policy_hello_kubernetes.hcl")
}

resource "vault_policy" "jenkins" {
  name   = "jenkins"
  policy = file("${path.module}/policies/jenkins.hcl")
}
