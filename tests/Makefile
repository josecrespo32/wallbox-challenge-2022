define help

Usage: make <command>

Commands:

  build-app      : Builds the Challenge App docker image.
  run-app        : Runs the Challenge App.

  build-tests    : Builds the Challenge App Tests docker image.
  run-tests      : Run the tests.
  run-tests-skip : Run the @skip tests.

  build-testplan : Builds the Test Plan.

endef
export help


help:
	@echo "$$help"

build-app:
	docker build -t wallbox-challenge ../

run-app:
	docker-compose run --service-ports --rm app

build-tests:
	docker build -t wallbox-challenge-tests .

run-tests:
	docker-compose run --rm tests behave -T --no-skipped --no-source --no-logcapture -t ~skip

run-tests-skip:
	docker-compose run --rm tests behave -T --no-skipped --no-source --no-logcapture -t skip

build-testplan:
	docker-compose run --rm tests python3 scripts/generate_testplan.py
