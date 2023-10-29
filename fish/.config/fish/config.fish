set fish_greeting ""

set -gx TERM xterm-256color

alias g git
alias ls='ls --color=auto'
alias ll='ls -la'
command -qv nvim && alias vim nvim

set -gx EDITOR nvim
set -gx PATH bin $PATH
set -gx PATH ~/bin $PATH
set -gx PATH ~/.local/bin $PATH
set -gx PATH node_modules/.bin $PATH

# Flutter / Android SDK
set -gx PATH /opt/flutter/bin $PATH
set -x PATH $PATH $HOME/.pub-cache/bin
set -gx PATH /home/grzywn/Android/Sdk/platform-tools $PATH
set -x JAVA_HOME /usr/lib/jvm/default
set -x PATH $PATH $JAVA_HOME/bin
set -x CHROME_EXECUTABLE firefox

eval "$(starship init fish)"

# pnpm
set -gx PNPM_HOME "/home/grzywn/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

set -x PATH "$PATH" "$HOME/flutter/bin"
