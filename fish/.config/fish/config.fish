# Fish config
set fish_greeting ""
set -gx TERM xterm-256color

# Aliases
alias ls='ls --color=auto'
alias ll='ls -la'
command -qv nvim && alias vim nvim
command -qv nvim ~/todo.md && alias todo

# Neovim
set -gx EDITOR nvim

# Binaries and scripts
set -gx PATH bin $PATH
set -gx PATH ~/bin $PATH
set -gx PATH ~/.local/bin $PATH

# PNPM
set -gx PNPM_HOME "/home/grzywn/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end

# Flutter / Android SDK
set -gx PATH /opt/flutter/bin $PATH
set -x PATH $PATH $HOME/.pub-cache/bin
set -gx PATH /home/grzywn/Android/Sdk/platform-tools $PATH
set -x JAVA_HOME /usr/lib/jvm/default
set -x PATH $PATH $JAVA_HOME/bin
set -x PATH "$PATH" "$HOME/flutter/bin"
set -x CHROME_EXECUTABLE firefox

# Fly.io
set -x FLYCTL_INSTALL "/home/grzywn/.fly"
set -gx PATH $FLYCTL_INSTALL/bin $PATH
set -x PATH "$PATH" "$HOME/flutter/bin"

starship init fish | source
