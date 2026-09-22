#!/usr/bin/env sh
set -eu
docker compose -f compose.yml -f compose.apps.yml config >/dev/null
docker compose -f compose.yml -f compose.apps.yml run --rm --no-deps gateway nginx -t
echo "Gateway Compose configuration is valid."
