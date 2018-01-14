#!/bin/bash

#####################################
#
# 容器启动脚本
#
#####################################

# set author info
DATE=`date "+%Y-%m-%d %H:%M:%S"`
DATE2=`date "+%Y%m%d%H%M%S"`
BUILD_AUTHOR="ranyong@gddev.com"
BUILD_DATE="${DATE}"
BUILD_DATE2="${DATE2}"

# set envirionment
PWD=`pwd`
BASE_DIR="${PWD}"
SOURCE="$0"
while [ -h "$SOURCE"  ]; do # resolve $SOURCE until the file is no longer a symlink
    BASE_DIR="$( cd -P "$( dirname "$SOURCE"  )" && pwd  )"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /*  ]] && SOURCE="$BASE_DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
BASE_DIR="$( cd -P "$( dirname "$SOURCE"  )" && pwd  )"

# entry base dir
cd ${BASE_DIR}

# set docker compose info
#COMPOSE_BIN=/usr/local/bin/docker-compose
COMPOSE_BIN=${BASE_DIR}/tools/docker-compose
COMPOSE_YML=${BASE_DIR}/demo.yml
PROJECT_DIR=${BASE_DIR}
PROJECT_NAME=demo

ACTION_FLAG=

# result code
RE_ERR=1
RE_OK=0

LOG_ECHO() {
    l_arg=$1
    l_bs=`basename $0`
    l_time=`date "+%Y-%m-%d %H:%M:%S"`
    #echo "[$l_time]:[$l_bs]:$l_arg" >> "$LOG_FILE_NAME"
    echo "$l_arg"
    return $RE_OK
}

USAGE() {
    LOG_ECHO "Usage: `basename $0` [-u] [-d] [-s] [-t] [-p] [-h]"
    LOG_ECHO "        [-u] : container up."
    LOG_ECHO "        [-d] : container down."
    LOG_ECHO "        [-s] : container start."
    LOG_ECHO "        [-t] : container stop."
    LOG_ECHO "        [-p] : container ps."
    LOG_ECHO "        [-h] : show help info."
    exit $RE_ERR
}

while getopts udstph OPTION
do
    case $OPTION in
        u)
            ACTION_FLAG="up"
            ;;
        d)
            ACTION_FLAG="down"
            ;;
        s)
            ACTION_FLAG="start"
            ;;
        t)
            ACTION_FLAG="stop"
            ;;
        p)
            ACTION_FLAG="ps"
            ;;
        h)
            USAGE
            ;;
        \?)
            USAGE
            ;;
    esac
done

# print author info
PRINTAUTHORINFO() {
    LOG_ECHO ""
    LOG_ECHO "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    LOG_ECHO "    build author  : ${BUILD_AUTHOR}"
    LOG_ECHO "    build date    : ${BUILD_DATE}"
    LOG_ECHO "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    LOG_ECHO ""
}


# compose up
FUN_COMPOSE_UP() {
    LOG_ECHO "docker compose up container start ..."
    ${COMPOSE_BIN} --file ${COMPOSE_YML} --project-name ${PROJECT_NAME} --project-directory ${PROJECT_DIR} up -d
    LOG_ECHO "docker compose up container end"
    LOG_ECHO ""
}

# compose down
FUN_COMPOSE_DOWN() {
    LOG_ECHO "docker compose down container start ..."
    ${COMPOSE_BIN} --file ${COMPOSE_YML} --project-name ${PROJECT_NAME} --project-directory ${PROJECT_DIR} down
    LOG_ECHO "docker compose down container end"
    LOG_ECHO ""
}

# compose start
FUN_COMPOSE_START() {
    LOG_ECHO "docker compose start container start ..."
    ${COMPOSE_BIN} --file ${COMPOSE_YML} --project-name ${PROJECT_NAME} --project-directory ${PROJECT_DIR} start
    LOG_ECHO "docker compose start container end"
    LOG_ECHO ""
}

# compose stop
FUN_COMPOSE_STOP() {
    LOG_ECHO "docker compose stop container start ..."
    ${COMPOSE_BIN} --file ${COMPOSE_YML} --project-name ${PROJECT_NAME} --project-directory ${PROJECT_DIR} stop
    LOG_ECHO "docker compose stop container end"
    LOG_ECHO ""
}

# compose ps
FUN_COMPOSE_PS() {
    LOG_ECHO "docker compose ps container start ..."
    ${COMPOSE_BIN} --file ${COMPOSE_YML} --project-name ${PROJECT_NAME} --project-directory ${PROJECT_DIR} ps
    LOG_ECHO "docker compose ps container end"
    LOG_ECHO ""
}

# print author info
PRINTAUTHORINFO


if [ "${ACTION_FLAG}" = "up" ]; then
    FUN_COMPOSE_UP
fi
if [ "${ACTION_FLAG}" = "down" ]; then
    FUN_COMPOSE_DOWN
fi
if [ "${ACTION_FLAG}" = "start" ]; then
    FUN_COMPOSE_START
fi
if [ "${ACTION_FLAG}" = "stop" ]; then
    FUN_COMPOSE_STOP
fi
if [ "${ACTION_FLAG}" = "ps" ]; then
    FUN_COMPOSE_PS
fi

LOG_ECHO "complete."
LOG_ECHO ""

exit $?
