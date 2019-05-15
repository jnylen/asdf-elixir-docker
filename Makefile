## Credit to bitwalker
.PHONY: help

VERSION ?= `cat VERSION`
IMAGE_NAME ?= jnylen/asdf-elixir

# Base with asdf and all reqs installed
build_base: ## Rebuild the Docker image
	docker build --force-rm -t $(IMAGE_NAME):base - < ./Dockerfile.base

release_base: build_base ## Rebuild and release the Docker image to Docker Hub
	docker push $(IMAGE_NAME):base

# The elixir builds

help:
	@echo "$(IMAGE_NAME):$(VERSION)"
	@perl -nle'print $& if m{^[a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

test_all: ## Test the Docker image
	docker run --rm -it $(IMAGE_NAME):$(VERSION) elixir --version

build_all: ## Rebuild the Docker image
	docker build --force-rm -t $(IMAGE_NAME):$(VERSION) -t $(IMAGE_NAME):latest - < ./Dockerfile.all

release_all: build_all ## Rebuild and release the Docker image to Docker Hub
	docker push $(IMAGE_NAME):$(VERSION)
	docker push $(IMAGE_NAME):latest
