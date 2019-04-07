FROM paulbouwer/hello-kubernetes:1.5

ENV VAULT_VERSION=1.1.0

RUN apk add --update jq curl ca-certificates openssl && update-ca-certificates && \
    curl -O https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip && \
    unzip -d /bin vault_${VAULT_VERSION}_linux_amd64.zip
