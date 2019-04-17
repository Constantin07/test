#!/bin/sh

set -o nounset

if [ $# -ne 3 ]; then
    echo "The expected number of arguments is 3 but got $#, exiting..."
    echo "Usage: $0 <vault-role> <secret-path> <credentials-file>"
    echo "Requirement: VAULT_ADDR env. variable pointing to Vault server."
    exit 1
fi

VAULT_ROLE="$1"
VAULT_SECRET_PATH="$2"
CREDS_FILE="$3"

log()
{
    echo "$(date '+%Y-%M-%d %H:%M:%S') $1"
}

CA_CERT_FILE="/var/run/secrets/kubernetes.io/serviceaccount/ca.crt"
if [ ! -f $CA_CERT_FILE ]; then
    log "File $CA_CERT_FILE not found."
    exit 1
fi

JWT_FILE="/var/run/secrets/kubernetes.io/serviceaccount/token"
if [ ! -f $JWT_FILE ]; then
    log "File $JWT_FILE not found."
    exit 1
fi

timeout=3
retries=3

i=1
while [ $i -le $retries ]; do
    VAULT_TOKEN="$(vault write -field=token -ca-cert=@${CA_CERT_FILE} auth/kubernetes/login role=${VAULT_ROLE} jwt=@${JWT_FILE})"
    if [ $? -ne 0 ]; then
        log "Failure to retrieve Vault token, attempt $i, retrying in $timeout seconds ..."
        sleep $timeout
    else
        export VAULT_TOKEN="${VAULT_TOKEN}"
        log "Successfully retrieved Vault token."
        break
    fi
    i=$((i + 1))
done

if [ "$i" -ge "$retries" ]; then
    log "Max retries reached, exiting ..."
    exit 1
fi

i=1
while [ $i -le $retries ]; do
    vault kv get -format json ${VAULT_SECRET_PATH} > "${CREDS_FILE}"
    if [ $? -ne 0 ]; then
        log "Failure to read secret from Vault, attempt $i, retrying in $timeout seconds ..."
        sleep $timeout
    else
        log "Successfully written secrets to ${CREDS_FILE}"
        break
    fi
done

if [ "$i" -ge "$retries" ]; then
    log "Max retries reached, exiting ..."
    exit 1
fi
