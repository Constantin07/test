
export NAMESPACE ?= kube-system

.PHONY: init template lint diff sync status destroy

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
