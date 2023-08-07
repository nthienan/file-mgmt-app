# Define the default value for the STAGE variable
PORT ?= 3000
IMAGE_NAME ?= nthienan/file-mgmt-app
IMAGE_TAG ?= latest
STAGE ?= dev

.PHONY: help
help:
	@echo 'Makefile for a File Management Application                                                                                   '
	@echo '                                                                                                                             '
	@echo 'Usage:                                                                                                                       '
	@echo '   make app-run-dev [STAGE=3000]                                             run application for local development           '
	@echo '   make deps-install                                                         install application dependencies                '
	@echo '   make docker-build [IMAGE_NAME=nthienan/file-mgmt-app] [IMAGE_TAG=latest]  build docker image                              '
	@echo '   make tf-init                                                              run terraform init command						'
	@echo '   make tf-plan [STAGE=dev]                                                  run terraform plan command with given STAGE 	'
	@echo '   make tf-apply [STAGE=dev]                                                 run terraform apply command with given STAGE	'
	@echo '   make tf-destroy [STAGE=dev]                                               run terraform destroy command with given STAGE	'
	@echo '   make tf-docs                                                              generate Terraform document						'
	@echo '   make help                                                                 show this message   							'
	@echo '                                                                                                                             '
	@echo '                                                                                                                             '

.PHONY: deps-install
deps-install:
	@pip install -r app/requirements.txt


.PHONY: app-run-dev
app-run-dev:
	@uvicorn app.main:api \
		--host 0.0.0.0  \
		--port $(PORT) \
		--access-log \
		--log-level debug \
		--reload

.PHONY: docker-build
docker-build:
	@cd ./app && \
		docker build -t $(IMAGE_NAME):$(IMAGE_TAG) .


.PHONY: tf-docs
tf-docs:
	@echo "Updating Terraform docs"
	@terraform-docs markdown table \
		--output-file README.md \
		--output-mode inject \
		./infra

.PHONY: tf-init
tf-init:
	@echo "Running Terraform init"
	@terraform -chdir=./infra init --upgrade


.PHONY: tf-plan
tf-plan:
	@echo "Running Terraform plan with \"STAGE=$(STAGE)\""
	@terraform -chdir=./infra plan -var-file=./tfvars/$(STAGE).tfvars


.PHONY: tf-apply
tf-apply:
	@echo "Running Terraform apply with \"STAGE=$(STAGE)\""
	@terraform -chdir=./infra apply -var-file=./tfvars/$(STAGE).tfvars

.PHONY: tf-destroy
tf-destroy:
	@echo "Running Terraform destroy with \"STAGE=$(STAGE)\""
	@terraform -chdir=./infra destroy -var-file=./tfvars/$(STAGE).tfvars
