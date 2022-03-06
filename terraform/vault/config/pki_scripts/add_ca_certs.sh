#!/usr/bin/env bash

# This script adds Root and Intermediate CA certs to system truster store

set -e

ROOT_CA_PATH="pki"
INTERMEDIATE_CA_PATH="pki_int"

# For CentOS Linux
INSTALL_DIR="/usr/share/pki/ca-trust-source/anchors"

curl -sSf $VAULT_ADDR/v1/${ROOT_CA_PATH}/ca/pem -o root_ca.pem
curl -sSf $VAULT_ADDR/v1/${INTERMEDIATE_CA_PATH}/ca/pem -o int_ca.pem

mv -f root_ca.pem int_ca.pem $INSTALL_DIR/

update-ca-trust
