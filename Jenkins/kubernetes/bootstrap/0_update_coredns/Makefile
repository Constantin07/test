
# Update coredns configmap to make it work with local DNS

CONFIGMAP_FILE ?= coredns_cm.yaml

.PHONY: validate apply diff

validate:
	kubeval --strict ${CONFIGMAP_FILE}

apply: validate
	kubectl apply -f ${CONFIGMAP_FILE} --wait=true

diff:
	kubectl diff -f ${CONFIGMAP_FILE}
