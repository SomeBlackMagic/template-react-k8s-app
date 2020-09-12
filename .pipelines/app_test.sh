#!/usr/bin/env bash
################### run tests ###################
function dev_app_test() {
    echo "$(tput bold)$(tput setb 4)$(tput setaf 3)$1$(tput sgr0)"
    IMAGE=${DOCKER_SERVER_HOST}:${DOCKER_SERVER_PORT}/${DOCKER_PROJECT_PATH}/app_test:${DOCKER_IMAGE_VERSION}
    COMMAND=$2
    docker run --rm -t $IMAGE $COMMAND
}

dev_app_test "test sass lint" "node_modules/sass-lint/bin/sass-lint.js --verbose --no-exit"
