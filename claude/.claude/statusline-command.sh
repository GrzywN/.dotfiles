#!/bin/bash
# Claude Code statusline — user@host dir [git-branch] + caveman badge
# Based on Starship default prompt style.

input=$(cat)

# Directory from Claude context
cwd=$(printf '%s' "$input" | jq -r '.workspace.current_dir // .cwd // empty')
[ -z "$cwd" ] && cwd=$(pwd)
dir=$(basename "$cwd")

# User and host
user=$(whoami)
host=$(hostname -s)

# Git branch — use -c core.hooksPath=/dev/null to skip optional locks
branch=$(git -C "$cwd" --no-optional-locks rev-parse --abbrev-ref HEAD 2>/dev/null)

# Model display name
model=$(printf '%s' "$input" | jq -r '.model.display_name // empty')

# Context remaining percentage
remaining=$(printf '%s' "$input" | jq -r '.context_window.remaining_percentage // empty')

# Build the line
# Colors: cyan=user@host, yellow=dir, magenta=branch, dim-white=model, blue=context
printf '\033[36m%s@%s\033[0m ' "$user" "$host"
printf '\033[33m%s\033[0m' "$dir"

if [ -n "$branch" ]; then
  printf ' \033[35m(%s)\033[0m' "$branch"
fi

if [ -n "$model" ]; then
  printf ' \033[2m%s\033[0m' "$model"
fi

if [ -n "$remaining" ]; then
  printf ' \033[34mctx:%s%%\033[0m' "$(printf '%.0f' "$remaining")"
fi

# Append caveman badge if active
caveman_out=$(bash "/home/user/.claude/hooks/caveman-statusline.sh" 2>/dev/null)
[ -n "$caveman_out" ] && printf ' %s' "$caveman_out"
