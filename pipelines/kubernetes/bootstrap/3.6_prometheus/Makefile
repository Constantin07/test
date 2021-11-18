export NAMESPACE ?= default

# Check for required binaries
EXECUTABLES = helm helmfile kubeval
K := $(foreach exec,$(EXECUTABLES),\
  $(if $(shell command -v $(exec) 2> /dev/null),some string,$(error "No $(exec) in PATH")))

KUBEVAL_OPTS = --strict --ignore-missing-schemas --kubernetes-version 1.21.7 \
--schema-location https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master

.PHONY: init template validate lint diff sync status destroy

init:
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm repo update

template:
	helmfile template

validate:
	helmfile template | kubeval ${KUBEVAL_OPTS}

lint:
	helmfile lint

diff:
	helmfile diff

sync: validate
	helmfile sync

status:
	helmfile status

destroy:
	helmfile destroy
