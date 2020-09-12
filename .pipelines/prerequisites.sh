#!/usr/bin/env bash
try
(

  rancher_lock && rancher_login && helm_cluster_login
  rancher_namespace
  helm_init_namespace
  namespace_secret_additional_project_registry ${CI_PROJECT_NAME} ${CI_REGISTRY_USER} ${CI_JOB_TOKEN}

  ${KUBECTL} -n ${KUBE_NAMESPACE} create secret generic ${CI_PROJECT_NAME}-generic \
      --from-literal=APP_SENTRY_DSN="${APP_SENTRY_DSN}" \
      \
  -o yaml --dry-run | ${KUBECTL} -n ${KUBE_NAMESPACE} replace --force -f -

  namespace_secret_acme_cert ingress-cert ${KUBE_INGRESS_CERT_HOSTNAME}
)
# directly after closing the subshell you need to connect a group to the catch using ||
catch || {
  rancher_logout && rancher_unlock helm_cluster_logout
  exit $ex_code
}

rancher_logout && rancher_unlock && helm_cluster_logout
