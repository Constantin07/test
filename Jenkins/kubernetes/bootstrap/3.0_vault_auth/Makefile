# Add vault-auth service account for Vault integration (auth)

CONFIG_FILE ?= vault-auth.yaml

# Check for required binaries
EXECUTABLES = kubeval kubectl
K := $(foreach exec,$(EXECUTABLES),\
  $(if $(shell command -v $(exec) 2> /dev/null),some string,$(error "No $(exec) in PATH")))

.PHONY: validate install diff delete

validate:
	kubeval --strict ${CONFIG_FILE}

install: validate
	kubectl apply -f ${CONFIG_FILE} --wait=true

diff:
	kubectl diff -f ${CONFIG_FILE}

delete:
	kubectl delete -f ${CONFIG_FILE} --wait=true || true
