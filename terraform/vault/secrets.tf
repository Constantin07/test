# Secret engines

resource "vault_mount" "secrets" {
  path        = "secrets"
  type        = "kv"
  description = "Secret engine v1"
}
