#!/usr/bin/env bash
function app_deploy() {
    echo "$(tput bold)$(tput setb 4)$(tput setaf 3)$1$(tput sgr0)"
    HELM_CHART_NAME=$2
    HELM_APP_NAME=$3
    rancher_login && helm_cluster_login

    ${HELM} --namespace ${KUBE_NAMESPACE} list
#    ${HELM} --namespace ${KUBE_NAMESPACE} uninstall ${HELM_APP_NAME}

    $HELM upgrade  \
    --debug \
    --wait \
    --namespace ${KUBE_NAMESPACE} \
    --install ${HELM_APP_NAME} \
    .helm/${HELM_CHART_NAME} \
    \
    --set image.registry=$DOCKER_SERVER_HOST:$DOCKER_SERVER_PORT \
    --set image.repository=$DOCKER_PROJECT_PATH/app-nginx/dev \
    --set image.tag=${DOCKER_IMAGE_VERSION} \
    --set image.pullSecrets[0]=docker-registry-${CI_PROJECT_NAME} \
    \
    --set ingress.enabled=true \
    --set ingress.hosts[0].name=$KUBE_INGRESS_HOSTNAME \
    --set ingress.hosts[0].path=$KUBE_INGRESS_PATH \
    \
    --set ingress.tls[0].secretName=ingress-cert \
    --set ingress.tls[0].hosts[0]=$KUBE_INGRESS_HOSTNAME \
    \
    --set metrics.enabled=false


}

app_deploy "Deploy helm dev_job" "${CI_PROJECT_NAME}-app" "${CI_PROJECT_NAME}-app"
