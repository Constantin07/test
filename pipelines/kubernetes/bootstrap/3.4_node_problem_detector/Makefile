export NAMESPACE ?= system

# Check for required binaries
EXECUTABLES = helm helmfile kubeconform
K := $(foreach exec,$(EXECUTABLES),\
  $(if $(shell command -v $(exec) 2> /dev/null),some string,$(error "No $(exec) in PATH")))


.PHONY: init template validate lint diff apply status destroy

init:
	helmfile repos

template:
	helmfile template

validate:
	mkdir -p /tmp/kubeconform
	helmfile template | kubeconform -strict -summary -cache /tmp/kubeconform -ignore-missing-schemas -kubernetes-version 1.28.7

lint:
	helmfile lint

diff:
	helmfile diff

apply: validate
	helmfile sync

status:
	helmfile status

destroy:
	helmfile destroy
