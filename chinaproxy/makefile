init:
	brew install terraform
validate:
	cd terraform/proxy-server && terraform init
	cd terraform/proxy-server && terraform validate
	cd terraform/proxy-client && terraform init
	cd terraform/proxy-client && terraform validate

proxy-server-plan:
	cd terraform/proxy-server && terraform plan -var-file=paramaters.tfvars

proxy-server-init:
	cd terraform/proxy-server && terraform apply -var-file=paramaters.tfvars

proxy-client-plan:
	cd terraform/proxy-client && terraform plan -var-file=paramaters.tfvars

proxy-client-init:
	cd terraform/proxy-client && terraform apply -var-file=paramaters.tfvars

