#!/bin/bash

# This script assumes $PWD is the same dir in which this script is located

# Helps avoid permissions problems with `jenkins` user in docker container when
# making a local packaged build
git clean -dfx

docker run -it --rm \
  --cap-add SYS_ADMIN \
  --security-opt apparmor:unconfined \
  --device /dev/fuse \
  -u jenkins:$(getent group $(whoami) | cut -d: -f3) \
  -v "${PWD}:/status-desktop" \
  -v ${PWD}/../status-desktop-build:/home/jenkins:rw \
  -w /status-desktop \
  statusteam/nim-status-client-build:1.2.1-qt5.15.2 \
  ./docker-linux-app-image.sh


# Build with custom Qt
# https://timmousk.com/blog/git-reset-submodule/
# git submodule update --init --recursive
# mkdir build && cd build && cmake -DCMAKE_PREFIX_PATH="~/usr/Qt/6.5.3/macos/lib/cmake" ../
# set(STATUS_QT_VERSION 6.5.3)

