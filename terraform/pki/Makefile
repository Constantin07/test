# Terraform state key.
STATE_KEY := pki/terraform.tfstate
PLAN_FILE := plan.out

# Check all required variables are set.
.PHONY: check-vars
check-vars:
ifndef WORKSPACE
	$(error WORKSPACE must be defined.)
endif
ifndef BUCKET
	$(error BUCKET must be defined.)
endif
ifndef VARFILE
	$(error VARFILE must be defined.)
endif


.PHONY: validate
validate: check-vars
	tf ${WORKSPACE} ${BUCKET} ${STATE_KEY} validate

.PHONY: plan
plan: check-vars
	tf ${WORKSPACE} ${BUCKET} ${STATE_KEY} plan -var-file ${VARFILE} -out=${PLAN_FILE}

.PHONY: apply
apply: check-vars
	terraform apply ${PLAN_FILE}
	rm -f ${PLAN_FILE}

.PHONY: plan-destroy
plan-destroy: check-vars
	tf ${WORKSPACE} ${BUCKET} ${STATE_KEY} plan -destroy -var-file ${VARFILE} -out=${PLAN_FILE}

.PHONY: destroy
destroy: check-vars
	tf ${WORKSPACE} ${BUCKET} ${STATE_KEY} plan -destroy -var-file ${VARFILE} -out ${PLAN_FILE}
	terraform apply ${PLAN_FILE}
	rm -f ${PLAN_FILE}
