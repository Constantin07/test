export NAMESPACE ?= k8s-image-puller

# Check for required binaries
EXECUTABLES = helm helmfile kubeconform
K := $(foreach exec,$(EXECUTABLES),\
  $(if $(shell command -v $(exec) 2> /dev/null),some string,$(error "No $(exec) in PATH")))


.PHONY: init template validate lint diff deploy apply status delete destroy

init:
	helm plugin install https://github.com/aslafy-z/helm-git --version 0.15.1 || true
	helmfile repos

template:
	helmfile template

validate:
	mkdir -p /tmp/kubeconform
	helmfile template | kubeconform -strict -summary -cache /tmp/kubeconform -ignore-missing-schemas -kubernetes-version 1.29.4

lint:
	helmfile lint

diff:
	helmfile diff

apply:
	helmfile sync

status:
	helmfile status

destroy:
	helmfile destroy
