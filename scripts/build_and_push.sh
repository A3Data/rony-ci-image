#!/bin/sh
set -e

TAG="${DOCKERHUB_USER}/${DOCKERHUB_REPO}:${RONY_CI_VERSION}-terraform${TERRAFORM_VERSION}"

docker build . \
    --pull \
    --build-arg "TERRAFORM_VERSION=${TERRAFORM_VERSION}" \
    --tag "${TAG}"
docker push "${TAG}"