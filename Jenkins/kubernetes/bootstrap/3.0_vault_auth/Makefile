# Add vault-auth service account for Vault integration (auth)

CONFIG_FILE ?= vault-auth.yaml

.PHONY: validate install diff delete

validate:
	kubeval --strict ${CONFIG_FILE}

install: validate
	kubectl apply -f ${CONFIG_FILE} --wait=true

diff:
	kubectl diff -f ${CONFIG_FILE}

delete:
	kubectl delete -f ${CONFIG_FILE} --wait=true || true
