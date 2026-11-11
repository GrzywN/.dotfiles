#!/usr/bin/env bash
set -euo pipefail

CLAUDE_VERSION="2.1.322"
OPENCODE_VERSION="1.18.4"
CODEGRAPH_VERSION="v1.6.2"
HERDR_VERSION="v0.9.5"
NO_MISTAKES_VERSION="v1.106.1"
TREEHOUSE_VERSION="v3.1.8"
NPM_AGENT_TOOLS=(
  chrome-devtools-axi@0.1.39
  gh-axi@0.1.35
  lavish-axi@0.1.82
  quota-axi@0.1.58
  tasks-axi@0.2.4
  acpx@0.15.0
)

BIN_DIR="$HOME/.local/bin"

log() { printf '  -> %s\n' "$*"; }
fail() { printf 'error: %s\n' "$*" >&2; exit 1; }

detect_platform() {
  case "$(uname -s)-$(uname -m)" in
    Linux-x86_64)
      HERDR_ASSET="herdr-linux-x86_64"
      HERDR_SHA256="14d9e8bc8b4a9e0118d77c32266f76d461f09b40342eb23752960bd89f59929d"
      NO_MISTAKES_ASSET="no-mistakes-$NO_MISTAKES_VERSION-linux-amd64.tar.gz"
      NO_MISTAKES_SHA256="fbf131356a278623a509b6b50ecb39c5375b1a82e7dcfc48e42d10e761416d1e"
      TREEHOUSE_ASSET="treehouse-$TREEHOUSE_VERSION-linux-amd64.tar.gz"
      TREEHOUSE_SHA256="bd6227d909ba8046263ae5d4e072ccbcf43010cac9d7289b1262126510edfeed"
      ;;
    Darwin-arm64)
      HERDR_ASSET="herdr-macos-aarch64"
      HERDR_SHA256="fb77c2232a05a8035421382c894392f4174e4e38a18e48af3dd0290157c3a7e2"
      NO_MISTAKES_ASSET="no-mistakes-$NO_MISTAKES_VERSION-darwin-arm64.tar.gz"
      NO_MISTAKES_SHA256="3105ae3ffd9f5f6dc27674302dcd126a89ba9c23d43ecb8be5e266ac52f1472c"
      TREEHOUSE_ASSET="treehouse-$TREEHOUSE_VERSION-darwin-arm64.tar.gz"
      TREEHOUSE_SHA256="007c55c26e0bd8b672b1a917465f06c3f89d93a66cd171364ffb65743d268601"
      ;;
    *) fail "unsupported platform: $(uname -s)-$(uname -m)" ;;
  esac
}

sha256_of() {
  if command -v sha256sum >/dev/null; then
    sha256sum "$1" | cut -d' ' -f1
  else
    shasum -a 256 "$1" | cut -d' ' -f1
  fi
}

download_verified() {
  local url="$1" expected="$2" destination="$3"
  curl --proto '=https' --tlsv1.2 -fsSL "$url" -o "$destination"
  [ "$(sha256_of "$destination")" = "$expected" ] || fail "checksum mismatch for $url"
}

has_version() {
  local command_name="$1" version="$2"
  command -v "$command_name" >/dev/null && "$command_name" --version 2>&1 | grep -qF "$version"
}

install_claude() {
  has_version claude "$CLAUDE_VERSION" && return 0
  log "claude $CLAUDE_VERSION"
  curl -fsSL https://claude.ai/install.sh | bash -s "$CLAUDE_VERSION"
}

install_opencode() {
  has_version opencode "$OPENCODE_VERSION" && return 0
  log "opencode $OPENCODE_VERSION"
  curl -fsSL https://opencode.ai/install | bash -s -- --version "$OPENCODE_VERSION" --no-modify-path
}

install_codegraph() {
  has_version codegraph "${CODEGRAPH_VERSION#v}" && return 0
  log "codegraph $CODEGRAPH_VERSION"
  curl -fsSL https://raw.githubusercontent.com/colbymchenry/codegraph/main/install.sh \
    | CODEGRAPH_VERSION="$CODEGRAPH_VERSION" bash
}

install_herdr() {
  has_version herdr "${HERDR_VERSION#v}" && return 0
  log "herdr $HERDR_VERSION"
  local url="https://github.com/herdrdev/herdr/releases/download/$HERDR_VERSION/$HERDR_ASSET"
  download_verified "$url" "$HERDR_SHA256" "$BIN_DIR/herdr"
  chmod +x "$BIN_DIR/herdr"
}

install_release_tarball() {
  local name="$1" version="$2" asset="$3" sha256="$4" repository="$5"
  has_version "$name" "${version#v}" && return 0
  log "$name $version"
  local workdir
  workdir="$(mktemp -d)"
  download_verified "https://github.com/$repository/releases/download/$version/$asset" "$sha256" "$workdir/$asset"
  tar -xzf "$workdir/$asset" -C "$workdir" "$name"
  install -m 755 "$workdir/$name" "$BIN_DIR/$name"
  rm -rf "$workdir"
}

install_antigravity() {
  command -v agy >/dev/null && return 0
  log "agy (Google ships no version pin)"
  curl -fsSL https://antigravity.google/cli/install.sh | bash
}

install_node_based_tools() {
  export PNPM_HOME="${PNPM_HOME:-$HOME/.local/share/pnpm}"
  mkdir -p "$PNPM_HOME"
  export PATH="$PNPM_HOME:$PATH"
  log "pnpm global: ${NPM_AGENT_TOOLS[*]}"
  pnpm add --global "${NPM_AGENT_TOOLS[@]}"
}

main() {
  detect_platform
  mkdir -p "$BIN_DIR"
  export PATH="$BIN_DIR:$HOME/.opencode/bin:$PATH"
  install_claude
  install_opencode
  install_codegraph
  install_herdr
  install_release_tarball no-mistakes "$NO_MISTAKES_VERSION" "$NO_MISTAKES_ASSET" "$NO_MISTAKES_SHA256" kunchenguid/no-mistakes
  install_release_tarball treehouse "$TREEHOUSE_VERSION" "$TREEHOUSE_ASSET" "$TREEHOUSE_SHA256" kunchenguid/treehouse
  install_antigravity
  install_node_based_tools
}

main "$@"
