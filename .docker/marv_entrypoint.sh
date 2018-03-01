#!/bin/bash

source /etc/profile.d/marv_env.sh

set -e

if [[ -d "$MARV_ADDONS" ]]; then
    find "$MARV_ADDONS" -maxdepth 2 -name setup.py -execdir pip install -e . \;
fi

# TODO: check if sessionkey exists
if [[ -n "$INIT_SITE" ]] || [[ ! -e "$MARV_SITE/sessionkey" ]]; then
    marv init
fi

exec "$@"
