export NAMESPACE ?= default
export CONFIG_FILE ?= node.yaml

# Check for required binaries
EXECUTABLES = gomplate kubectl kubeconform
K := $(foreach exec,$(EXECUTABLES),\
  $(if $(shell command -v $(exec) 2> /dev/null),some string,$(error "No $(exec) in PATH")))

.PHONY: validate template diff apply status destroy

validate:
	mkdir -p /tmp/kubeconform
	gomplate -f ${CONFIG_FILE} | kubeconform -strict -summary -cache /tmp/kubeconform -ignore-missing-schemas -kubernetes-version 1.26.6

template:
	gomplate -f ${CONFIG_FILE}

diff:
	gomplate -f ${CONFIG_FILE} | kubectl diff -n ${NAMESPACE} -f -

apply: validate
	gomplate -f ${CONFIG_FILE} | kubectl apply -n ${NAMESPACE} -f -

destroy:
	gomplate -f ${CONFIG_FILE} | kubectl delete -n ${NAMESPACE} -f -
