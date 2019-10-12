
export NAMESPACE ?= kube-system

.PHONY: init template validate lint diff sync status destroy

init:
	helm init --client-only
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
