#!/bin/sh

set -e -o pipefail

if [ -z "${VAULT_SECRET_PATH}" ]; then
    echo "VAULT_SECRET_PATH environment variable is not defined. Exiting ..."
    exit 1
fi

if [ -z "${VAULT_ADDR}" ]; then
    echo "VAULT_ADDR environment variable is not defined. Exiting ..."
    exit 1
fi

max_retries=10
retry=0
echo "Checking vault-agent is up."
while ! (vault status); do
    echo "retry $retry failed ..."
    sleep 2
    if [ $retry -ge $max_retries ]; then
	exit 2
    fi
    retry=$((retry+1))
done

echo "Reading vault secret."
export SECRET_DATA="$(vault read -format=json ${VAULT_SECRET_PATH} | jq -rc '.data')"

exec "$@"
