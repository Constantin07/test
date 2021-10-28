
export NAMESPACE ?= default

# Check for required binaries
EXECUTABLES = helm helmfile kubeval
K := $(foreach exec,$(EXECUTABLES),\
  $(if $(shell command -v $(exec) 2> /dev/null),some string,$(error "No $(exec) in PATH")))


.PHONY: init validate template lint diff sync status destroy

$(eval export TSIG_SECRET=$(shell cat kube-cluster.internal.enc))

init:
	helm repo add bitnami https://charts.bitnami.com/bitnami
	helm repo update

validate:
	helmfile template | kubeval --strict \
	--kubernetes-version 1.21.6 --schema-location https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master

template:
	helmfile template

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
