#!/usr/bin/env bash
input=$(cat)
snapshot="$HOME/.claude/usage-snapshot.json"
printf '%s' "$input" | jq -c '{at: (now | floor), rate_limits}' > "$snapshot.tmp" && mv "$snapshot.tmp" "$snapshot"
printf '%s' "$input" | jq -r '
  [ (.rate_limits.five_hour.used_percentage // empty | "5h \(floor)%"),
    (.rate_limits.seven_day.used_percentage // empty | "7d \(floor)%") ] | join(" ")'
