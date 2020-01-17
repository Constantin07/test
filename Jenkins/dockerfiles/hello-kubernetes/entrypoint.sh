#!/bin/sh

set -eu

if [ -z "${VAULT_SECRET_PATH}" ]; then
    echo "VAULT_SECRET_PATH environment variable is not defined. Exiting ..."
    exit 1
fi

if [ -z "${VAULT_ADDR}" ]; then
    echo "VAULT_ADDR environment variable is not defined. Exiting ..."
    exit 2
fi

while [ -n $(vault status) ]; do
    echo "Checking vault-agent is up."
    sleep 1
done

export SECRET_DATA="$(vault read -format=json ${VAULT_SECRET_PATH} | jq -rc '.data')"

exec "$@"
