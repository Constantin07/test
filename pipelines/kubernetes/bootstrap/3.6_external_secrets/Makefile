export NAMESPACE ?= system

# Check for required binaries
EXECUTABLES = helm helmfile kubeconform
K := $(foreach exec,$(EXECUTABLES),\
  $(if $(shell command -v $(exec) 2> /dev/null),some string,$(error "No $(exec) in PATH")))

.PHONY: init validate template lint diff apply status destroy test

init:
	helmfile repos

validate:
	mkdir -p /tmp/kubeconform
	helmfile template | kubeconform -strict -summary -cache /tmp/kubeconform -ignore-missing-schemas -kubernetes-version 1.28.6

template:
	helmfile template

lint:
	helmfile lint

diff:
	HELM_DIFF_COLOR=true helmfile diff

apply: validate
	helmfile sync

status:
	helmfile status

destroy:
	helmfile destroy
