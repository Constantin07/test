#!/usr/bin/env bash

# Generate root CA certificate and save to file

set -e

ROOT_CA_PATH="pki"

vault write -field=certificate $ROOT_CA_PATH/root/generate/internal \
  common_name="Root CA" \
  format="pem" \
  key_type="rsa" \
  key_bits="2048" \
  ttl=87600h > ca_cert.pem
