#!/bin/bash

set -e

# gen conf
envsubst '${XMS} ${XMX} ${XSS} ${PERM_SIZE} ${MAX_PERM_SIZE} \
          ${RMI_REGISTRY_IP} ${RMI_REGISTRY_PORT} ${RMI_SERVICE_PORT} \
          ${JMX_REGISTRY_PORT} ${JMX_SERVICE_PORT} \
          ${ZK_ADDRESS} ${GCLM_AREA} \
          ${TRAP_PORT} \
          ${MQ_HOST} ${MQ_PORT} ${MQ_USER} ${MQ_PASS} ${MQ_VHOST} \
          ${MQ_EXCHANGE_TOPIC} \
          ${MQ_QUEUE_EVENT_TRAP} ${MQ_ROUTEKEY_EVENT_TRAP} \
          ${MQ_QUEUE_RESOURCE_SCAN_RESULT} ${MQ_ROUTEKEY_RESOURCE_SCAN_RESULT} \
          ${MQ_QUEUE_RESOURCE_SCAN_FINISH} ${MQ_ROUTEKEY_RESOURCE_SCAN_FINISH}' \
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
