provider "vault" {
  version = "~> 1.7.0"
}

resource "vault_audit" "file" {
  type = "file"

  options = {
    file_path = "/vault/logs/audit.log"
  }
}

# Secret engines

resource "vault_mount" "secrets" {
  path        = "secrets"
  type        = "kv"
  description = "Secret engine v1"
}
