
export NAMESPACE ?= default

.PHONY: init template validate lint diff sync status destroy

init:
	helm repo update

template: validate
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
