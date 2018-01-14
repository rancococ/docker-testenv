#!/bin/bash

set -e

# gen conf
envsubst '${XMS} ${XMX} ${XSS} ${PERM_SIZE} ${MAX_PERM_SIZE} \
          ${RMI_REGISTRY_IP} ${JMX_REGISTRY_PORT} ${JMX_SERVICE_PORT} \
          ${MQ_HOST} ${MQ_PORT} ${MQ_USER} ${MQ_PASS} ${MQ_VHOST} ${MQ_QUEUE} \
          ${REDIS_HOST} ${REDIS_PORT} \
          ${SYS_MODE} ${SERVICE_URL} \
          ${LOG_LEVEL} ${DB_LEVEL} \
          ${ZK_ADDRESS} ${ZK_ENABLE}' \
         < /home/gdxw/gdxw-base/conf/wrapper/wrapper-java-additional.temp \
         > /home/gdxw/gdxw-base/conf/wrapper/wrapper-java-additional.conf

# current user is root
if [ "$(id -u)" = "0" ]; then
    if [ -z "$1" ]; then
        # exec by root 
        exec /bin/sh -c "/usr/sbin/sshd -D"
    fi
    if [ -n "$1" ]; then
        # exec by gdxw
        exec gosu gdxw "$@"
    fi
fi

# exec by spec user
exec "$@"
