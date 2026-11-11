#!/usr/bin/env bash
set -uo pipefail

export PATH="$HOME/.local/state/nix/profiles/home-manager/home-path/bin:$HOME/.nix-profile/bin:$HOME/.local/bin:$HOME/.local/share/pnpm:$HOME/.proto/shims:$HOME/.proto/bin:$HOME/.opencode/bin:$PATH"

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LANGUAGE_SERVERS=(
  lua-language-server
  vscode-html-language-server
  vscode-css-language-server
  vscode-eslint-language-server
  tailwindcss-language-server
  typescript-language-server
  astro-ls
  vue-language-server
  intelephense
  pyright-langserver
  harper-ls
)
AGENT_TOOLS=(claude opencode codegraph herdr no-mistakes treehouse agy gh-axi chrome-devtools-axi lavish-axi quota-axi tasks-axi)

failures=0

check() {
  local description="$1"
  shift
  if "$@" >/dev/null 2>&1; then
    printf 'ok    %s\n' "$description"
  else
    printf 'FAIL  %s\n' "$description"
    failures=$((failures + 1))
  fi
}

nvim_is_nightly() {
  local version
  version="$(nvim --version)"
  case "$version" in *nightly* | *-dev*) return 0 ;; *) return 1 ;; esac
}

font_is_installed() {
  local fonts_dir="$HOME/.local/state/nix/profiles/home-manager/home-path/share/fonts"
  [ "$(uname -s)" = Darwin ] && fonts_dir="$HOME/Library/Fonts"
  [ -n "$(find -L "$fonts_dir" -name 'JetBrainsMonoNerdFont-*.ttf' -print -quit 2>/dev/null)" ]
}

config_is_linked() {
  local path="$1" resolved
  resolved="$(readlink -f "$path")"
  case "$resolved" in "$DOTFILES_DIR"/*) return 0 ;; *) return 1 ;; esac
}

node_comes_from_proto() {
  case "$(command -v node)" in "$HOME"/.proto/*) return 0 ;; *) return 1 ;; esac
}

check "nix" command -v nix
check "nvim is a nightly build" nvim_is_nightly
check "nerd font" font_is_installed
check "node comes from proto" node_comes_from_proto
check "pnpm" command -v pnpm
check "docker" command -v docker
check "nvim config is linked" config_is_linked "$HOME/.config/nvim/init.lua"
check "claude settings are linked" config_is_linked "$HOME/.claude/settings.json"
check "AGENTS.md is linked" config_is_linked "$HOME/AGENTS.md"
check "claude plugins installed" test -s "$HOME/.claude/plugins/installed_plugins.json"
check "skills installed" test -d "$HOME/.agents/skills"

for tool in "${LANGUAGE_SERVERS[@]}" "${AGENT_TOOLS[@]}"; do
  check "$tool" command -v "$tool"
done

if [ "$failures" -gt 0 ]; then
  printf '\n%s check(s) failed\n' "$failures"
  exit 1
fi
printf '\nAll checks passed\n'
