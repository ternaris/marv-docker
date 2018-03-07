#!/usr/bin/env bash

set -e

cd "$(dirname "$(realpath "$0")")"

VAR="$PWD/../marv-site-var"
ETC="$PWD/etc"
ADDONS="$PWD/addons"

[[ -d "$MARV_SCANROOT" ]] || (
    echo "Please set MARV_SCANROOT to directory containing your bags"
    exit 1
)
[[ -d "$VAR" ]] || mkdir "$VAR"
[[ -d "$ETC" ]]
[[ -d "$ADDONS" ]]

#docker build -t ternaris/marvce -f .dockerfile .
docker stop marvce || true
docker rm marvce || true
docker run \
       --name marvce \
       --hostname marvce \
       --restart unless-stopped \
       --detach \
       -p "127.0.0.1:8000:8000" \
       -p "127.0.0.1:8443:8443" \
       -v "$ETC:/etc/marv" \
       -v "$(realpath "$ADDONS"):/opt/marv/addons" \
       -v "$(realpath "$MARV_SCANROOT"):/scanroot" \
       -v "$(realpath "$VAR"):/var/lib/marv" \
       ternaris/marvce
exec docker logs -f marvce
