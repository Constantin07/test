export NAMESPACE ?= default

# Check for required binaries
EXECUTABLES = helm helmfile kubeconform
K := $(foreach exec,$(EXECUTABLES),\
  $(if $(shell command -v $(exec) 2> /dev/null),some string,$(error "No $(exec) in PATH")))

KUBECONFORM_OPTS = -strict -summary -cache /tmp/kubeconform -ignore-missing-schemas -kubernetes-version 1.30.1


.PHONY: init template validate lint diff deploy status destroy

init:
	helmfile repos

template:
	helmfile template

validate:
	helmfile template | kubeconform ${KUBECONFORM_OPTS}

lint:
	helmfile lint

diff:
	helmfile diff

deploy: validate
	helmfile sync

status:
	helmfile status

destroy:
	helmfile destroy
