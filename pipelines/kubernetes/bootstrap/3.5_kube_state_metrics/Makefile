export NAMESPACE ?= default

# Check for required binaries
EXECUTABLES = helm helmfile kubeconform
K := $(foreach exec,$(EXECUTABLES),\
  $(if $(shell command -v $(exec) 2> /dev/null),some string,$(error "No $(exec) in PATH")))

KUBECONFORM_OPTS = -strict -summary -cache /tmp/kubeconform -ignore-missing-schemas -kubernetes-version 1.21.7

.PHONY: init template validate lint diff sync status destroy tests

init:
	helm repo add bitnami https://charts.bitnami.com/bitnami
	helm repo update

template:
	gomplate -f ingress.yaml
	helmfile template

validate:
	mkdir -p /tmp/kubeconform
	gomplate -f ingress.yaml | kubeconform ${KUBECONFORM_OPTS}
	helmfile template | kubeconform ${KUBECONFORM_OPTS}

lint:
	helmfile lint

diff:
	gomplate -f ingress.yaml | kubectl diff -f -
	helmfile diff

sync: validate
	gomplate -f ingress.yaml | tee /dev/tty | kubectl apply -f -
	helmfile sync

status:
	helmfile status

destroy:
	helmfile destroy
	gomplate -f ingress.yaml | kubectl delete --ignore-not-found=true -f -

tests:
	./tests.sh
