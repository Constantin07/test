
export NAMESPACE ?= default

# Check for required binaries
EXECUTABLES = helm helmfile kubeval
K := $(foreach exec,$(EXECUTABLES),\
  $(if $(shell command -v $(exec) 2> /dev/null),some string,$(error "No $(exec) in PATH")))


.PHONY: init template validate lint diff apply status destroy

init:
	helm repo update

template: validate
	helmfile template

validate:
	helmfile template | kubeval --strict

lint:
#	helmfile lint
	helmfile template | kubectl apply --dry-run=server -f -

diff:
	helmfile diff

apply: validate
	helmfile sync

status:
	helmfile status

destroy:
	helmfile destroy
