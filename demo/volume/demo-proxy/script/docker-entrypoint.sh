#!/bin/bash

set -e

envsubst '${PROXY_HOST1} ${PROXY_PORT1} \
          ${PROXY_HOST2} {$PROXY_PORT2}' \
         < /etc/nginx/conf.d/upstream.temp \
         > /etc/nginx/conf.d/default.conf

exec "$@"
