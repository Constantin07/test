#!/bin/sh

# This script adds root and intermediate CA certs to system trust store

set -e

for cert_path in pki pki_int; do
    curl -sSf -o "${cert_path}_ca.crt" "${VAULT_ADDR}/v1/${cert_path}/ca/pem"
done
