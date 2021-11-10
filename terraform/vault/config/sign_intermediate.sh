#!/usr/bin/env bash

# Sign the intermediate certificate with the root CA private key

set -eo pipefail

ROOT_CA_PATH="pki"

vault write -format=json $ROOT_CA_PATH/root/sign-intermediate csr=@intermediate.csr \
  format=pem_bundle ttl="43800h" \
  | jq -r '.data.certificate' > intermediate_cert.pem

# Import back into Vault

INTERMEDIATE_CA_PATH="pki_int"

vault write $INTERMEDIATE_CA_PATH/intermediate/set-signed certificate=@intermediate_cert.pem
