#!/usr/bin/env bash
set -euo pipefail

APT_PACKAGES=(
  arandr
  docker-buildx
  docker-compose-v2
  docker.io
  firefox
  flameshot
  flatpak
  gimp
)
FLATPAKS=(
  com.axosoft.GitKraken
  com.spotify.Client
  org.chromium.Chromium
)

sudo apt-get update
sudo apt-get install -y "${APT_PACKAGES[@]}"

sudo systemctl enable --now docker 2>/dev/null || true
sudo usermod -aG docker "$(id -un)"

sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
sudo flatpak install -y --noninteractive flathub "${FLATPAKS[@]}"
