
export NAMESPACE ?= default

.PHONY: template lint sync status destroy
template:
	helmfile template

lint:
	helmfile lint

sync:
	helmfile sync

status:
	helmfile status

destroy:
	helmfile destroy
