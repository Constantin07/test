export NAMESPACE ?= default

# Check for required binaries
EXECUTABLES = helm helmfile kubeval
K := $(foreach exec,$(EXECUTABLES),\
  $(if $(shell command -v $(exec) 2> /dev/null),some string,$(error "No $(exec) in PATH")))

KUBEVAL_OPTS = --strict --kubernetes-version 1.21.5 \
--schema-location https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master

.PHONY: init template validate lint diff sync status destroy tests

init:
	helm repo add bitnami https://charts.bitnami.com/bitnami
	helm repo update

template:
	gomplate -f ingress.yaml
	helmfile template

validate:
	gomplate -f ingress.yaml | kubeval ${KUBEVAL_OPTS}
	helmfile template | kubeval ${KUBEVAL_OPTS}

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
