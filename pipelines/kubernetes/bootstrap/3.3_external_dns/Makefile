export NAMESPACE ?= system

# Check for required binaries
EXECUTABLES = helm helmfile kubeconform
K := $(foreach exec,$(EXECUTABLES),\
  $(if $(shell command -v $(exec) 2> /dev/null),some string,$(error "No $(exec) in PATH")))


.PHONY: init validate template lint diff deploy status destroy test

$(eval export TSIG_SECRET=$(shell cat kube-cluster.internal.enc))

init:
	helmfile repos

validate:
	mkdir -p /tmp/kubeconform
	helmfile template | kubeconform -strict -summary -cache /tmp/kubeconform -ignore-missing-schemas -kubernetes-version 1.30.3

template:
	helmfile template

lint:
	helmfile lint

diff:
	HELM_DIFF_COLOR=true helmfile diff

deploy: validate
	helmfile sync

status:
	helmfile status

destroy:
	helmfile destroy

test:
	cd test; go mod download; go test -count=1 -namespace default
