# Fish config
set fish_greeting ""
set -gx TERM xterm-256color

# Aliases
alias ls='ls --color=auto'
alias ll='ls -la'
alias todo='nvim ~/todo.md'

command -qv nvim && alias vim nvim

# Neovim
set -gx EDITOR nvim

# Binaries and scripts
set -gx PATH bin $PATH
set -gx PATH ~/bin $PATH
set -gx PATH ~/.local/bin $PATH

# NVM
set --universal nvm_default_version v20.12.2
set --universal nvm_default_packages yarn

# PNPM
set -gx PNPM_HOME "/home/grzywn/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end

# Flutter / Android SDK

## Exposes flutter and dart binaries
set -gx PATH $HOME/sdks/flutter/bin $PATH

## Exposes cached dart and dartaotruntime binaries
set -gx PATH $HOME/sdks/flutter/bin/cache/dart-sdk/bin $PATH

## Exposes adb, fastboot and other platform-tools binaries
set -gx PATH $HOME/sdks/Android/Sdk/platform-tools $PATH

# Fly.io
set -x FLYCTL_INSTALL "/home/grzywn/.fly"
set -gx PATH $FLYCTL_INSTALL/bin $PATH
set -x PATH "$PATH" "$HOME/flutter/bin"

starship init fish | source
zoxide init fish --cmd="cd" | source
