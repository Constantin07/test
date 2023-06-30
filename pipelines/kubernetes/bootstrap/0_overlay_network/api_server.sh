#!/usr/bin/env bash

set -eu -o pipefail

NAMESPACE="${NAMESPACE:-calico-apiserver}"
TIMEOUT="600s"

BINARY="openssl"

# On CentOS 7 use openssl11 binary instead of default openssl 1.0.2k-fips which is old and doesn't support -addext
source /etc/os-release
if [[ $PRETTY_NAME =~ "CentOS Linux 7" ]]; then
   BINARY="openssl11"
fi

echo "Generate a private key and CA bundle"
${BINARY} req -x509 -nodes -newkey rsa:4096 -keyout apiserver.key -out apiserver.crt -days 365 -subj "/" -addext "subjectAltName = DNS:calico-api.calico-apiserver.svc"

echo "Provide the key and certificate to the Calico API server as a Kubernetes secret"
kubectl -n "${NAMESPACE}" create secret generic calico-apiserver-certs --from-file=apiserver.key --from-file=apiserver.crt \
  --save-config --dry-run=client -o yaml | kubectl -n "${NAMESPACE}" apply -f -

echo "Configure the main API server with the CA bundle"
kubectl patch apiservice v3.projectcalico.org -p \
  "{\"spec\": {\"caBundle\": \"$(kubectl get secret -n ${NAMESPACE} calico-apiserver-certs -o go-template='{{ index .data "apiserver.crt" }}')\"}}"

echo "Wait for Calico API server to be deployed"
kubectl -n "${NAMESPACE}" rollout status "deployment/calico-apiserver" --watch=true --timeout=${TIMEOUT}

echo "Wait for Calico API resources to become available"

MAX_RETRIES=60
RETRY=1
TIMEOUT=4
while ! kubectl api-resources | grep '\sprojectcalico.org' > /dev/null; do
    [[ $RETRY -ge $MAX_RETRIES ]] && (echo "Maximum nr. of retries reached $MAX_RETRIES, exiting ..."; exit 1)
    echo "retry $RETRY failed, waiting for $TIMEOUT sec(s) ..."
    sleep $TIMEOUT
    RETRY=$((RETRY+1))
done

echo "Calico API resources are ready."
