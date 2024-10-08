export NAMESPACE ?= system

export HEADERS_FILE = headers-configmap.yaml
export HEADERS_CONFIGMAP_NAME = nginx-ingress-headers

# Check for required binaries
EXECUTABLES = helm helmfile gomplate kubectl kubeconform
K := $(foreach exec,$(EXECUTABLES),\
  $(if $(shell command -v $(exec) 2> /dev/null),some string,$(error "No $(exec) in PATH")))


.PHONY: init validate template lint diff deploy status destroy

init:
	helmfile repos

validate:
	mkdir -p /tmp/kubeconform
	gomplate -f ${HEADERS_FILE} | kubeconform --strict -summary -cache /tmp/kubeconform -ignore-missing-schemas -kubernetes-version 1.30.3
	helmfile template | kubeconform -strict -summary -cache /tmp/kubeconform -ignore-missing-schemas -kubernetes-version 1.30.3

template:
	helmfile template

lint:
	helmfile lint

diff:
	gomplate -f ${HEADERS_FILE} | kubectl diff -f -
	helmfile diff

deploy: validate
	gomplate -f ${HEADERS_FILE} | tee /dev/tty | kubectl apply -f -
	helmfile sync

status:
	helmfile status

destroy:
	helmfile destroy
	gomplate -f ${HEADERS_FILE} | kubectl delete --ignore-not-found=true -f -
