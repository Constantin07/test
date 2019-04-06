provider "vault" {
  version = "~> 1.7.0"
}

resource "vault_audit" "file" {
  type = "file"

  options = {
    file_path = "/vault/logs/audit.log"
  }
}
