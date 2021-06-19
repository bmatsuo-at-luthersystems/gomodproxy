#!/bin/bash

GOSU_PATH="${GOSU_PATH:-$PWD/_build/gosu-1.12/gosu-amd64}"

ATHENS_IMAGE="gomods/athens:latest"
ATHENS_CONTAINER_NAME="${ATHENS_CONTAINER_NAME:-athens-proxy}"
ATHENS_PORT="${ATHENS_PORT:-3000}"
ATHENS_VOLUME="${ATHENS_VOLUME:-$ATHENS_CONTAINER_NAME}"
ATHENS_USER=12321:12321
ATHENS_WORKDIR="${ATHENS_WORKDIR:-$PWD/workdir}"
ATHENS_SSH_CONFIG=$(pinata-ssh-mount)
ATHENS_GO_BINARY_ENV_VARS="${ATHENS_GO_BINARY_ENV_VARS:-GOPRIVATE=$(go env GOPRIVATE);GONOPROXY=$(go env GONOPROXY);GONOSUMDB=$(go env GONOSUMDB)}"

docker volume inspect "$ATHENS_VOLUME" > /dev/null 2>&1 \
    || docker volume create "$ATHENS_VOLUME" >/dev/null \
    || exit 1

docker run -d \
    --name "$ATHENS_CONTAINER_NAME" \
    --hostname "$ATHENS_CONTAINER_NAME" \
    -v "$GOSU_PATH":/usr/bin/gosu \
    -v "$ATHENS_VOLUME":/var/lib/athens \
    -v "$ATHENS_WORKDIR/gitconfig":/workdir/.gitconfig:ro \
    -v "$ATHENS_WORKDIR/ssh_known_hosts":/workdir/.ssh/known_hosts:ro \
    -v "$ATHENS_WORKDIR/entrypoint.sh":/workdir/entrypoint.sh \
    -w /workdir \
    -e ATHENS_DISK_STORAGE_ROOT=/var/lib/athens \
    -e ATHENS_STORAGE_TYPE=disk \
    -e ATHENS_GO_BINARY_ENV_VARS="$ATHENS_GO_BINARY_ENV_VARS" \
    -e AUTHENS_USER="$ATHENS_USER" \
    -p "$ATHENS_PORT":3000 \
    $ATHENS_SSH_CONFIG \
    -u 0:0 \
    --init \
    --entrypoint /workdir/entrypoint.sh \
    --restart always \
    "$ATHENS_IMAGE"
