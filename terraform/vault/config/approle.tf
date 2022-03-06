# AppRole

resource "vault_auth_backend" "approle" {
  type        = "approle"
  description = "Approle authentication backend"

  tune {
    default_lease_ttl  = "86400s"  // 1 day
    max_lease_ttl      = "604800s" // 1 week
    listing_visibility = "unauth"
  }
}

resource "vault_approle_auth_backend_role" "jenkins" {
  backend                = vault_auth_backend.approle.path
  role_name              = "jenkins"
  role_id                = "jenkins-role-id"
  bind_secret_id         = true
  secret_id_num_uses     = 0
  token_policies         = ["default", "jenkins"]
  token_num_uses         = 0
  token_ttl              = 7200
  token_max_ttl          = 28800
  token_explicit_max_ttl = 28800
}

resource "vault_approle_auth_backend_role_secret_id" "jenkins" {
  backend   = vault_auth_backend.approle.path
  role_name = vault_approle_auth_backend_role.jenkins.role_name
}
