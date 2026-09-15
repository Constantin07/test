export NAMESPACE ?= argo-rollouts

# Check for required binaries
EXECUTABLES = helm helmfile kubeconform
K := $(foreach exec,$(EXECUTABLES),\
  $(if $(shell command -v $(exec) 2> /dev/null),some string,$(error "No $(exec) in PATH")))

.PHONY: init
init:
	helmfile repos

.PHONY: template
template:
	helmfile template

.PHONY: validate
validate:
	mkdir -p /tmp/kubeconform
	helmfile template | kubeconform -strict -summary -cache /tmp/kubeconform -ignore-missing-schemas -kubernetes-version 1.36.4

.PHONY: lint
lint:
	helmfile lint

.PHONY: diff
diff:
	helmfile diff

.PHONY: deploy
deploy: validate
	helmfile sync

.PHONY: status
status:
	helmfile status

.PHONY: destroy
destroy:
	helmfile destroy
