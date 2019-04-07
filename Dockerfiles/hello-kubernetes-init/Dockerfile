FROM alpine:3.9 AS BUILDER

ENV VAULT_VERSION=1.1.0

RUN apk add --no-cache curl ca-certificates openssl && update-ca-certificates && \
    curl -O https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip && \
    unzip -d /bin vault_${VAULT_VERSION}_linux_amd64.zip


FROM alpine:3.9

RUN apk add --no-cache jq curl

COPY --from=BUILDER /bin/vault /bin/vault
COPY pull_creds.sh /

RUN chmod +x /pull_creds.sh /bin/vault
