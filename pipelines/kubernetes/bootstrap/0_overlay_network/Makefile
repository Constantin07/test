NAMESPACE ?= kube-system
CONFIG_FILE ?= calico.yaml
APISERVER_FILE ?= apiserver.yaml

# Check for required binaries
EXECUTABLES = kubectl kubeconform openssl
K := $(foreach exec,$(EXECUTABLES),\
  $(if $(shell command -v $(exec) 2> /dev/null),some string,$(error "No $(exec) in PATH")))

KUBECONFORM_OPTS = -strict -summary -cache /tmp/kubeconform -ignore-missing-schemas -kubernetes-version 1.30.1

.PHONY: validate install update_resources diff destroy clean

validate:
	mkdir -p /tmp/kubeconform
	kubeconform ${KUBECONFORM_OPTS} ${CONFIG_FILE}
	kubeconform ${KUBECONFORM_OPTS} ${APISERVER_FILE}

# Install Calico overlay network in K8s
install:
	@kubectl apply -f ${CONFIG_FILE} --wait=true
	@./wait.sh
	@kubectl apply -f ${APISERVER_FILE} --wait=true
	@./api_server.sh

update_resources:
	# Make sure CPU/RAM resources are guaranteed
	@kubectl -n ${NAMESPACE} set resources ds/calico-node -c=calico-node --requests='cpu=100m,memory=155Mi' --limits='cpu=300m,memory=155Mi' || true

diff:
	kubectl -n ${NAMESPACE} diff -f ${CONFIG_FILE}
	kubectl diff -f ${APISERVER_FILE}

# Remove Calico from K8s
destroy: clean
	kubectl -n calico-apiserver delete secret calico-apiserver-certs --ignore-not-found=true
	kubectl delete -f ${APISERVER_FILE} --wait=true --ignore-not-found=true
	kubectl -n ${NAMESPACE} delete -f ${CONFIG_FILE} --wait=true --ignore-not-found=true

clean:
	@rm -f apiserver.crt apiserver.key
