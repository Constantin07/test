export NAMESPACE ?= kubernetes-dashboard

# Check for required binaries
EXECUTABLES = gomplate helmfile kubectl kubeconform
K := $(foreach exec,$(EXECUTABLES),\
  $(if $(shell command -v $(exec) 2> /dev/null),some string,$(error "No $(exec) in PATH")))

KUBECONFORM_OPTS = -strict -summary -cache /tmp/kubeconform -ignore-missing-schemas -kubernetes-version 1.29.4

.PHONY: init template validate lint diff apply status destroy

template:
	gomplate -f namespace.yaml | kubectl apply --dry-run -f -
	helmfile template

validate:
	mkdir -p /tmp/kubeconform
	gomplate -f namespace.yaml | kubeconform ${KUBECONFORM_OPTS}
	helmfile template | kubeconform ${KUBECONFORM_OPTS}

lint:
	helmfile lint

diff:
	helmfile diff

apply: validate
	gomplate -f namespace.yaml | kubectl apply -f -
	helmfile sync

status:
	helmfile status

destroy:
	helmfile destroy
	gomplate -f namespace.yaml | kubectl delete --wait=false -f -
