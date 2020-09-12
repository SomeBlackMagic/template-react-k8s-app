include .env
export

RUN_ARGS = $(filter-out $@,$(MAKECMDGOALS))

include .make/static-analysis.mk
include .pipelines/.pipelines-debug.mk

.PHONY: up
up: ## spin up environment
	docker-compose up -d

.PHONY: stop
stop: ## stop environment
	docker-compose stop

.PHONY: erase
erase: ## stop and delete containers, clean volumes.
	docker-compose stop
	docker-compose rm -v -f

.PHONY: build
build: ## build environment and initialize composer and project dependencies
	docker build .docker/node$(DOCKER_NODE_VERSION)-base/ \
	--tag $(DOCKER_SERVER_HOST):$(DOCKER_SERVER_PORT)/$(DOCKER_PROJECT_PATH)/node$(DOCKER_NODE_VERSION)-base:$(DOCKER_IMAGE_VERSION) \
	--build-arg DOCKER_SERVER_HOST=$(DOCKER_SERVER_HOST) \
	--build-arg DOCKER_SERVER_PORT=$(DOCKER_SERVER_PORT) \
	--build-arg DOCKER_PROJECT_PATH=$(DOCKER_PROJECT_PATH) \
	--build-arg DOCKER_NODE_VERSION=$(DOCKER_NODE_VERSION) \
	--build-arg DOCKER_IMAGE_VERSION=$(DOCKER_IMAGE_VERSION)
	docker build .docker/node$(DOCKER_NODE_VERSION)-yarn/ \
	--tag $(DOCKER_SERVER_HOST):$(DOCKER_SERVER_PORT)/$(DOCKER_PROJECT_PATH)/node$(DOCKER_NODE_VERSION)-yarn:$(DOCKER_IMAGE_VERSION) \
	--build-arg DOCKER_SERVER_HOST=$(DOCKER_SERVER_HOST) \
	--build-arg DOCKER_SERVER_PORT=$(DOCKER_SERVER_PORT) \
	--build-arg DOCKER_PROJECT_PATH=$(DOCKER_PROJECT_PATH) \
	--build-arg DOCKER_NODE_VERSION=$(DOCKER_NODE_VERSION) \
	--build-arg DOCKER_IMAGE_VERSION=$(DOCKER_IMAGE_VERSION)
	docker build .docker/node$(DOCKER_NODE_VERSION)-dev/ \
	--tag $(DOCKER_SERVER_HOST):$(DOCKER_SERVER_PORT)/$(DOCKER_PROJECT_PATH)/node$(DOCKER_NODE_VERSION)-dev:$(DOCKER_IMAGE_VERSION) \
	--build-arg DOCKER_SERVER_HOST=$(DOCKER_SERVER_HOST) \
	--build-arg DOCKER_SERVER_PORT=$(DOCKER_SERVER_PORT) \
	--build-arg DOCKER_PROJECT_PATH=$(DOCKER_PROJECT_PATH) \
	--build-arg DOCKER_NODE_VERSION=$(DOCKER_NODE_VERSION) \
	--build-arg DOCKER_IMAGE_VERSION=$(DOCKER_IMAGE_VERSION)
	docker-compose build

.PHONY: logs
logs: ## look for service logs
	docker-compose logs -f $(RUN_ARGS)

.PHONY: help
help: ## Display this help message
	@cat $(MAKEFILE_LIST) | grep -e "^[a-zA-Z_\-]*: *.*## *" | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: node-shell
shell: ## node shell
	docker-compose run --rm app bash


.PHONY: clean
clean: ## Clear node_modules folders
	docker-compose run --rm --no-deps app sh -lc 'rm -rf node_modules/'
