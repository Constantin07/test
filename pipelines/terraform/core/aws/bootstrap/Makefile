
.DEFAULT_GOAL := all

.PHONY: all clean check-account

check-account:
ifndef ACCOUNT
$(error ACCOUNT is not defined. Run as `make ACCOUNT=xyz`.)
endif

all: check-account
	terraform init && terraform validate
	terraform workspace select ${ACCOUNT} || terraform workspace new ${ACCOUNT}
	terraform plan -var-file vars/${ACCOUNT}.tfvars -out plan.out
	@echo -n "Continue? [y/N] " && read resp && [ $${resp:-N} == y ]
	terraform apply plan.out
	rm -f plan.out

clean:
	rm -rf .terraform/
