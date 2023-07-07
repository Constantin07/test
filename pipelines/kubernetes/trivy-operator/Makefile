export NAMESPACE ?= trivy-operator

# Check for required binaries
EXECUTABLES = helm helmfile kubeconform
K := $(foreach exec,$(EXECUTABLES),\
  $(if $(shell command -v $(exec) 2> /dev/null),some string,$(error "No $(exec) in PATH")))


.PHONY: init template validate lint diff deploy apply status delete destroy

init:
	helmfile repos

template:
	helmfile template

validate:
	mkdir -p /tmp/kubeconform
	helmfile template | kubeconform -strict -summary -cache /tmp/kubeconform -ignore-missing-schemas -kubernetes-version 1.27.3

lint:
	helmfile lint

diff:
	helmfile diff

deploy:
	helmfile sync

status:
	helmfile status

destroy:
	helmfile destroy
	kubectl get crd --no-headers=true | grep '.aquasecurity.github.io' | awk '{print $$1}' | xargs kubectl delete crd || true
