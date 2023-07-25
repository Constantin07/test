listener "tcp" {
  address         = "0.0.0.0:8200"
  cluster_address = "0.0.0.0:8201"
  tls_disable     = true
}

ui = true

storage "file" {
  path = "/vault/file"
}

default_lease_ttl = "24h"

max_lease_ttl = "720h"
