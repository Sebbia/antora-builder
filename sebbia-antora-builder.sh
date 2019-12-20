#!/bin/bash

set -e

realpath() {
  OURPWD=$PWD
  cd "$(dirname "$1")"
  LINK=$(readlink "$(basename "$1")")
  while [ "$LINK" ]; do
    cd "$(dirname "$LINK")"
    LINK=$(readlink "$(basename "$1")")
  done
  REALPATH="$PWD/$(basename "$1")"
  cd "$OURPWD"
  echo "$REALPATH"
}

help() {
    echo
    echo "Sebbia Antora documentation builder ${BUILDER_VERSION}"
    echo "======================================="
    echo
    echo "Usage: $0 [-o <output>] [-s <source>] <command>"
    echo 
    echo "Options:"
    echo "  -h - This help."
    echo "  -o <dir> - output to directory. Defaults to temporary directory."
    echo "  -s <source> - specified directory or current by default."
    echo "  -p <playbook> - path to playbook relative to source dir."
    echo 
    echo "Commands:"
    echo "  watch,w - build, start web server and watch for changes"
    echo "  build,b - build documentation. This is a default command if no command specified."
    echo
}

printError() {
    echo -e "\nERROR: $1" 1>&2
}

OUTPUT_DIR=
SRC_DIR=
PLAYBOOK=

COMMAND=${@:$OPTIND:1}
if [ -z "${COMMAND}" ]; then
    printError "Command required"
    help
    exit 1
fi
shift

case "${COMMAND}" in 
    b) COMMAND="build"
    ;;
    w) COMMAND="watch"
    ;;
esac

while getopts "ho:s:p:" opt 
do
    case $opt in
        h) help && exit 0
        ;;
        o) OUTPUT_DIR=$OPTARG
        ;;
        s) SRC_DIR=$OPTARG
        ;;
        p) PLAYBOOK=$OPTARG
        ;;
    esac
done

RUNNER_DIR=$(dirname -- $(realpath $0))

SRC_DIR=${SRC_DIR:-${PWD}}

. ${RUNNER_DIR}/config

if [ -z "${PLAYBOOK}" ]; then
    printError "Playbook required"
    help
    exit 1
fi

TMP_DIR=

if [ -z "${OUTPUT_DIR}" ]; then
    OUTPUT_DIR=`mktemp -d`
    TMP_DIR=$OUTPUT_DIR
else
    OUTPUT_DIR=${OUTPUT_DIR}
fi

export OUTPUT_DIR=$(realpath $OUTPUT_DIR)
export SRC_DIR=$(realpath $SRC_DIR)

echo "Command is: ${COMMAND}"
echo "Source dir is: ${SRC_DIR}"
echo "Playbook file is: ${SRC_DIR}/${PLAYBOOK}"
echo "Output dir is: ${OUTPUT_DIR}"

export IMAGE_NAME
export BUILDER_VERSION
export COMMAND
export PLAYBOOK
export OUTPUT_DIR
export SRC_DIR

BUILD_NAME=antorabuilder

function finish {
    docker-compose -p ${BUILD_NAME} down -v
    [ ! -z "${TMP_DIR}" ] && rm -rf ${TMP_DIR}
}
trap finish EXIT

cd ${RUNNER_DIR}
docker-compose -p ${BUILD_NAME} up -d
docker-compose -p ${BUILD_NAME} exec -T builder bash /builder/define_user.sh $(id -u) $(id -g)
docker-compose -p ${BUILD_NAME} exec --user builder -T builder \
    /builder/node_modules/.bin/gulp ${COMMAND} --src /builder/src --output /builder/output --playbook /builder/src/${PLAYBOOK} --plantuml-server-url http://plantuml:8080

