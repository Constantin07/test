export NAMESPACE ?= default

# Check for required binaries
EXECUTABLES = helm helmfile kubeval
K := $(foreach exec,$(EXECUTABLES),\
  $(if $(shell command -v $(exec) 2> /dev/null),some string,$(error "No $(exec) in PATH")))


.PHONY: init template validate lint diff sync status destroy tests

init:
	helm repo update

template:
	helmfile template

validate:
	helmfile template | kubeval --strict

lint:
	helmfile lint

diff:
	helmfile diff

sync: validate
	helmfile sync

status:
	helmfile status

destroy:
	helmfile destroy

tests:
	./tests.sh