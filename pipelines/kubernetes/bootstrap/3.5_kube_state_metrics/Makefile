export NAMESPACE ?= system

# Check for required binaries
EXECUTABLES = helm helmfile kubeconform
K := $(foreach exec,$(EXECUTABLES),\
  $(if $(shell command -v $(exec) 2> /dev/null),some string,$(error "No $(exec) in PATH")))

KUBECONFORM_OPTS = -strict -summary -cache /tmp/kubeconform -ignore-missing-schemas -kubernetes-version 1.29.2


.PHONY: init template validate lint diff apply status destroy tests

init:
	helmfile repos

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

apply:
	gomplate -f ingress.yaml | tee /dev/tty | kubectl apply -f -
	helmfile sync

status:
	helmfile status

destroy:
	helmfile destroy
	gomplate -f ingress.yaml | kubectl delete --ignore-not-found=true -f -

tests:
	./tests.sh
