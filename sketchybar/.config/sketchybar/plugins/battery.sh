#!/usr/bin/env sh
PERCENT=$(pmset -g batt | grep -Eo "[0-9]+%" | head -1 | tr -d "%")
CHARGING=$(pmset -g batt | grep -c "AC Power")

if [ "$CHARGING" -gt 0 ]; then
  ICON=""; COLOR=0xffa6e3a1
elif [ "${PERCENT:-100}" -le 20 ]; then
  ICON="󰂃"; COLOR=0xfff38ba8
elif [ "${PERCENT:-100}" -le 50 ]; then
  ICON="󰁼"; COLOR=0xfffab387
else
  ICON="󰁹"; COLOR=0xffa6e3a1
fi

sketchybar --set battery icon="$ICON" icon.color="$COLOR" label="${PERCENT}%"
