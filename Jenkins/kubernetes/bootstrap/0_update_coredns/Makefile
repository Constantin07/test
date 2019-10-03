
# Update coredns configmap to make it work with local DNS
.PHONY: apply diff

apply:
	kubectl apply -f coredns_cm.yaml --wait=true

diff:
	kubectl diff -f coredns_cm.yaml
