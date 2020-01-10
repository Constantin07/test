export NAMESPACE ?= kubernetes-dashboard

.PHONY: init template validate lint diff sync status destroy

template: validate
	gomplate -f namespace.yaml | kubectl apply --dry-run -f -
	helmfile template

validate:
	gomplate -f namespace.yaml | kubeval --strict
	helmfile template | kubeval --strict

lint:
	helmfile lint

diff:
	helmfile diff

sync: validate
	gomplate -f namespace.yaml | kubectl apply -f -
	helmfile sync

status:
	helmfile status

destroy:
	helmfile destroy
	gomplate -f namespace.yaml | kubectl delete --wait=false -f -
