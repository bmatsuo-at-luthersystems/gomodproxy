#!/bin/sh

set -xeo pipefail

ATHENS_USER=${ATHENS_USER:-44088:44088}
ATHENS_UID=$(echo -n "$ATHENS_USER" | cut -d: -f1)
ATHENS_GID=$(echo -n "$ATHENS_USER" | cut -d: -f2)

if [ -z "$ATHENS_GID" ]; then
    ATHENS_USER="$ATHENS_UID:$ATHENS_UID"
    ATHENS_GID=$ATHENS_UID
fi

[ "disk" == "$ATHENS_STORAGE_TYPE" ] \
    && chown "$ATHENS_USER" "$ATHENS_DISK_STORAGE_ROOT"

if ! (cut -d: -f 1 /etc/passwd | grep -Fx "$ATHENS_UID"); then
    echo "athens-proxy:x:$ATHENS_UID:$ATHENS_GID:athens-proxy:/workdir:/bin/false" >> /etc/passwd
fi

chmod 0644 /config/config.toml

gosu athens-proxy athens-proxy -config_file=/config/config.toml
