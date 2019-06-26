
export NAMESPACE ?= default

.PHONY: template lint diff sync status destroy

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
