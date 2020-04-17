#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
TESTS_DIR="${SCRIPT_DIR}/tests"
CONTAINER_TESTS_DIR=/tmp/tests

docker run \
    --rm \
    -u nemo \
    -v=${TESTS_DIR}:${CONTAINER_TESTS_DIR} \
    sailfishos-platform-sdk \
    ${CONTAINER_TESTS_DIR}/test_qt_build.sh
