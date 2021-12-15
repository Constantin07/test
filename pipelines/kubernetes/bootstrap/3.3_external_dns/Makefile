
export NAMESPACE ?= default

# Check for required binaries
EXECUTABLES = helm helmfile kubeconform
K := $(foreach exec,$(EXECUTABLES),\
  $(if $(shell command -v $(exec) 2> /dev/null),some string,$(error "No $(exec) in PATH")))


.PHONY: init validate template lint diff sync status destroy

$(eval export TSIG_SECRET=$(shell cat kube-cluster.internal.enc))

init:
	helm repo add bitnami https://charts.bitnami.com/bitnami
	helm repo update

validate:
	mkdir -p /tmp/kubeconform
	helmfile template | kubeconform -strict -summary -cache /tmp/kubeconform -ignore-missing-schemas -kubernetes-version 1.21.8

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
