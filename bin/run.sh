#!/bin/bash

# set command line arguments to variables
ARG1=$1
ARG2=$2
ARG3=$3

# set default container name
DEFAULT_CONTAINER_NAME=${PWD##*/}

# set default prefix image name
PREFIX_IMAGE_NAME="$DEFAULT_CONTAINER_NAME"

# credentials
SSH_PRIVATE_KEY="$(cat ~/.ssh/id_rsa)"
GITHUB_AUTH="$(cat ~/.composer/auth.json | grep github.com | cut -d ":" -f 2 | sed -e 's/^ "//' -e 's/"$//')"

run_development() {
  LOCALDIR=$(pwd)

  CONTAINER_NAME=${ARG2:=$DEFAULT_CONTAINER_NAME-develop}
  IMAGE_NAME=${ARG3:=$PREFIX_IMAGE_NAME-develop}

  if ! _image_exists; then
    echo "Image $IMAGE_NAME not found in local registry."
    echo -n "Do you want to build the image? (y/n): "
    read -r answer

    if [ "$answer" = "y" ]; then
         bin/build.sh develop "$IMAGE_NAME"
    else
        echo "Aborted."
        exit
    fi
  fi

  docker run --rm -v "$LOCALDIR":/home/www-data/app \
    -p 8080:8080 \
    --detach --name "$CONTAINER_NAME" "$IMAGE_NAME"

  access_message
}

run_stage() {
  CONTAINER_NAME=${ARG2:=$DEFAULT_CONTAINER_NAME-stage}
  IMAGE_NAME=${ARG3:=$PREFIX_IMAGE_NAME-stage}

  if ! _image_exists; then
    echo "Image $IMAGE_NAME not found in local registry."
    echo -n "Do you want to build the image? (y/n): "
    read -r answer

    if [ "$answer" = "y" ]; then
         bin/build.sh develop "$IMAGE_NAME"
    else
        echo "Aborted."
        exit
    fi
  fi

  _run
  access_message
}

run_production() {
  CONTAINER_NAME=${ARG2:=$DEFAULT_CONTAINER_NAME-production}
  IMAGE_NAME=${ARG3:=$PREFIX_IMAGE_NAME-production}

  if ! _image_exists; then
    echo "Image $IMAGE_NAME not found in local registry."
    echo -n "Do you want to build the image? (y/n): "
    read -r answer

    if [ "$answer" = "y" ]; then
         bin/build.sh develop "$IMAGE_NAME"
    else
        echo "Aborted."
        exit
    fi
  fi

  _run
  access_message
}

_run() {
   docker run --rm -p 8080:8080 --detach --name "$CONTAINER_NAME" "$IMAGE_NAME"
}

_image_exists() {
  EXISTENT_IMAGE=$(docker images | grep "$IMAGE_NAME" | awk '{print $1":"$2}' | grep "$IMAGE_NAME")

  if [ "$EXISTENT_IMAGE" != "" ]
    then
       true
    else
      false
  fi
}

access_message() {
    echo ""
    echo "Container name is:" $CONTAINER_NAME
    echo "Access - http://127.0.0.1:8080"
    echo ""
}

usage() {
  echo ""
  echo "usage build.sh: develop|stage|production <container_name> <image>"
  echo ""
  echo "Optionals: <container_name> <image>"
  echo "Example 1: bin/run.sh develop"
  echo "Example 2: bin/run.sh develop php-app php-app-develop"
  echo ""
}

case "$1" in
'develop')
  run_development
  ;;
'stage')
  run_stage
  ;;
'production')
  run_production
  ;;
*)
  usage
esac