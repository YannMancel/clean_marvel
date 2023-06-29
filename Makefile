
FLUTTER_VERSION?=3.10.5
FLUTTER?=fvm flutter
REPOSITORIES?=lib/ test/
RUN_VERSION?=--debug
TIMESTAMP=[TIMESTAMP]
API_KEY=[API_KEY]
HASH=[HASH]

GREEN_COLOR=\033[32m
NO_COLOR=\033[0m

define print_color_message
	@echo "$(GREEN_COLOR)$(1)$(NO_COLOR)";
endef

##
## ---------------------------------------------------------------
## Installation
## ---------------------------------------------------------------
##

.PHONY: install
install: ## Install environment
	@$(call print_color_message,"Install environment")
	fvm install $(FLUTTER_VERSION)
	fvm use $(FLUTTER_VERSION)
	$(FLUTTER) pub run build_runner build
	$(FLUTTER) pub global activate devtools

##
## ---------------------------------------------------------------
## Flutter
## ---------------------------------------------------------------
##

.PHONY: clean
clean: ## Clear cache
	@$(call print_color_message,"Clear cache")
	$(FLUTTER) clean

.PHONY: dependencies
dependencies: ## Update dependencies
	@$(call print_color_message,"Update dependencies")
	$(FLUTTER) pub get

.PHONY: format
format: ## Format code by default lib directory
	@$(call print_color_message,"Format code by default lib directory")
	dart format $(REPOSITORIES)

.PHONY: analyze
analyze: ## Analyze Dart code of the project
	@$(call print_color_message,"Analyze Dart code of the project")
	$(FLUTTER) analyze .

.PHONY: format-analyze
format-analyze: format analyze ## Format & Analyze Dart code of the project

.PHONY: test
test: ## Run all tests with coverage - Isar needs to [--concurrency=1] or [-j 1]
	@$(call print_color_message,"Run all tests with coverage - Isar needs to [--concurrency=1] or [-j 1]")
	$(FLUTTER) test \
		--concurrency=1 \
		--coverage \
		--test-randomize-ordering-seed random \
		--reporter expanded
	genhtml coverage/lcov.info \
		--output-directory coverage/html
	open coverage/html/index.html

.PHONY: devtools
devtools: ## Serving DevTools
	@$(call print_color_message,"Serving DevTools")
	$(FLUTTER) pub global run devtools

.PHONY: show-dependencies
show-dependencies: ## Show dependencies tree
	@$(call print_color_message,"Show dependencies tree")
	$(FLUTTER) pub deps

.PHONY: outdated
outdated: ## Check the version of packages
	@$(call print_color_message,"Check the version of packages")
	$(FLUTTER) pub outdated --color

.PHONY: run
run: ## Run application by default debug version
	@$(call print_color_message,"Run application by default debug version")
	$(FLUTTER) run \
		$(RUN_VERSION) \
		--dart-define TIMESTAMP=$(TIMESTAMP) \
		--dart-define API_KEY=$(API_KEY) \
		--dart-define HASH=$(HASH)

##
## ---------------------------------------------------------------
## Generator
## ---------------------------------------------------------------
##

.PHONY: generate-files
generate-files: ## Generate files with build_runner
	@$(call print_color_message,"Generate files with build_runner")
	$(FLUTTER) pub run build_runner build --delete-conflicting-outputs

##
## ---------------------------------------------------------------
## scrcpy
## ---------------------------------------------------------------
##

.PHONY: mirror
mirror: ## Mirror screen with scrcpy
	@$(call print_color_message,"Mirror screen with scrcpy")
	scrcpy --max-size 1024 --window-title 'My device'

.PHONY: record
record: ## Record screen with scrcpy
	@$(call print_color_message,"Record screen with scrcpy")
	scrcpy --max-size 1024 --no-display --record "flutter_$(shell date +%Y%m%d-%H%M%S).mp4"

#
# ----------------------------------------------------------------
# Help
# ----------------------------------------------------------------
#

.DEFAULT_GOAL := help
.PHONY: help
help:
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "$(GREEN_COLOR)%-30s$(NO_COLOR) %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'
