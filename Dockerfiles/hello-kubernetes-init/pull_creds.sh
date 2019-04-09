#!/bin/sh

set -o nounset

VAULT_ROLE="$1"
VAULT_SECRET_PATH="$2"
CREDS_FILE="$3"

CA_CERT_FILE="/var/run/secrets/kubernetes.io/serviceaccount/ca.crt"
JWT_FILE="/var/run/secrets/kubernetes.io/serviceaccount/token"

timeout=3
retries=5

i=1
while [ $i -le $retries ]; do
    VAULT_TOKEN="$(vault write -field=token -ca-cert=@${CA_CERT_FILE} auth/kubernetes/login role=${VAULT_ROLE} jwt=@${JWT_FILE})"
    if [ $? -ne 0 ]; then
        echo "Failure to retrieve Vault token, attempt $i, retrying in $timeout seconds ..."
        sleep $timeout
    else
        export VAULT_TOKEN="${VAULT_TOKEN}"
        echo "Successfully retrieved Vault token."
        break
    fi
    i=$((i + 1))
done

if [ $retries -lt $i ]; then
    echo "Max retries reached, exiting ..."; exit 1
fi

i=1
while [ $i -le $retries ]; do
    VAULT_TOKEN="${VAULT_TOKEN}" vault kv get -format json ${VAULT_SECRET_PATH} > "${CREDS_FILE}"
    if [ $? -ne 0 ]; then
        echo "Failure to read secret from Vault, attempt $i, retrying in $timeout seconds ..."
        sleep $timeout
    else
        echo "Successfully written secrets to ${CREDS_FILE}"
        break
    fi
done

if [ $retries -lt $i ]; then
    echo "Max retries reached, exiting ..."; exit 1
fi
