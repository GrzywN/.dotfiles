#!/usr/bin/env bash
set -euo pipefail

DOTFILES_REPO_URL="${DOTFILES_REPO_URL:-https://github.com/GrzywN/.dotfiles.git}"
DOTFILES_REF="${DOTFILES_REF:-main}"
DOTFILES_NONINTERACTIVE="${DOTFILES_NONINTERACTIVE:-0}"
DOTFILES_SSH_KEY_VAULT="${DOTFILES_SSH_KEY_VAULT:-}"
DOTFILES_VAULT_PASSWORD_FILE="${DOTFILES_VAULT_PASSWORD_FILE:-}"
NIX_INSTALLER_VERSION="2.31.2"
NIX_COMMUNITY_CACHE="https://nix-community.cachix.org"
NIX_COMMUNITY_CACHE_KEY="nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
SSH_KEY_PATH="$HOME/.ssh/id_ed25519"
OS="$(uname -s)"
PROMPTED_PASSWORD_FILE=""
RUNS_FROM_CHECKOUT=0

log() { printf '\n==> %s\n' "$*"; }
fail() { printf 'error: %s\n' "$*" >&2; exit 1; }

locate_dotfiles() {
  local script_dir=""
  if [ -n "${BASH_SOURCE[0]:-}" ]; then
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd || true)"
  fi
  if [ -n "$script_dir" ] && [ -f "$script_dir/flake.nix" ]; then
    DOTFILES_DIR="$script_dir"
    RUNS_FROM_CHECKOUT=1
  else
    DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
  fi
}

ask_everything_upfront() {
  if [ "$DOTFILES_NONINTERACTIVE" = 1 ]; then
    return
  fi
  { : </dev/tty; } 2>/dev/null || fail "no terminal for prompts - set DOTFILES_NONINTERACTIVE=1 to run unattended"
  log "Asking for everything up front, then the rest runs unattended"
  sudo -v
  while kill -0 "$$" 2>/dev/null; do sudo -n true; sleep 50; done 2>/dev/null &
  if [ -z "$DOTFILES_VAULT_PASSWORD_FILE" ] && [ ! -f "$SSH_KEY_PATH" ]; then
    local vault_password
    PROMPTED_PASSWORD_FILE="$(umask 077 && mktemp)"
    trap "rm -f '$PROMPTED_PASSWORD_FILE'" EXIT
    read -rsp "Ansible Vault password (for the SSH key): " vault_password </dev/tty
    printf '\n'
    printf '%s' "$vault_password" > "$PROMPTED_PASSWORD_FILE"
    DOTFILES_VAULT_PASSWORD_FILE="$PROMPTED_PASSWORD_FILE"
  fi
}

ensure_git() {
  case "$OS" in
    Linux) command -v git >/dev/null || { sudo apt-get update && sudo apt-get install -y git; } ;;
    Darwin) xcode-select -p >/dev/null 2>&1 || fail "Command Line Tools missing - run 'xcode-select --install', then run this script again" ;;
    *) fail "unsupported OS: $OS" ;;
  esac
}

update_existing_checkout() {
  local repo=(git -C "$DOTFILES_DIR")
  log "Updating $DOTFILES_DIR to $DOTFILES_REF"
  [ -z "$("${repo[@]}" status --porcelain --untracked-files=no)" ] \
    || fail "$DOTFILES_DIR has uncommitted changes - commit, stash or move it, then run this script again"
  "${repo[@]}" fetch --tags origin
  if "${repo[@]}" show-ref --verify --quiet "refs/remotes/origin/$DOTFILES_REF"; then
    "${repo[@]}" checkout "$DOTFILES_REF"
    "${repo[@]}" merge --ff-only "origin/$DOTFILES_REF"
  else
    "${repo[@]}" checkout --detach "$DOTFILES_REF"
  fi
}

fetch_dotfiles() {
  [ "$RUNS_FROM_CHECKOUT" = 1 ] && return
  if [ -d "$DOTFILES_DIR/.git" ]; then
    update_existing_checkout
    return
  fi
  log "Cloning $DOTFILES_REPO_URL ($DOTFILES_REF)"
  git clone --branch "$DOTFILES_REF" "$DOTFILES_REPO_URL" "$DOTFILES_DIR"
}

nix_runs_as_daemon() {
  [ "$OS" = Darwin ] || [ -d /run/systemd/system ]
}

load_nix_profile() {
  local profile
  set +u
  for profile in /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh "$HOME/.nix-profile/etc/profile.d/nix.sh"; do
    # shellcheck disable=SC1090
    [ -f "$profile" ] && . "$profile"
  done
  set -u
}

install_nix() {
  load_nix_profile
  command -v nix >/dev/null && return
  log "Installing Nix $NIX_INSTALLER_VERSION"
  local mode=--no-daemon
  nix_runs_as_daemon && mode=--daemon
  curl --proto '=https' --tlsv1.2 -fsSL "https://releases.nixos.org/nix/nix-$NIX_INSTALLER_VERSION/install" \
    | sh -s -- "$mode" --yes
  load_nix_profile
}

