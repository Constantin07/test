#!/bin/sh

set -o errexit
set -o nounset

if [ "$#" -ne 3 ]; then
    echo "Illegal number of parameters, expecting 3 but got $#."
fi

VAULT_ROLE="$1"
VAULT_SECRET_PATH="$2"
CREDS_FILE="$3"

CA_CERT_FILE="/var/run/secrets/kubernetes.io/serviceaccount/ca.crt"
JWT_FILE="/var/run/secrets/kubernetes.io/serviceaccount/token"

for retry in {1..5}; do
  export VAULT_TOKEN="$(vault write -field=token -ca-cert=@${CA_CERT_FILE} auth/kubernetes/login role=${VAULT_ROLE} jwt=@${JWT_FILE})" && break || sleep 3
done

for retry in {1..5}; do
  vault kv get -format json ${VAULT_SECRET_PATH} > "${CREDS_FILE}" && break || sleep 3
done
