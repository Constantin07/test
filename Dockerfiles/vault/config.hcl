listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = 1
}

ui = true

storage "file" {
  path = "/vault/file"
}

default_lease_ttl = "24h"

max_lease_ttl = "720h"
