ARG DOCKER_SERVER_HOST
ARG DOCKER_SERVER_PORT
ARG DOCKER_PROJECT_PATH
ARG DOCKER_NODE_VERSION
ARG DOCKER_IMAGE_VERSION=master

FROM ${DOCKER_SERVER_HOST}:${DOCKER_SERVER_PORT}/${DOCKER_PROJECT_PATH}/app-dev:${DOCKER_IMAGE_VERSION} AS app
FROM nginx:alpine

COPY .docker/app-nginx/httpd.conf /etc/nginx/conf.d/default.conf
COPY --from=app /app/build /app/build

WORKDIR /app/build

EXPOSE 80
STOPSIGNAL SIGTERM
CMD ["nginx", "-g", "daemon off;"]
