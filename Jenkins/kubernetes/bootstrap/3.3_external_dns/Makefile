
export NAMESPACE ?= default

.PHONY: init validate template lint diff sync status destroy

$(eval export TSIG_SECRET=$(shell cat kube-cluster.internal.enc))

init:
	helm repo update

validate:
	helmfile template | kubeval --strict

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
