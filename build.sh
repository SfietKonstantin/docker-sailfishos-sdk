#!/usr/bin/env bash
set -euo pipefail

SDK_NAME="Jolla-latest-SailfishOS_Platform_SDK_Chroot-i486"

CHROOT_URL="http://releases.sailfishos.org/sdk/installers/latest/${SDK_NAME}.tar.bz2"
TOOLING_URL="http://releases.sailfishos.org/sdk/latest/Jolla-latest-Sailfish_SDK_Tooling-i486.tar.bz2"
TARGET_ARM_URL="http://releases.sailfishos.org/sdk/latest/Jolla-latest-Sailfish_SDK_Target-armv7hl.tar.bz2"
TARGET_486_URL="http://releases.sailfishos.org/sdk/latest/Jolla-latest-Sailfish_SDK_Target-i486.tar.bz2"

EXTRA_PACKAGES="tar"

NAME_TOOLING="SailfishOS-latest"
NAME_ARM_TARGET="SailfishOS-latest-armv7hl"
NAME_486_TARGET="SailfishOS-latest-i486"

if [ ! -f "$SDK_NAME.tar" ]; then
if [ ! -f "$SDK_NAME.tar.bz2" ]; then

# Download the base image
echo "Downloading base image"
curl -s -O "$CHROOT_URL"
echo "Downloading base image: DONE"

fi

echo "Extracting base image"
bzip2 -d "$SDK_NAME.tar.bz2"
echo "Extracting base image: DONE"

fi


# Import it as a docker base image & build the full image
echo "Importing base image"
docker import "$SDK_NAME.tar" sailfishos-platform-sdk-base
echo "Importing base image: DONE"

echo "Building image"
docker build \
    --build-arg local_uid=$(id -u $USER) \
    --build-arg local_gid=$(id -g $USER) \
    --build-arg extra_packages=$EXTRA_PACKAGES \
    --build-arg tooling_url=$TOOLING_URL \
    --build-arg target_arm_url=$TARGET_ARM_URL \
    --build-arg target_486_url=$TARGET_486_URL \
    --build-arg name_tooling=$NAME_TOOLING \
    --build-arg name_arm_target=$NAME_ARM_TARGET \
    --build-arg name_486_target=$NAME_486_TARGET \
    -t sailfishos-platform-sdk .
echo "Building image: DONE"
