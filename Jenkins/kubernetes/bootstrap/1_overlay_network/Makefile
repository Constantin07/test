
# Install calico overlay network in K8s
.PHONY: install
install:
	kubectl apply -f calico.yaml --wait=true
	# Make sure CPU/RAM resources are guaranteed
	kubectl set resources ds/calico-node -n kube-system --limits='cpu=250m,memory=128Mi' --requests='cpu=250m,memory=128Mi' || true

.PHONY: diff
diff:
	kubectl diff -f calico.yaml

# Remove tiller from K8s
.PHONY: delete
delete:
	kubectl delete -f calico.yaml --wait=true || true
