#!/usr/bin/env bash

set -e
set -u
set -o pipefail

#---------------GLOBAL vars -------------

export PROD_ENV=staging
export DEV_ENV=dev

#---------------DEV vars -------------
export KUBE_NAMESPACE_PREFIX=app-site-front
export KUBE_INGRESS_PATH=/
export CI_PROJECT_NAME=app-site-front
export ADMIN_EMAIL=root@localhost

source .pipelines/.env.devops

#import functions
. .gitlab-ci-functions/docker.sh
. .gitlab-ci-functions/kubernetes.sh
. .gitlab-ci-functions/mysql.sh
. .gitlab-ci-functions/misc.sh
. .gitlab-ci-functions/trycatch.sh



. .pipelines/transform_from_jenkins.sh
. .pipelines/before_step.sh
. .pipelines/build_images.sh
. .pipelines/app_image.sh
. .pipelines/app_test.sh
. .pipelines/prerequisites.sh
. .pipelines/app_deploy.sh
