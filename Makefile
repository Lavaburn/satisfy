VERSION ?= "2.0.0"
REPOSITORY ?= "registry.rcsnetworks.africa"
PROJECT ?= "satisfy"

# HELP
.PHONY: help

help: ## This help
		@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help


build:  ## Build the container
		docker build -t $(PROJECT):$(VERSION) .			

tag: 	## Tag the container with current version for release 
		docker tag $(PROJECT):$(VERSION) $(REPOSITORY)/$(PROJECT):$(VERSION)

push: 	## Push the current version to upstream repository 
		docker push $(REPOSITORY)/$(PROJECT):$(VERSION)

clean: 	## Remove the remote tag from the local system
		docker rmi $(REPOSITORY)/$(PROJECT):$(VERSION)

test:  ## Build the container
		docker build -t $(PROJECT)-test:$(VERSION) -f Docker_test .	

publish: build tag push clean	## Build, Tag and Push.
