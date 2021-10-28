## Secret engines

resource "vault_mount" "secret" {
  path        = "secret"
  type        = "kv"
  description = "Secret engine v1 backend"
}
