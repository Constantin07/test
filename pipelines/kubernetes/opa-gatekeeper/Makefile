export NAMESPACE ?= gatekeeper-system

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
	helmfile template | kubeconform -strict -summary -cache /tmp/kubeconform -ignore-missing-schemas -kubernetes-version 1.26.6

lint:
	helmfile lint

diff:
	helmfile diff

deploy: validate
	helmfile sync

apply:
	kubectl apply -f k8srequiredlabels_template.yaml -f k8srequiredlabels_constraint.yaml

status:
	helmfile status

delete:
	kubectl delete -f k8srequiredlabels_template.yaml -f k8srequiredlabels_constraint.yaml --ignore-not-found=true

destroy:
	helmfile destroy
	kubectl delete crd -l gatekeeper.sh/system=yes || true