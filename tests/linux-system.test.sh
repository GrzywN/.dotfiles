#!/usr/bin/env bash
set -euo pipefail

SCRIPT="${LINUX_SYSTEM_SCRIPT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/setup/linux-system.sh}"
WORKDIR="$(mktemp -d)"
trap 'rm -rf "$WORKDIR"' EXIT

USER_NAME="$(id -un)"
FAILURES=0

create_stub() {
  local stubs="$1" name="$2"
  printf '#!/usr/bin/env bash\nprintf "%%s %%s\\n" "${0##*/}" "$*" >> "$CALL_LOG"\n' > "$stubs/$name"
  chmod +x "$stubs/$name"
}

run_with_stubs() {
  local docker_installed="$1" case_dir="$WORKDIR/$2"
  local stubs="$case_dir/bin"
  mkdir -p "$stubs"
  : > "$case_dir/calls.log"
  ln -s "$(command -v bash)" "$stubs/bash"
  ln -s "$(command -v id)" "$stubs/id"
  printf '#!/usr/bin/env bash\nexec "$@"\n' > "$stubs/sudo"
  chmod +x "$stubs/sudo"
  for name in apt-get systemctl usermod flatpak getent; do
    create_stub "$stubs" "$name"
  done
  [ "$docker_installed" = yes ] && create_stub "$stubs" docker
  CALL_LOG="$case_dir/calls.log" PATH="$stubs" "$BASH" "$SCRIPT" >/dev/null
  cat "$case_dir/calls.log"
}

assert_calls() {
  local description="$1" expected="$2" actual="$3"
  if [ "$actual" = "$expected" ]; then
    printf 'ok    %s\n' "$description"
  else
    printf 'FAIL  %s\n--- expected\n%s\n--- actual\n%s\n' "$description" "$expected" "$actual"
    FAILURES=$((FAILURES + 1))
  fi
}

DESKTOP_INSTALL="apt-get install -y arandr firefox flameshot flatpak gimp"
DOCKER_INSTALL="apt-get install -y docker-buildx docker-compose-v2 docker.io"
DOCKER_SERVICE="systemctl enable --now docker"
GROUP_CHECK="getent group docker"
GROUP_JOIN="usermod -aG docker $USER_NAME"
FLATHUB_REMOTE="flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo"
FLATPAK_INSTALL="flatpak install -y --noninteractive flathub com.axosoft.GitKraken com.spotify.Client org.chromium.Chromium"

EXPECTED_WITH_DOCKER="apt-get update
$DESKTOP_INSTALL
$GROUP_CHECK
$GROUP_JOIN
$FLATHUB_REMOTE
$FLATPAK_INSTALL"

EXPECTED_WITHOUT_DOCKER="apt-get update
$DESKTOP_INSTALL
$DOCKER_INSTALL
$DOCKER_SERVICE
$GROUP_CHECK
$GROUP_JOIN
$FLATHUB_REMOTE
$FLATPAK_INSTALL"

assert_calls "keeps an existing Docker install untouched" \
  "$EXPECTED_WITH_DOCKER" "$(run_with_stubs yes with-docker)"
assert_calls "installs Docker when it is missing" \
  "$EXPECTED_WITHOUT_DOCKER" "$(run_with_stubs no without-docker)"

[ "$FAILURES" -eq 0 ]
