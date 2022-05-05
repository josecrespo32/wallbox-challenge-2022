DOCKER_COMPOSE_PROJECT   := qa
DOCKER_COMPOSE_ENV       :=
PROFILE                  ?= all
DOCKER_COMPOSE           := $(DOCKER_COMPOSE_ENV) docker-compose --profile $(PROFILE) -p '$(DOCKER_COMPOSE_PROJECT)'

define help
Usage: make <command>
Commands:
  help:             Show this help information
  qa-wallbox-build:    Build the environment with a docker-compose
  qa-wallbox-up:       Build and launch the environment with a docker-compose
  qa-wallbox-down:     Stop the environment
endef
export help

help:
	@echo "$$help"

qa-wallbox-build:
	$(info) "Building the environment"
	$(DOCKER_COMPOSE) build

qa-wallbox-up: qa-wallbox-build
	$(info) 'Starting up the environment'
	$(DOCKER_COMPOSE) up --build -d

qa-wallbox-down:
	$(info) 'Shutting down the environment'
	$(DOCKER_COMPOSE) down --volumes --remove-orphans


# Functions
info := @printf "\033[32;01m%s\033[0m\n"
