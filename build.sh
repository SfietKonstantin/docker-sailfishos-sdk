#!/usr/bin/env bash
set -euo pipefail

download() {
    echo "Downloading $1/$2.$3"
    rm -f $2.tar $2.$3
    curl -s -O "http://releases.sailfishos.org/$1/$2.$3"
    echo "Downloading $1/$2.$3: DONE"
    
}

prepare_tar() {
    echo "Preparing $1.tar"

    # Remove files that cannot be created in a rootless container
    tar -f "$1.tar" \
        --delete ./dev/full \
        --delete ./dev/null \
        --delete ./dev/ptmx \
        --delete ./dev/random \
        --delete ./dev/urandom \
        --delete ./dev/tty \
        --delete ./dev/zero
    echo "Preparing $1.tar: DONE"
}

prepare_sdk() {
    download $1 $2 "tar.bz2"
    bzip2 -d $2.tar.bz2
    prepare_tar $2
}

prepare_target() {
    download $1 $2 "tar.7z"
    7z x $2.tar.7z
    rm $2.tar.7z
    mv $3.tar $2.tar
    prepare_tar $2
}


SDK_PATH="sdk/installers/latest"
SDK_NAME="Jolla-latest-SailfishOS_Platform_SDK_Chroot-i486"
TARGET_PATH="sdk/targets"
TOOLING_NAME="Sailfish_OS-latest-Sailfish_SDK_Tooling-i486"
TOOLING_PATTERN="Sailfish_OS-*-Sailfish_SDK_Tooling-i486"
ARMV7HL_TARGET_NAME="Sailfish_OS-latest-Sailfish_SDK_Target-armv7hl"
ARMV7HL_TARGET_PATTERN="Sailfish_OS-*-Sailfish_SDK_Target-armv7hl"
I486_TARGET_NAME="Sailfish_OS-latest-Sailfish_SDK_Target-i486"
I486_TARGET_PATTERN="Sailfish_OS-*-Sailfish_SDK_Target-i486"

# Download the base image
prepare_sdk $SDK_PATH $SDK_NAME

echo "Creating SDK root"
rm -rf sdkroot && mkdir -p sdkroot
tar -xf $SDK_NAME.tar -C sdkroot
echo "Creating SDK root: DONE"

# Downloading tooling and targets
cd sdkroot
prepare_target $TARGET_PATH $TOOLING_NAME $TOOLING_PATTERN
prepare_target $TARGET_PATH $ARMV7HL_TARGET_NAME $ARMV7HL_TARGET_PATTERN
prepare_target $TARGET_PATH $I486_TARGET_NAME $I486_TARGET_PATTERN

# Prepare the chroot
echo "Preparing chroot"
echo "nemo ALL=(ALL) NOPASSWD:ALL" >> etc/sudoers
rm etc/resolv.conf && cp /etc/resolv.conf etc/resolv.conf
mount -t proc proc proc/
mount --rbind /dev dev/
mount --rbind /sys sys/
echo "Preparing chroot: DONE"

# Install rootfs
echo "Installing SDK"
chroot . su nemo -c "sdk-assistant -y create SailfishOS-latest $TOOLING_NAME.tar"
chroot . su nemo -c "sdk-assistant -y create SailfishOS-latest-armv7hl $ARMV7HL_TARGET_NAME.tar"
chroot . su nemo -c "sdk-assistant -y create SailfishOS-latest-i486 $I486_TARGET_NAME.tar"
echo "Installing SDK: DONE"

rm $TOOLING_NAME.tar $ARMV7HL_TARGET_NAME.tar $I486_TARGET_NAME.tar

umount proc/
umount -l dev/
umount -l sys/

# Compress
tar -cf ../sdk.tar .
