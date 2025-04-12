#!/bin/bash
set -e

printf "==========================\n"
printf "=== Arch Linux Setup ===\n"
printf "==========================\n"

sudo pacman -Syu --noconfirm
sudo pacman -S --needed --noconfirm \
  base-devel git clang cmake \
  mesa glew harfbuzz freetype2 glm \
  ffmpeg portaudio rtmidi \
  libx11 libxext libxrandr libxcursor libxi libxinerama \
  sdl3

printf "==========================\n"
printf "Installation Complete\n"
printf "==========================\n"
