#!/usr/bin/env bash

# This script adds root and intermediate CA certs to system trust store

set -eu

PKI_BACKENDS=(
pki
pki_int
)

# Check for required environment variables
[ -z ${VAULT_ADDR+x} ] && (echo "VAULT_ADDR env. var is not defined"; exit 1)
[ -z ${JAVA_HOME+x} ] && (echo "JAVA_HOME env. var is not defined"; exit 1)

for pki in ${PKI_BACKENDS[@]}; do
    curl -sSf -o "${pki}_ca.crt" "${VAULT_ADDR}/v1/${pki}/ca/pem"
    keytool -import -trustcacerts \
    -alias "$pki" \
    -file "${pki}_ca.crt" \
    -keystore "${JAVA_HOME}/lib/security/cacerts" \
    -storepass changeit \
    -noprompt
done
