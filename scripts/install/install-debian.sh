#!/bin/bash


# this script is not tested

set -e

printf "==========================\n"
printf "=== Debian/Ubuntu Setup ===\n"
printf "==========================\n"

sudo apt-get update -qq
sudo apt-get full-upgrade -y -qq

sudo apt-get install -y -qq \
  git clang cmake pkg-config mesa-utils \
  libglew-dev libharfbuzz-dev libfreetype6-dev libglm-dev \
  ffmpeg libavcodec-dev libavformat-dev libavutil-dev libswscale-dev libavdevice-dev \
  librtmidi-dev portaudio19-dev \
  libx11-dev libxext-dev libxrandr-dev libxcursor-dev libxi-dev libxinerama-dev


TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"
git clone --depth=1 --branch SDL3 https://github.com/libsdl-org/SDL
cd SDL
mkdir build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j$(nproc)
sudo make install
cd && rm -rf "$TMP_DIR"

printf "==========================\n"
printf "Installation Complete\n"
printf "==========================\n"
