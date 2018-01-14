#!/bin/bash

set -e

# gen conf
envsubst '${XMS} ${XMX} ${XSS} ${PERM_SIZE} ${MAX_PERM_SIZE} \
          ${RMI_REGISTRY_IP} ${JMX_REGISTRY_PORT} ${JMX_SERVICE_PORT} \
          ${JDBC_HOST} ${JDBC_PORT} ${JDBC_DATABASE} ${JDBC_USERNAME} ${JDBC_PASSWORD} \
          ${JDBC_HOST_SLAVE} ${JDBC_PORT_SLAVE} ${JDBC_DATABASE_SLAVE} ${JDBC_USERNAME_SLAVE} ${JDBC_PASSWORD_SLAVE} \
          ${MQ_HOST} ${MQ_PORT} ${MQ_USER} ${MQ_PASS} ${MQ_VHOST} ${MQ_QUEUE} \
          ${SMS_HOST} ${SMS_SEND_PORT} ${SMS_GET_PORT} ${SMS_ENABLE} \
          ${LOG_LEVEL} ${DB_LEVEL} \
          ${ZK_ADDRESS} ${ZK_ENABLE} ${SERVICE_ADDRESS}' \
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
