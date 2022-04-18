#!/usr/bin/env bash

set -euo pipefail

# Request certificate from Vault PKI backend

function usage() {
    echo "Usage: $0 <CN of certificate> <password>"
    exit 1
}

function clean() {
    rm -f $@
}

if [ $# -ne 2 ]; then
    usage
fi

# Check for required environment variables
[ -z ${VAULT_ADDR+x} ] && (echo "VAULT_ADDR env. var is not defined"; exit 1)
[ -z ${JAVA_HOME+x} ] && (echo "JAVA_HOME env. var is not defined"; exit 1)

CN="$1"
PASSWORD="$2"

FILE_PREFIX="jenkins"
CERT_FILE="${FILE_PREFIX}.crt"
KEY_FILE="${FILE_PREFIX}.key"
INT_CA_FILE="int_ca.crt"
ROOT_CA_FILE="root_ca.pem"
PKCS12_FILE="${FILE_PREFIX}.p12"
JKS_FILE="${FILE_PREFIX}.jks"

echo "Request private key,certificate and intermediate CA from Vault"
RESULT="$(vault write -format=json pki_int/issue/server common_name=$CN alt_names=localhost ip_sans=127.0.0.1 ttl=8760h | jq -r .data)"
echo "$(jq -r .certificate <<<"$RESULT")" > "$CERT_FILE"
echo "$(jq -r .private_key <<<"$RESULT")" > "$KEY_FILE"
echo "$(jq -r .issuing_ca <<<"$RESULT")" > "$INT_CA_FILE"

echo "Download Root CA certtificate from Vault"
curl -sSf $VAULT_ADDR/v1/pki/ca/pem -o "$ROOT_CA_FILE"

echo "Copy cacerts from JVM truststore"
[ -f "${JKS_FILE}" ] && rm -f "${JKS_FILE}"
cp "$JAVA_HOME/lib/security/cacerts" "$JKS_FILE"

echo "Convert certificate bundle to PKCS12 format"
openssl pkcs12 -export -out "$PKCS12_FILE" -inkey "$KEY_FILE" -in "$CERT_FILE" -certfile "$INT_CA_FILE" -chain -name "$CN" -passout "pass:$PASSWORD"

echo "Convert PKCS12 to JKS format"
keytool -importkeystore \
  -srckeystore "$PKCS12_FILE" \
  -srcstorepass "$PASSWORD" \
  -srcstoretype PKCS12 \
  -srcalias "$CN" \
  -destkeystore "$JKS_FILE" \
  -deststorepass "$PASSWORD" \
  -deststoretype JKS \
  -destalias "$CN" \
  -noprompt

clean "$CERT_FILE $KEY_FILE $INT_CA_FILE $ROOT_CA_FILE $PKCS12_FILE"