trust_community_cache() {
  local conf=/etc/nix/nix.conf
  nix_runs_as_daemon || return 0
  grep -qF "$NIX_COMMUNITY_CACHE" "$conf" 2>/dev/null && return 0
  log "Trusting the nix-community binary cache (nightly Neovim is not built from source)"
  printf 'extra-trusted-substituters = %s\nextra-trusted-public-keys = %s\n' \
    "$NIX_COMMUNITY_CACHE" "$NIX_COMMUNITY_CACHE_KEY" | sudo tee -a "$conf" >/dev/null
  if [ "$OS" = Darwin ]; then
    sudo launchctl kickstart -k system/org.nixos.nix-daemon
  else
    sudo systemctl restart nix-daemon
  fi
}

activate_home() {
  log "Building and activating the Nix home configuration"
  export NIX_CONFIG=$'experimental-features = nix-command flakes\naccept-flake-config = true'
  local out_link
  out_link="$(mktemp -d)/home"
  nix build --impure --out-link "$out_link" "$DOTFILES_DIR#homeConfigurations.default.activationPackage"
  HOME_MANAGER_BACKUP_EXT=pre-dotfiles "$out_link/activate"
  export PATH="$out_link/home-path/bin:$PATH"
}

install_linux_system_packages() {
  [ "$OS" = Linux ] || return 0
  log "Installing Docker, desktop apps and flatpaks"
  "$DOTFILES_DIR/setup/linux-system.sh"
}

install_ssh_key() {
  [ -f "$SSH_KEY_PATH" ] && return 0
  local vault="${DOTFILES_SSH_KEY_VAULT:-$DOTFILES_DIR/secrets/id_ed25519.vault}"
  [ -f "$vault" ] || return 0
  [ -n "$DOTFILES_VAULT_PASSWORD_FILE" ] || fail "vault password missing - set DOTFILES_VAULT_PASSWORD_FILE"
  log "Decrypting the SSH key"
  mkdir -p "$HOME/.ssh" && chmod 700 "$HOME/.ssh"
  ansible-vault decrypt --vault-password-file "$DOTFILES_VAULT_PASSWORD_FILE" --output "$SSH_KEY_PATH" "$vault"
  chmod 600 "$SSH_KEY_PATH"
  ssh-keygen -y -f "$SSH_KEY_PATH" > "$SSH_KEY_PATH.pub"
}

unused_backup_path() {
  local backup="$1.pre-dotfiles" counter=1
  while [ -e "$backup" ] || [ -L "$backup" ]; do
    backup="$1.pre-dotfiles.$counter"
    counter=$((counter + 1))
  done
  printf '%s' "$backup"
}

move_aside_conflicting_files() {
  local dotfiles_root package source target
  dotfiles_root="$(cd "$DOTFILES_DIR" && pwd -P)"
  while IFS= read -r package; do
    while IFS= read -r -d '' source; do
      target="$HOME/${source#"$DOTFILES_DIR/$package/"}"
      [ -e "$target" ] || [ -L "$target" ] || continue
      case "$(readlink -f "$target" || true)" in
        "$dotfiles_root"/*) ;;
        *) mv "$target" "$(unused_backup_path "$target")" ;;
      esac
    done < <(find "$DOTFILES_DIR/$package" \( -type f -o -type l \) -print0)
  done < <(make -s -C "$DOTFILES_DIR" --no-print-directory list)
}

link_configs() {
  log "Linking configs with stow"
  move_aside_conflicting_files
  make -C "$DOTFILES_DIR" stow
}

install_runtimes_and_agents() {
  log "Installing Node and pnpm with proto"
  proto install
  export PATH="$HOME/.proto/shims:$HOME/.proto/bin:$PATH"
  log "Installing agent tools"
  "$DOTFILES_DIR/setup/agents.sh"
  export PATH="$HOME/.local/bin:$HOME/.opencode/bin:$PATH"
  log "Installing Claude Code plugins and skills"
  make -C "$DOTFILES_DIR" plugins skills
}

prepare_neovim() {
  log "Installing Neovim plugins and parsers"
  nvim --headless +qa
  nvim --headless "+lua require('nvim-treesitter').install(vim.g.treesitter_parsers):wait(600000)" +qa
}

print_manual_steps() {
  cat <<'EOF'

Done. Still manual (cannot be automated):
  claude        sign in
  gh auth login
  codex / opencode / agy sign in, if you use them
Open a new terminal to load the shell config, then run: make doctor
EOF
}

main() {
  export USER="${USER:-$(id -un)}"
  locate_dotfiles
  ask_everything_upfront
  ensure_git
  fetch_dotfiles
  install_nix
  trust_community_cache
  activate_home
  install_linux_system_packages
  install_ssh_key
  link_configs
  install_runtimes_and_agents
  prepare_neovim
  print_manual_steps
}

main "$@"
