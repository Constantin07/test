#!/usr/bin/env bash

# Bootstrap script to pull Vault token for init container

set -e -o pipefail

if [ -z "$VAULT_ADDR" ]; then
    echo "VAULT_ADDR environment variable is not defined!"
    exit 1
fi

if [ -z "$VAULT_ROLE" ]; then
    echo "VAULT_ROLE environment variable is not defined!"
    exit 1
fi

if [ -z "$AUTH_PATH" ]; then
    # Use default value
    AUTH_PATH="auth/kubernetes/login"
    echo "Using default value of '${AUTH_PATH}' for AUTH_PATH"
fi

JWT="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)"
DATA="{\"jwt\": \"${JWT}\", \"role\": \"${VAULT_ROLE}\"}"
VAULT_TOKEN="$(curl -sSfL --retry 3 -X POST --data "${DATA}" ${VAULT_ADDR}/v1/${AUTH_PATH} | jq -r '.auth.client_token')"
RC=$?
if [[ $RC -ne 0 ]]; then
    echo "Failed to get Vault token, exit code $RC"
    exit 1
else
    export VAULT_TOKEN
fi
