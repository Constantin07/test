ARG VAULT_VERSION

FROM vault:${VAULT_VERSION}

COPY config.hcl /vault/config/

RUN chown -R vault:vault /vault/config
