export NAMESPACE ?= default
export CONFIG_FILE ?= node.yaml

# Check for required binaries
EXECUTABLES = gomplate kubectl kubeval
K := $(foreach exec,$(EXECUTABLES),\
  $(if $(shell command -v $(exec) 2> /dev/null),some string,$(error "No $(exec) in PATH")))

.PHONY: validate template diff sync status destroy

validate:
	gomplate -f ${CONFIG_FILE} | kubeval --strict

template:
	gomplate -f ${CONFIG_FILE}

diff:
	gomplate -f ${CONFIG_FILE} | kubectl diff -n ${NAMESPACE} -f -

sync: validate
	gomplate -f ${CONFIG_FILE} | kubectl apply -n ${NAMESPACE} -f -

destroy:
	gomplate -f ${CONFIG_FILE} | kubectl delete -n ${NAMESPACE} -f -
