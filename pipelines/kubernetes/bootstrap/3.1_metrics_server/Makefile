export NAMESPACE ?= default

# Check for required binaries
EXECUTABLES = helm helmfile kubeval
K := $(foreach exec,$(EXECUTABLES),\
  $(if $(shell command -v $(exec) 2> /dev/null),some string,$(error "No $(exec) in PATH")))


.PHONY: init template validate lint diff sync status destroy

init:
	helm repo add bitnami https://charts.bitnami.com/bitnami
	helm repo update

template:
	helmfile template

validate:
	helmfile template | kubeval --strict \
	--kubernetes-version 1.20.5 --schema-location https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master

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
