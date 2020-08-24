#!/bin/bash

# set command line arguments to variables
ARG1=$1
ARG2=$2

PREFIX_IMAGE_NAME="jeffersoncechinel/php7.1.33-fpm-nginx"

# set images names
BASE_IMAGE_NAME="$PREFIX_IMAGE_NAME-base:v1"
DEFAULT_DEV_NAME="$PREFIX_IMAGE_NAME-develop"
DEFAULT_STAGE_NAME="$PREFIX_IMAGE_NAME-stage"
DEFAULT_PROD_NAME="$PREFIX_IMAGE_NAME-production"

# credentials
SSH_PRIVATE_KEY="$(cat ~/.ssh/id_rsa)"
GITHUB_AUTH="$(cat ~/.composer/auth.json | grep github.com | cut -d ":" -f 2 | sed -e 's/^ "//' -e 's/"$//')"

build_base() {
  IMAGE_NAME="$BASE_IMAGE_NAME"
  DOCKER_FILE=".build/Dockerfile.base"
  _build
}

build_development() {
  IMAGE_NAME=${ARG2:=$DEFAULT_DEV_NAME}
  DOCKER_FILE=".build/Dockerfile.development"
  _build
}

build_stage() {
  IMAGE_NAME=${ARG2:=$DEFAULT_STAGE_NAME}
  DOCKER_FILE=".build/Dockerfile.stage"
  _build
}

build_production() {
  IMAGE_NAME=${ARG2:=$DEFAULT_PROD_NAME}
  DOCKER_FILE=".build/Dockerfile.production"
  _build
}

_build () {
  docker build --rm \
  --build-arg SSH_PRIVATE_KEY="$SSH_PRIVATE_KEY" \
  --build-arg GITHUB_AUTH="$GITHUB_AUTH" \
  -t "$IMAGE_NAME" . -f "$DOCKER_FILE"

   docker images | grep "$IMAGE_NAME"
}

usage() {
  echo ""
  echo "usage build.sh: base|develop|stage|production"
  echo ""
  echo "Example: bin/build.sh base"
  echo ""
}

case "$ARG1" in
'base')
  build_base
  ;;
'develop')
  build_development
  ;;
'stage')
  build_stage
  ;;
'production')
  build_production
  ;;
*)
 usage
esac