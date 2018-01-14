#!/bin/bash

set -e

# gen conf
envsubst '${XMS} ${XMX} ${XSS} \
          ${RMI_SERVER_HOSTNAME} ${RMI_REGISTRY_PORT_PLATFORM} ${RMI_SERVER_PORT_PLATFORM} \
          ${MQ_HOST} ${MQ_PORT} ${MQ_USER} ${MQ_PASS} ${MQ_VHOST}' \
         < /data/tomcat/conf/wrapper-java-additional.temp \
         > /data/tomcat/conf/wrapper-java-additional.conf

# current user is root
if [ "$(id -u)" = "0" ]; then
    if [ -z "$1" ]; then
        # exec by root 
        exec /bin/sh -c "/usr/sbin/sshd -D"
    fi
    if [ -n "$1" ]; then
        # exec by myapp
        exec gosu myapp "$@"
    fi
fi

# exec by spec user
exec "$@"
