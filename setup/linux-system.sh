#!/usr/bin/env bash
set -euo pipefail

DESKTOP_APT_PACKAGES=(
  arandr
  firefox
  flameshot
  flatpak
  gimp
)
DOCKER_APT_PACKAGES=(
  docker-buildx
  docker-compose-v2
  docker.io
)
FLATPAKS=(
  com.axosoft.GitKraken
  com.spotify.Client
  org.chromium.Chromium
)

install_docker() {
  command -v docker >/dev/null && return
  sudo apt-get install -y "${DOCKER_APT_PACKAGES[@]}"
  sudo systemctl enable --now docker 2>/dev/null || true
}

allow_docker_without_sudo() {
  getent group docker >/dev/null || return 0
  sudo usermod -aG docker "$(id -un)"
}

sudo apt-get update
sudo apt-get install -y "${DESKTOP_APT_PACKAGES[@]}"
install_docker
allow_docker_without_sudo

sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
sudo flatpak install -y --noninteractive flathub "${FLATPAKS[@]}"
