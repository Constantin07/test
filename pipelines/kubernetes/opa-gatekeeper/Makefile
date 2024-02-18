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
	helmfile template | kubeconform -strict -summary -cache /tmp/kubeconform -ignore-missing-schemas -kubernetes-version 1.28.7

lint:
	helmfile lint

diff:
	helmfile diff

deploy:
	helmfile sync
	kubectl -n ${NAMESPACE} apply -f config.gatekeeper.yaml
	kubectl apply -f *_template.yaml -f *_constraint.yaml

status:
	helmfile status

destroy:
	kubectl -n ${NAMESPACE} delete -f config.gatekeeper.yaml --ignore-not-found=true
	kubectl delete -f *_template.yaml -f *_constraint.yaml --ignore-not-found=true
	helmfile destroy
	kubectl delete crd -l gatekeeper.sh/system=yes || true
