.PHONY: build
build: scripts/setup.sh variables.json ## Builds all the images defined in the Packer template
	packer build -var-file=variables.json template.json

.PHONY: googlecompute
googlecompute: scripts/setup.sh variables.json ## Builds only the Google Compute image defined in the Packer template
	packer build -only=googlecompute -var-file=variables.json template.json

.PHONY: amazon-ebs
amazon-ebs: scripts/setup.sh variables.json ## Builds only the Amazon EBS image defined in the Packer template
	packer build -only=amazon-ebs -var-file=variables.json template.json

.PHONY: docker
docker: scripts/setup.sh variables.json ## Builds only the Docker image defined in the Packer template
	packer build -only=docker -var-file=variables.json template.json

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
