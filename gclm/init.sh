#!/bin/bash

##########################################################################
#
# init.sh
#
##########################################################################

set -e

# set echo color
COLOR_RED='\033[0;31m'
COLOR_GREEN='\033[0;32m'
COLOR_YELLOW='\033[0;33m'
COLOR_BLUE='\033[0;34m'
COLOR_END='\033[0m'

# fun echo color
FUN_ECHO_RED() {
    echo -e "${COLOR_RED}$@${COLOR_END}"
}
FUN_ECHO_GREEN() {
    echo -e "${COLOR_GREEN}$@${COLOR_END}"
}
FUN_ECHO_YELLOW() {
    echo -e "${COLOR_YELLOW}$@${COLOR_END}"
}
FUN_ECHO_BLUE() {
    echo -e "${COLOR_BLUE}$@${COLOR_END}"
}
trap "FUN_ECHO_RED '******* ERROR: Something went wrong.*******'; exit 1" SIGTERM
trap "FUN_ECHO_RED '******* Caught SIGINT signal. Stopping...*******'; exit 2" SIGINT

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

# set docker info
IMAGE_LOCAL=""

# result code
RE_ERR=1
RE_OK=0

# #########################################GET OPTION PARAM#########################################
FUN_USAGE() {
    FUN_ECHO_YELLOW "Usage: `basename $0` [-l] [-h]"
    FUN_ECHO_YELLOW "        [-l]          : load images from local tar archive file, default is false/empty."
    exit $RE_ERR
}
while getopts lh OPTION
do
    case $OPTION in
        l)
            IMAGE_LOCAL=true
            ;;
        h)
            FUN_USAGE
            ;;
        \?)
            FUN_USAGE
            ;;
    esac
done

# #########################################FUNCTION#########################################
FUN_LOG_ECHO() {
    l_arg=$1
    l_bs=`basename $0`
    l_time=`date "+%Y-%m-%d %H:%M:%S"`
    #echo "[$l_time]:[$l_bs]:$l_arg" >> "$LOG_FILE_NAME"
    FUN_ECHO_GREEN "$l_arg"
    return $RE_OK
}

# #########################################DO FUNCTION#########################################

if [ "${IMAGE_LOCAL}" = "true" ]; then
    # import images
    docker load -i "${BASE_DIR}/images/gclm-all.tar"
fi

# init
cp -rf ${BASE_DIR}/tools/docker-compose /usr/local/bin/docker-compose
chmod +x  /usr/local/bin/docker-compose
chmod +x  ${BASE_DIR}/*.sh
chmod +x  ${BASE_DIR}/tools/docker-compose
chmod +x  ${BASE_DIR}/volume/gclm-proxy/script/docker-entrypoint.sh
chmod 777 ${BASE_DIR}/volume/gclm-service/logs
chmod 777 ${BASE_DIR}/volume/gclm-service/logs-1
chmod 777 ${BASE_DIR}/volume/gclm-service/logs-2
chmod +x  ${BASE_DIR}/volume/gclm-service/script/docker-entrypoint.sh

FUN_LOG_ECHO "init complete."
FUN_LOG_ECHO ""

exit $?
