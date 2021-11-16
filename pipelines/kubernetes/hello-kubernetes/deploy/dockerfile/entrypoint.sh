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

max_retries=5
retry=0
delay=2
echo "Checking vault-agent is up."
while ! (vault status > /dev/null); do
    echo "Attempt $retry failed, retry in $delay sec(s) ..."
    sleep $delay
    if [ $retry -ge $max_retries ]; then
	exit 2
    fi
    retry=$((retry+1))
done

echo "Reading vault secret from path ${VAULT_SECRET_PATH} ..."
SECRET_DATA="$(vault read -format=json ${VAULT_SECRET_PATH} | jq -rc '.data')"
RC=$?
if [[ $RC -ne 0 ]]; then
    echo "Failed to read secret at path ${VAULT_SECRET_PATH}, exit code $RC"
    exit 3
else
    export SECRET_DATA
fi

exec "$@"
