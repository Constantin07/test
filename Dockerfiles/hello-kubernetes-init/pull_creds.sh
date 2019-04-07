#!/bin/sh

set -o nounset

VAULT_ROLE="$1"
VAULT_SECRET_PATH="$2"
CREDS_FILE="$3"

CA_CERT_FILE="/var/run/secrets/kubernetes.io/serviceaccount/ca.crt"
JWT_FILE="/var/run/secrets/kubernetes.io/serviceaccount/token"

#export VAULT_ADDR="http://vault.internal:8200"

retries=5

i=1
while [ $i -le $retries ]; do
    VAULT_TOKEN="$(vault write -field=token -ca-cert=@${CA_CERT_FILE} auth/kubernetes/login role=${VAULT_ROLE} jwt=@${JWT_FILE})"
    if [ $? -ne 0 ]; then
        echo "Failure to retrieve Vault token, attempt $i, retrying in 3 seconds ..."
        sleep 3
    else
        export VAULT_TOKEN
        echo "Successfully retrieved Vault token."
        break
    fi
    i=$((i + 1))
done

[[ $retries -eq $i ]] && { echo "Max retries reached, exiting ..."; exit 1; }

i=1
while [ $i -le $retries ]; do
    vault kv get -format json ${VAULT_SECRET_PATH} > "${CREDS_FILE}"
    if [ $? -ne 0 ]; then
        echo "Failure to read secret from Vault, attempt $i, retrying in 3 seconds ..."
        sleep 3
    else
        echo "Successfully written secrets to ${CREDS_FILE}"
        break
    fi
done

[[ $retries -eq $i ]] && { echo "Max retries reached, exiting ..."; exit 1; }
