#!/usr/bin/env bash

# Search for directories using fzf
directories="$@"
selected_dir=$(find ${directories[@]} -mindepth 1 -maxdepth 1 -type d -not -path '*/.*' 2>/dev/null | sort | fzf --delimiter="/" --nth=-1)

# Check if a directory was selected
if [[ -z "$selected_dir" ]]; then
    pwd
    exit 1
fi

echo "$selected_dir"
