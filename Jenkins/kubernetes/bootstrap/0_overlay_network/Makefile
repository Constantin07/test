
# Install calico overlay network in K8s
.PHONY: install
install:
	kubectl apply -f calico.yaml --wait=true

.PHONY: diff
diff:
	kubectl diff -f calico.yaml

# Remove tiller from K8s
.PHONY: delete
delete:
	kubectl delete -f calico.yaml --wait=true || true
