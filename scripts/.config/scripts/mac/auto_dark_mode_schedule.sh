#!/usr/bin/env bash

today_month=$(date +%D)
if grep -q "$today_month" "$HOME/personal/.auto-dark-mode"; then
  echo "Already processed for $today_month. Exiting."
  exit 0
fi

# https://www.reddit.com/r/MacOS/comments/15i025e/comment/juvq2ul

currenttime=$(date +%H:%M)
if [[ "$currenttime" > "16:00" ]] || [[ "$currenttime" < "07:00" ]]; then
    osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to true'
else
    osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to false'
fi
