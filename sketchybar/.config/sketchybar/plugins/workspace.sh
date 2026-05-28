#!/usr/bin/env sh
# Called for every workspace item on aerospace_workspace_change.
# sketchybar passes FOCUSED_WORKSPACE as an env var.
# $NAME is the item name (e.g. "space.3"), strip prefix to get workspace id.
WS="${NAME#space.}"

if [ "$WS" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set "$NAME" label.color=0xff1e1e2e background.color=0xffb4befe background.drawing=on
else
  sketchybar --set "$NAME" label.color=0xff6c7086 background.drawing=off
fi
