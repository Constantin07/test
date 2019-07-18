# Add vault-auth service account for Vault integration (auth)

.PHONY: install diff delete

install:
	kubectl apply -f vault-auth.yaml --wait=true

diff:
	kubectl diff -f vault-auth.yaml

delete:
	kubectl delete -f vault-auth.yaml --wait=true || true
