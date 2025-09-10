#!/usr/bin/env bash

parser_definition() {
  setup   REST help:usage -- "Usage: [options] [directories...]" ''
  msg -- 'Interactive directory selector using fzf' ''
  msg -- 'Options:'
  param   max_depth -d --depth init:=1 -- "Set maximum search depth (default: 1)"
  param   fzf_nth   -n --nth init:=-1 -- "Set fzf field number for display (default: -1, show last field)"
  disp    :usage    -h --help           -- "Display this help message and exit."
}
eval "$(getoptions parser_definition) exit 1"

# Search for directories using fzf
directories="$@"
if [[ "$fzf_nth" == "0" ]]; then
    selected_dir=$(find ${directories[@]} -mindepth 1 -maxdepth "$max_depth" -type d -not -path '*/.*' 2>/dev/null | sort | fzf --delimiter="/")
else
    selected_dir=$(find ${directories[@]} -mindepth 1 -maxdepth "$max_depth" -type d -not -path '*/.*' 2>/dev/null | sort | fzf --delimiter="/" --nth="$fzf_nth")
fi

# Check if a directory was selected
if [[ -z "$selected_dir" ]]; then
    pwd
    exit 1
fi

echo "$selected_dir"
