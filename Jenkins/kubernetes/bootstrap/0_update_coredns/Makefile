
# Update coredns configmap to work with local DNS
.PHONY: apply
apply:
	kubectl apply -f coredns_cm.yaml --wait=true

.PHONY: diff
diff:
	kubectl diff -f coredns_cm.yaml
