.DEFAULT_GOAL: help
SHELL := /bin/bash

PROJECTNAME := "fury-kubernetes-dr"
VERSION := $(shell (git for-each-ref refs/tags --sort=-taggerdate --format='%(refname)' --count=1 | sed -Ee 's/^refs\/tags\/v|-.*//'))

.PHONY: help
all: help
help: Makefile
	@echo
	@echo " Choose a command to run in "$(PROJECTNAME)":"
	@echo
	@sed -n 's/^##//p' $< | column -t -s ':' |  sed -e 's/^/ /'
	@echo

.PHONY: version
## version: lists the latest version of tool
version:
	@echo v$(VERSION)

SEMVER_TYPES := major minor patch
BUMP_TARGETS := $(addprefix bump-,$(SEMVER_TYPES))
.PHONY: $(BUMP_TARGETS)
## bump-major: Bumps the module up by a major version
## bump-minor: Bumps the module up by a minor version
## bump-patch: Bumps the module up by a patch version
$(BUMP_TARGETS): check-bump2version
	$(eval bump_type := $(strip $(word 2,$(subst -, ,$@))))
	@echo "Making a $(bump_type) tag"
	@bump2version --current-version $(VERSION) $(bump_type)

check-variable-%: # detection of undefined variables.
	@[[ "${${*}}" ]] || (echo '*** Please define variable `${*}` ***' && exit 1)

check-%: # detection of required software.
	@which ${*} > /dev/null || (echo '*** Please install `${*}` ***' && exit 1)

requirements: check-docker
	@docker build --no-cache --pull --target requirements -f build/builder/Dockerfile -t ${PROJECTNAME}:local-requirements .

## add-license: Add license headers in all files in the project
add-license: requirements
	@docker run --rm -v ${ROOT_DIR}:/app -w /app ${PROJECTNAME}:local-requirements addlicense -c "SIGHUP s.r.l" -v -l bsd .
	@$(MAKE) clean-requirements

## check-label: Check if labels are present in all kustomization files
check-label: check-docker
	@docker build --no-cache --pull --target checklabel -f build/builder/Dockerfile -t ${PROJECTNAME}:checklabel .

## lint: Run the policeman over the repository
lint: check-docker
	@docker build --no-cache --pull --target linter -f build/builder/Dockerfile -t ${PROJECTNAME}:local-lint .
	@$(MAKE) clean-lint

## deploy-all: Deploys all the components in the dr module (with velero-on-prem)
deploy-all: deploy-base deploy-on-prem deploy-base deploy-restic deploy-schedules

## deploy-base: Deploys the `base` component in the cluster
deploy-base: check-kustomize check-kubectl
	@kustomize build katalog/velero/velero-base | kubectl apply -f-

## deploy-on-prem: Deploys the `velero-on-prem` component in the cluster
deploy-on-prem: check-kustomize check-kubectl
	@kustomize build katalog/velero/velero-on-prem | kubectl apply -f-

## deploy-restic: Deploys the `velero-restic` component in the cluster
deploy-restic: check-kustomize check-kubectl
	@kustomize build katalog/velero/velero-restic | kubectl apply -f-

## deploy-schedules: Deploys the `velero-schedules` component in the cluster
deploy-schedules: check-kustomize check-kubectl
	@kustomize build katalog/velero/velero-schedules | kubectl apply -f-

## clean-%: Clean the container image resulting from another target. make build clean-build
clean-%:
	docker rmi -f ${PROJECTNAME}:local-${*}
