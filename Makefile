# In CI mode, the tests are sequential
CI_MODE ?= 0
TOX_PARALLEL_JOB ?= 3

.PHONY: gendoc lint test release-draft release

## gendoc               : Generate README.md for all roles
gendoc:
	@echo -- Generation of README.md for all roles in "roles"
	@find roles -type d -mindepth 1 -maxdepth 1 -exec ansible-gendoc render {} \;
	@echo ++ Generation of README.md successful

## lint-%               : Lint of a specified scenario (ex: lint-ntp)
lint-%:
	@echo -- Lint of scenario: $*
	@tox -e lint -- $*
	@echo ++ Lint successful: $*

## lint                 : Lint all scenario in the "molecule" folder
lint:
	@echo -- Lint of all scenario present in "molecule"
	@for scenario in $(shell ls molecule); do \
	  echo @@ Linting of $$scenario; \
	  tox -e lint --  $$scenario; \
	done

	@echo ++ Lint of all scenario successful

## test-%               : Test of a specified role (ex: test-ntp)
test-%:
	@echo -- Lint of scenario: $*
ifeq ($(CI_MODE),1)
	@tox -- -s $*
else
	@tox -p $(TOX_PARALLEL_JOB) -- -s $*
endif
	@echo ++ Test successful: $*

## test                 : Test of all roles in "roles"
test:
	@echo -- Lint of scenario: $*
	@tox
ifeq ($(CI_MODE),1)
	@tox
else
	@tox -p $(TOX_PARALLEL_JOB)
endif
	@echo ++ Tests successful

## release-draft        : Display a draft of semantic-release (a GITHUB_TOKEN is required)
release-draft:
ifndef GITHUB_TOKEN
	@$(error GITHUB_TOKEN is not set)
endif

	@echo -- Generate a release -draft-
	@semantic-release --dry-run --no-ci
	@echo -- Generate a release -draft- successful

## release-draft        : Do a release
release:
ifndef GITHUB_TOKEN
	@$(error GITHUB_TOKEN is not set)
endif
ifndef ANSIBLE_GALAXY_TOKEN
	@$(error ANSIBLE_GALAXY_TOKEN is not set)
endif

	@echo -- Generate a release
	@semantic-release
	@echo -- Generate a release successful

## help                 : Display this help
help: Makefile
	@sed -n 's/^##//p' $<
