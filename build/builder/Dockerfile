# Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

FROM golang:1.16 as requirements

RUN go get -u github.com/google/addlicense

# hadolint ignore=DL3007
FROM quay.io/sighup/policeman:latest as linter

ENV VALIDATE_KUBERNETES_KUBEVAL="false"
ENV VALIDATE_JSCPD="false"
ENV VALIDATE_DOCKERFILE="false"
ENV VALIDATE_TERRAFORM_TERRASCAN="false"

RUN mkdir /app
WORKDIR /app

COPY . .

RUN npm install -g embedme@1.22.0 && /entrypoint.sh && embedme --verify "**/*.md"

FROM golang:1.16 as add-license-requirement

RUN go get -u github.com/google/addlicense && addlicense -c "SIGHUP s.r.l" -v -l bsd .

FROM golang:1.16 as check-license

RUN go get -u github.com/google/addlicense && mkdir /app

RUN mkdir /app
WORKDIR /app

COPY . .

RUN addlicense -c "SIGHUP s.r.l" -v -l bsd --check .

FROM openpolicyagent/conftest:v0.28.1 as checklabel

RUN mkdir /app
WORKDIR /app

COPY . .

RUN conftest pull https://raw.githubusercontent.com/sighupio/ci-commons/main/conftest/kustomization/kfd-labels.rego && \
  conftest test katalog/velero/velero-base/kustomization.yaml

FROM python:3.9-alpine as bumpversion-requirement

# hadolint ignore=DL3018
RUN apk add git --no-cache && pip --no-cache-dir install bump2version==1.0.1

ENTRYPOINT ["/usr/local/bin/bumpversion"]

FROM registry.sighup.io/poc/fury-repo-automations:v0.0.2 as jsonbuilder

RUN mkdir /app
WORKDIR /app

COPY . .
