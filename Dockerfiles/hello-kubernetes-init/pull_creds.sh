#!/bin/sh

#set -o errexit
set -o nounset

VAULT_ROLE="$1"
VAULT_SECRET_PATH="$2"
CREDS_FILE="$3"

CA_CERT_FILE="/var/run/secrets/kubernetes.io/serviceaccount/ca.crt"
JWT_FILE="/var/run/secrets/kubernetes.io/serviceaccount/token"

for retry in {1..5}; do
    VAULT_TOKEN="$(vault write -field=token -ca-cert=@${CA_CERT_FILE} auth/kubernetes/login role=${VAULT_ROLE} jwt=@${JWT_FILE})"
    if [ $? -ne 0 ]; then
        echo "Failed to retrieve Vault token, attempt $retry, retrying in 3 seconds ..."
        sleep 3
    else
        export VAULT_TOKEN
        echo "Successfully retrived Vault token."
        break
    fi
done

for retry in {1..5}; do
    vault kv get -format json ${VAULT_SECRET_PATH} > "${CREDS_FILE}"
    if [ $? -ne 0 ]; then
        echo "Failed to read secret from Vault, attempt $retry, retrying in 3 seconds ..."
        sleep 3
    else
        echo "Successfully written secrets to ${CREDS_FILE}"
        break
    fi
done

