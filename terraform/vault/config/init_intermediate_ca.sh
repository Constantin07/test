#!/usr/bin/env bash

# Generate an intermediate CA CSR file

set -eo pipefail

INTERMEDIATE_CA_PATH="pki_int"

vault write -format=json $INTERMEDIATE_CA_PATH/intermediate/generate/internal \
  common_name="Intermediate CA" \
  format="pem" \
  key_type="rsa" \
  key_bits="2048" \
  | jq -r '.data.csr' > intermediate.csr
