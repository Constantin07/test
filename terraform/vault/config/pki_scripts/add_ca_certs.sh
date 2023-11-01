#!/usr/bin/env bash

# This script adds Root and Intermediate CA certs to system truster store

set -eo pipefail

ROOT_CA_PATH="pki"
INTERMEDIATE_CA_PATH="pki_int"

echo "Getting CA certs from Vault"
curl -sSf $VAULT_ADDR/v1/${ROOT_CA_PATH}/ca/pem -o root_ca.crt
curl -sSf $VAULT_ADDR/v1/${INTERMEDIATE_CA_PATH}/ca/pem -o int_ca.crt

move_ca_files() {
    local location="$1"
    echo "Moving CA certificates to CA store location $1"
    mv -f root_ca.crt int_ca.crt "${location}/"
}

# Determine OS distribution
DISTRO="$(lsb_release -is | tr "[:upper:]" "[:lower:]")"

case $DISTRO in
ubuntu)
    INSTALL_DIR="/usr/local/share/ca-certificates"
    move_ca_files $INSTALL_DIR
    update-ca-certificates
    ;;
centos)
    INSTALL_DIR="/usr/share/pki/ca-trust-source/anchors"
    move_ca_files $INSTALL_DIR
    update-ca-trust
    ;;
*)
    ;;
esac
