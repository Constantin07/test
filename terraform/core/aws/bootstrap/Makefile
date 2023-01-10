
.DEFAULT_GOAL := all

ifndef ACCOUNT
all: check
endif

.PHONY: tflint
tflint:
	docker run --rm -v $$(pwd):/data -t ghcr.io/terraform-linters/tflint-bundle /data

.PHONY: all
all:
	terraform init -upgrade=true && terraform validate
	terraform workspace select ${ACCOUNT} || terraform workspace new ${ACCOUNT}
	terraform plan -var-file vars/${ACCOUNT}.tfvars -out plan.out
	@echo -n "Continue? [y/N] " && read resp && [ $${resp:-N} == y ]
	terraform apply plan.out
	rm -f plan.out

.PHONY: check
check:
	$(error ACCOUNT env. var. is not defined. Run as `make ACCOUNT=xyz`.)

.PHONY: clean
clean:
	rm -rf .terraform/
