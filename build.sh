#!/usr/bin/env bash
set -euo pipefail

SDK_NAME="Jolla-latest-SailfishOS_Platform_SDK_Chroot-i486"

# Download the base image
echo "Downloading base image"
curl -s -O "http://releases.sailfishos.org/sdk/installers/latest/${SDK_NAME}.tar.bz2"
echo "Downloading base image: DONE"

echo "Extracting base image"
bzip2 -d "${SDK_NAME}.tar.bz2"
echo "Extracting base image: DONE"

# Import it as a docker base image & build the full image
echo "Importing base image"
docker import "${SDK_NAME}.tar" sailfishos-platform-sdk-base
echo "Importing base image: DONE"

echo "Building image"
docker build -t sailfishos-platform-sdk .
echo "Building image: DONE"
