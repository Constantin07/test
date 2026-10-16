# syntax=docker/dockerfile:1

ARG VAULT_VERSION

FROM hashicorp/vault:${VAULT_VERSION}

COPY --chown=vault:vault config.hcl /vault/config/

#checkov:skip=CKV_DOCKER_3: vault user in the container is already created
