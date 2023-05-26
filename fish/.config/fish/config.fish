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

eval "$(starship init fish)"

# pnpm
set -gx PNPM_HOME "/home/grzywn/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end