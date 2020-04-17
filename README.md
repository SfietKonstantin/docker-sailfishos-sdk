# Scripts to build a Dockerized version of the Sailfish OS platform SDK

[![Build Status](https://travis-ci.org/SfietKonstantin/docker-sailfishos-sdk.svg?branch=master)](https://travis-ci.org/SfietKonstantin/docker-sailfishos-sdk)

## TLDR

1. Run `sudo build.sh`
2. Import image with `docker import sdk.tar sailfishos-platform-sdk`
3. Get a shell with `docker run -it sailfishos-platform-sdk /bin/bash`
4. Enter in Scratchbox with `sb2 -t SailfishOS-latest-armv7hl`

## Summary

The goal of this repository is to package the
[Sailfish OS platform SDK](https://sailfishos.org/wiki/Platform_SDK) as a Docker image.

This image can be used to invoke all the command-line tools shipped in the SDK. It is not really
a replacement of Jolla's VM based SDK, as the image has no integration with Qt Creator, nor can
it deploy automatically to the emulator.

Instead this image can be used when automation are needed, for instance in CI. However, you can 
still use it in your daily developement workflow by invoking the tools and the deployment steps 
manually.

This repository contains one script, `build.sh`, that will

1. Download the latest version of the SDK
2. Uncompress the content of the SDK
3. Download the latest `armv7hl` and `i486` rootfs and install them
4. Compress the content of the SDK for import in Docker

As a result, you will be able to create an image that will be ready to use to build for both phones, 
tablet and the emulator.


## Build

You must also be connected to the Internet in order to build the image.

You must have installed p7zip and curl.

1. Check out the project

```git clone https://github.com/SfietKonstantin/docker-sailfishos-sdk.git```

2. Place yourself in the root of the checked project

```cd docker-sailfishos-sdk```

3. Run the build script

You will need root access, as the script updates system files of a rootfs.

```sudo build.sh```

The build script will download some archives in the same folder as the source code.
It will then work in `sdkroot`. It will bind-mount some folders in this folder to 
prepare a chroot environment. Finally, it will produce a tarball named `sdk.tar`.

Don't hesitate to clean the tarballs and `sdkroot` folder after running the script.

4. Import the image in docker

```docker import sdk.tar sailfishos-platform-sdk```

## Update

The script will download the latest version of the SDK and targets. To update the image in a newer
SDK version, simply rerun `build.sh`

## Credits

- [EvilJazz](https://github.com/evilJazz/sailfishos-buildengine) for the inspiration

