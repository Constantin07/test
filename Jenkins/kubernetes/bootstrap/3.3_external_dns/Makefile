
export NAMESPACE ?= default

.PHONY: init template lint diff sync status destroy

$(eval export TSIG_SECRET=$(shell cat kube-cluster.internal.enc))

init:
	helm init --client-only
	helm repo update

template:
	helmfile template

lint:
	helmfile lint

diff:
	helmfile diff

sync:
	helmfile sync

status:
	helmfile status

destroy:
	helmfile destroy
