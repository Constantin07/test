#!/bin/sh

set -x

VAULT_ROLE="$1"
VAULT_SECRET_PATH="$2"
CREDS_FILE="$3"

CA_CERT_FILE="/var/run/secrets/kubernetes.io/serviceaccount/ca.crt"
JWT_FILE="/var/run/secrets/kubernetes.io/serviceaccount/token"

VAULT_TOKEN="$(vault write -field=token -ca-cert=@${CA_CERT_FILE} auth/kubernetes/login role=${VAULT_ROLE} jwt=@${JWT_FILE})"
vault kv get -format json ${VAULT_SECRET_PATH} > "${CREDS_FILE}"
