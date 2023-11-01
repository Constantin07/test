#!/usr/bin/env bash

# Generate certificate from Vault PKI backend

set -eu -o pipefail

function usage() {
    echo "Usage: $0 <CN of certificate> <password>"
    exit 1
}

if [ $# -ne 2 ]; then
    usage
fi

CN="$1"
PASSWORD="$2"
CERT_FILE="server.crt"
KEY_FILE="server.key"
CA_FILE="ca.crt"
PKCS12_FILE="server.p12"
JKS_FILE="server.jks"
ROLE="server"

# Grab SSL certificate from Vault
RESULT="$(vault write -format=json pki_int/issue/$ROLE common_name=$CN ttl=8760h | jq -r .data)"
echo "$(jq -r .certificate <<<"$RESULT")" > $CERT_FILE
echo "$(jq -r .private_key <<<"$RESULT")" > $KEY_FILE
echo "$(jq -r .issuing_ca <<<"$RESULT")" > $CA_FILE

# Convert to PKCS12
openssl pkcs12 -export -out "$PKCS12_FILE" -inkey "$KEY_FILE" -in "$CERT_FILE" -certfile "$CA_FILE" -chain -name "$CN" -passout "pass:$PASSWORD"

# Convert PKCS12 to JKS format
keytool -importkeystore -srckeystore "$PKCS12_FILE" \
  -srcstorepass "$PASSWORD" -srcstoretype PKCS12 \
  -srcalias "$CN" -deststoretype pkcs12 \
  -destkeystore "$JKS_FILE" -deststorepass "$PASSWORD" \
  -destalias "$CN" -noprompt
