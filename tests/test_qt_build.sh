#!/usr/bin/env bash
set -euo pipefail

echo "Preparing workspace"
mkdir -p ${HOME}/workspace/armv7hl
mkdir -p ${HOME}/workspace/i486
cd ${HOME}/tests
cp * ${HOME}/workspace/armv7hl
cp * ${HOME}/workspace/i486
echo "Preparing workspace: DONE"

echo "Building for armv7hl"
cd ${HOME}/workspace/armv7hl
sb2 -t SailfishOS-latest-armv7hl qmake
sb2 -t SailfishOS-latest-armv7hl make
sb2 -t SailfishOS-latest-armv7hl ./test
echo "Building for armv7hl: DONE"

echo "Building for i486"
cd ${HOME}/workspace/i486
sb2 -t SailfishOS-latest-i486 qmake
sb2 -t SailfishOS-latest-i486 make
sb2 -t SailfishOS-latest-i486 ./test
echo "Building for i486: DONE"
