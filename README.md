# Scripts to build a Dockerized version of the Sailfish OS platform SDK

[![Build Status](https://travis-ci.org/SfietKonstantin/docker-sailfishos-sdk.svg?branch=master)](https://travis-ci.org/SfietKonstantin/docker-sailfishos-sdk)

## TLDR

1. Run `build.sh`
2. Image tagged `sailfishos-platform-sdk` will be generated
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
2. Create a base image from it
3. Download the latest `armv7hl` and `i486` rootfs and install them

As a result, you will get an image that will be ready to use to build for both phones, tablet and
the emulator.

This script tags two images

- `sailfishos-platform-sdk-base` contains the SDK, without any installed target
- `sailfishos-platform-sdk` contains the SDK and installed targets for `armv7hl` and `i486`

## Build

You must have Docker installed and started.

You must also be connected to the Internet in order to build the image.

1. Check out the project

```git clone https://github.com/SfietKonstantin/docker-sailfishos-sdk.git```

2. Place yourself in the root of the checked project

```cd docker-sailfishos-sdk```

3. Run the build script

```./build.sh```

## Update

The script will download the latest version of the SDK and targets. To update the image in a newer
SDK version, simply rerun `build.sh`

## Credits

- [EvilJazz](https://github.com/evilJazz/sailfishos-buildengine) for the inspiration

