CONFIG_FILE ?= calico.yaml
APISERVER_FILE ?= apiserver.yaml

# Check for required binaries
EXECUTABLES = kubectl kubeconform openssl
K := $(foreach exec,$(EXECUTABLES),\
  $(if $(shell command -v $(exec) 2> /dev/null),some string,$(error "No $(exec) in PATH")))

KUBECONFORM_OPTS = -strict -summary -cache /tmp/kubeconform -ignore-missing-schemas -kubernetes-version 1.23.12

.PHONY: validate install diff delete clean

validate:
	mkdir -p /tmp/kubeconform
	kubeconform ${KUBECONFORM_OPTS} ${CONFIG_FILE}
	kubeconform ${KUBECONFORM_OPTS} ${APISERVER_FILE}

# Install Calico overlay network in K8s
install: validate
	@kubectl apply -f ${CONFIG_FILE} --wait=true
	@./wait.sh
	# Make sure CPU/RAM resources are guaranteed
	@kubectl -n kube-system set resources ds/calico-node --requests='cpu=250m,memory=128Mi' --limits='cpu=250m,memory=128Mi' || true
	@kubectl apply -f ${APISERVER_FILE} --wait=true
	@./api_server.sh

diff:
	kubectl diff -f ${CONFIG_FILE}
	kubectl diff -f ${APISERVER_FILE}

# Remove Calico from K8s
destroy: clean
	kubectl delete -f ${CONFIG_FILE} --wait=true --ignore-not-found=true
	kubectl delete -f ${APISERVER_FILE} --wait=true --ignore-not-found=true
	kubectl -n calico-apiserver delete secret calico-apiserver-certs --ignore-not-found=true

clean:
	rm -f apiserver.crt apiserver.key
