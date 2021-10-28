export NAMESPACE ?= kubernetes-dashboard

# Check for required binaries
EXECUTABLES = gomplate helmfile kubectl kubeval
K := $(foreach exec,$(EXECUTABLES),\
  $(if $(shell command -v $(exec) 2> /dev/null),some string,$(error "No $(exec) in PATH")))


.PHONY: init template validate lint diff sync status destroy

template:
	gomplate -f namespace.yaml | kubectl apply --dry-run -f -
	helmfile template

validate:
	gomplate -f namespace.yaml | kubeval --strict
	helmfile template | kubeval --strict \
	--kubernetes-version 1.21.6 --schema-location https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master

lint:
	helmfile lint

diff:
	helmfile diff

sync: validate
	gomplate -f namespace.yaml | kubectl apply -f -
	helmfile sync

status:
	helmfile status

destroy:
	helmfile destroy
	gomplate -f namespace.yaml | kubectl delete --wait=false -f -
