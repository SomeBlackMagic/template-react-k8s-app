#!/usr/bin/env bash
################### APP IMAGES ###################

function build_base_image_app() {
    echo "$(tput bold)$(tput setb 4)$(tput setaf 3)$1$(tput sgr0)"
    IMAGE=$2
    DOCKER_FILE=$3
    NPM_INSTALL_CMD=$4
    docker_build_file_args ${IMAGE} ${DOCKER_FILE} "\
            --progress=plain \
            --build-arg DOCKER_SERVER_HOST=${DOCKER_SERVER_HOST} \
            --build-arg DOCKER_SERVER_PORT=${DOCKER_SERVER_PORT} \
            --build-arg DOCKER_PROJECT_PATH=${DOCKER_PROJECT_PATH} \
            --build-arg DOCKER_NODE_VERSION=${DOCKER_NODE_VERSION} \
            --build-arg DOCKER_IMAGE_VERSION=${DOCKER_IMAGE_VERSION} \
            --build-arg NPM_INSTALL_CMD=\"${NPM_INSTALL_CMD}\" \
    "
    docker push ${IMAGE}
}

build_base_image_app "BUILD dev image" \
    "$DOCKER_SERVER_HOST:$DOCKER_SERVER_PORT/$DOCKER_PROJECT_PATH/app-dev:$DOCKER_IMAGE_VERSION" \
    .docker/app/Dockerfile \
    "yarn install"

build_base_image_app "BUILD prod image" \
    "$DOCKER_SERVER_HOST:$DOCKER_SERVER_PORT/$DOCKER_PROJECT_PATH/app-prod:$DOCKER_IMAGE_VERSION" \
    .docker/app/Dockerfile \
    "yarn install --production"

function build_app_image() {
    echo "$(tput bold)$(tput setb 4)$(tput setaf 3)$1$(tput sgr0)"
    IMAGE=$2
    DOCKER_FILE=$3
    APP_ENV=$4
    docker_build_file_args ${IMAGE} ${DOCKER_FILE} "\
            --progress=plain \
            --build-arg DOCKER_SERVER_HOST=$DOCKER_SERVER_HOST \
            --build-arg DOCKER_SERVER_PORT=$DOCKER_SERVER_PORT \
            --build-arg DOCKER_PROJECT_PATH=$DOCKER_PROJECT_PATH \
            --build-arg DOCKER_NODE_VERSION=$DOCKER_NODE_VERSION \
            --build-arg DOCKER_IMAGE_VERSION=$DOCKER_IMAGE_VERSION \
            --build-arg APP_ENV=${APP_ENV} \
    "
    docker push ${IMAGE}
}

build_app_image "BUILD app_test" \
    "$DOCKER_SERVER_HOST:$DOCKER_SERVER_PORT/$DOCKER_PROJECT_PATH/app_test:$DOCKER_IMAGE_VERSION" \
    .docker/app_test/Dockerfile \
    dev

build_app_image "BUILD app-nginx" \
    "$DOCKER_SERVER_HOST:$DOCKER_SERVER_PORT/$DOCKER_PROJECT_PATH/app-nginx/dev:$DOCKER_IMAGE_VERSION" \
    .docker/app-nginx/Dockerfile \
    dev
