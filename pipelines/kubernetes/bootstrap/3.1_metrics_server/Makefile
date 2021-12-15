export NAMESPACE ?= default

# Check for required binaries
EXECUTABLES = helm helmfile kubeconform
K := $(foreach exec,$(EXECUTABLES),\
  $(if $(shell command -v $(exec) 2> /dev/null),some string,$(error "No $(exec) in PATH")))


.PHONY: init template validate lint diff sync status destroy

init:
	helm repo add bitnami https://charts.bitnami.com/bitnami
	helm repo update

template:
	helmfile template

validate:
	mkdir -p /tmp/kubeconform
	helmfile template | kubeconform -strict -summary -cache /tmp/kubeconform -ignore-missing-schemas -kubernetes-version 1.21.8

lint:
	helmfile lint
#	helmfile template | kubectl apply --dry-run=server -f -

diff:
	helmfile diff

sync: validate
	helmfile sync

status:
	helmfile status

destroy:
	helmfile destroy
