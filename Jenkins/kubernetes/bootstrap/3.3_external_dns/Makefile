
export NAMESPACE ?= default

# Check for required binaries
EXECUTABLES = helm helmfile kubeval
K := $(foreach exec,$(EXECUTABLES),\
  $(if $(shell command -v $(exec) 2> /dev/null),some string,$(error "No $(exec) in PATH")))


.PHONY: init validate template lint diff sync status destroy

$(eval export TSIG_SECRET=$(shell cat kube-cluster.internal.enc))

init:
	helm repo update

validate:
	helmfile template | kubeval --strict

template:
	helmfile template

lint:
#	helmfile lint
	helmfile template | kubectl apply --dry-run=server -f -

diff:
	helmfile diff

sync: validate
	helmfile sync

status:
	helmfile status

destroy:
	helmfile destroy
